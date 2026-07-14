# Example — FastAPI + Hexagonal Architecture

This example shows how Engineering OS backend architecture (Hexagonal Architecture + DDD + SOLID) maps to a FastAPI project in Python.

---

## Architecture Mapping

| Engineering OS Concept | FastAPI Implementation |
|---|---|
| Inbound Port | Abstract class in `application/ports/inbound/` |
| Outbound Port | Abstract class in `application/ports/outbound/` |
| Inbound Adapter | FastAPI route handler in `infrastructure/adapters/inbound/http/` |
| Outbound Adapter | Repository implementation in `infrastructure/adapters/outbound/persistence/` |
| Use Case | Class in `application/use_cases/` with a single `execute()` async method |
| Domain Entity | Plain Python dataclass or class — no Pydantic, no SQLAlchemy |
| Repository Interface | Abstract class in `domain/repositories/` |
| DTO | Pydantic model in `application/dtos/` |
| Persistence Model | SQLAlchemy model in `infrastructure/adapters/outbound/persistence/` |
| Dependency Injection | FastAPI `Depends()` at the adapter layer only |

---

## Folder Structure

```
src/
└── auth/                                    ← bounded context
    ├── domain/
    │   ├── entities/
    │   │   └── user.py                      ← plain Python class, no dependencies
    │   ├── value_objects/
    │   │   └── email.py
    │   ├── repositories/
    │   │   └── user_repository.py           ← abstract class (interface)
    │   ├── services/
    │   │   └── password_service.py          ← domain service
    │   └── events/
    │       └── user_registered.py
    ├── application/
    │   ├── use_cases/
    │   │   ├── login_use_case.py
    │   │   └── register_user_use_case.py
    │   ├── ports/
    │   │   ├── inbound/
    │   │   │   └── login_port.py            ← interface the HTTP adapter calls
    │   │   └── outbound/
    │   │       └── token_service_port.py    ← interface for JWT generation
    │   └── dtos/
    │       ├── login_request_dto.py
    │       └── login_response_dto.py
    └── infrastructure/
        └── adapters/
            ├── inbound/
            │   └── http/
            │       └── auth_router.py       ← FastAPI router (thin)
            └── outbound/
                ├── persistence/
                │   ├── user_repository_impl.py
                │   └── user_orm_model.py    ← SQLAlchemy model
                └── security/
                    └── jwt_token_service.py ← implements token_service_port
```

---

## Key Patterns

### Domain Entity (zero external dependencies)

```python
# src/auth/domain/entities/user.py
from dataclasses import dataclass
from src.auth.domain.value_objects.email import Email


@dataclass
class User:
    id: str
    email: Email
    name: str
    hashed_password: str
    is_active: bool = True

    def deactivate(self) -> None:
        self.is_active = False
```

No Pydantic. No SQLAlchemy. No FastAPI. Just Python.

---

### Value Object (immutable, self-validating)

```python
# src/auth/domain/value_objects/email.py
from dataclasses import dataclass
import re


@dataclass(frozen=True)
class Email:
    value: str

    def __post_init__(self) -> None:
        if not re.match(r"^[\w.-]+@[\w.-]+\.\w+$", self.value):
            raise ValueError(f"Invalid email: {self.value}")
```

---

### Repository Interface (domain layer)

```python
# src/auth/domain/repositories/user_repository.py
from abc import ABC, abstractmethod
from src.auth.domain.entities.user import User


class UserRepository(ABC):

    @abstractmethod
    async def find_by_email(self, email: str) -> User | None:
        ...

    @abstractmethod
    async def save(self, user: User) -> None:
        ...
```

No database concepts. No SQL. No ORM. Pure domain language.

---

### Use Case (application layer)

```python
# src/auth/application/use_cases/login_use_case.py
from src.auth.domain.repositories.user_repository import UserRepository
from src.auth.application.ports.outbound.token_service_port import TokenServicePort
from src.auth.application.dtos.login_request_dto import LoginRequestDTO
from src.auth.application.dtos.login_response_dto import LoginResponseDTO


class LoginUseCase:

    def __init__(
        self,
        user_repository: UserRepository,
        token_service: TokenServicePort,
        password_service: PasswordService,
    ) -> None:
        self._user_repository = user_repository
        self._token_service = token_service
        self._password_service = password_service

    async def execute(self, request: LoginRequestDTO) -> LoginResponseDTO:
        user = await self._user_repository.find_by_email(request.email)
        if user is None:
            raise InvalidCredentialsError()

        if not self._password_service.verify(request.password, user.hashed_password):
            raise InvalidCredentialsError()

        token = await self._token_service.generate(user_id=user.id)
        return LoginResponseDTO(token=token, user_id=user.id)
```

No HTTP. No FastAPI. No database. Fully testable in isolation.

---

### HTTP Adapter (inbound — thin router)

```python
# src/auth/infrastructure/adapters/inbound/http/auth_router.py
from fastapi import APIRouter, Depends
from src.auth.application.use_cases.login_use_case import LoginUseCase
from src.auth.application.dtos.login_request_dto import LoginRequestDTO
from src.auth.application.dtos.login_response_dto import LoginResponseDTO
from src.auth.infrastructure.dependencies import get_login_use_case

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login", response_model=LoginResponseDTO)
async def login(
    request: LoginRequestDTO,
    use_case: LoginUseCase = Depends(get_login_use_case),
) -> LoginResponseDTO:
    return await use_case.execute(request)
```

The router does nothing except receive the request and call the use case.

All business logic lives in the use case.

---

### Dependency Wiring

```python
# src/auth/infrastructure/dependencies.py
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from src.auth.application.use_cases.login_use_case import LoginUseCase
from src.auth.infrastructure.adapters.outbound.persistence.user_repository_impl import UserRepositoryImpl
from src.auth.infrastructure.adapters.outbound.security.jwt_token_service import JwtTokenService
from src.core.database import get_db_session


def get_login_use_case(
    session: AsyncSession = Depends(get_db_session),
) -> LoginUseCase:
    return LoginUseCase(
        user_repository=UserRepositoryImpl(session),
        token_service=JwtTokenService(),
        password_service=BcryptPasswordService(),
    )
```

Dependency injection happens at the infrastructure boundary.

The use case never imports FastAPI.

---

### Repository Implementation (infrastructure layer)

```python
# src/auth/infrastructure/adapters/outbound/persistence/user_repository_impl.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from src.auth.domain.repositories.user_repository import UserRepository
from src.auth.domain.entities.user import User
from src.auth.infrastructure.adapters.outbound.persistence.user_orm_model import UserOrmModel


class UserRepositoryImpl(UserRepository):

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def find_by_email(self, email: str) -> User | None:
        result = await self._session.execute(
            select(UserOrmModel).where(UserOrmModel.email == email)
        )
        orm_user = result.scalar_one_or_none()
        return orm_user.to_domain() if orm_user else None

    async def save(self, user: User) -> None:
        orm_user = UserOrmModel.from_domain(user)
        self._session.add(orm_user)
        await self._session.flush()
```

SQLAlchemy stays in the infrastructure layer.

Domain entities are mapped to/from ORM models here — never in the domain.

---

## Dependency Direction

```
HTTP Router (FastAPI)
  └── LoginUseCase
        ├── UserRepository (abstract)
        │     └── UserRepositoryImpl (SQLAlchemy)
        ├── TokenServicePort (abstract)
        │     └── JwtTokenService
        └── PasswordService (abstract)
              └── BcryptPasswordService
```

FastAPI never appears in the domain or application layers.

SQLAlchemy never appears in the domain layer.

---

## Testing

```python
# Unit test — use case with mocked dependencies
import pytest
from unittest.mock import AsyncMock
from src.auth.application.use_cases.login_use_case import LoginUseCase

async def test_login_fails_when_user_does_not_exist():
    mock_repo = AsyncMock()
    mock_repo.find_by_email.return_value = None

    use_case = LoginUseCase(
        user_repository=mock_repo,
        token_service=AsyncMock(),
        password_service=AsyncMock(),
    )

    with pytest.raises(InvalidCredentialsError):
        await use_case.execute(LoginRequestDTO(email="x@y.com", password="pass"))
```

No FastAPI test client. No database. Instant execution.
