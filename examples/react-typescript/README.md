# Example — React + TypeScript

This example shows how Engineering OS frontend architecture (MVVM + Clean Architecture + Feature-First) maps to a React project using TypeScript and custom hooks as ViewModels.

---

## Architecture Mapping

| Engineering OS Concept | React / TypeScript Implementation |
|---|---|
| ViewModel | Custom hook (`useLoginViewModel`) that manages and exposes state |
| View | React component that consumes the ViewModel hook |
| Repository Interface | TypeScript interface in `domain/repositories/` |
| Repository Implementation | Class in `data/repositories/` implementing the interface |
| Use Case | Class in `domain/use_cases/` with a single `execute()` method |
| Dependency Injection | Factory functions or a DI container (e.g., `tsyringe`) |
| Domain Entity | Plain TypeScript type or class — no React, no axios |
| State Management | Zustand store or React state inside the ViewModel hook |
| DTO / Response Model | Zod schema or type in `data/models/` |

---

## Folder Structure

```
src/
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── User.ts                    ← plain TypeScript type
│       │   ├── repositories/
│       │   │   └── AuthRepository.ts          ← interface
│       │   └── use_cases/
│       │       └── LoginUseCase.ts
│       ├── data/
│       │   ├── repositories/
│       │   │   └── AuthRepositoryImpl.ts      ← implements AuthRepository
│       │   ├── datasources/
│       │   │   └── AuthApiClient.ts           ← axios/fetch wrapper
│       │   └── models/
│       │       └── UserResponse.ts            ← API response shape
│       └── presentation/
│           ├── viewmodels/
│           │   └── useLoginViewModel.ts       ← custom hook (ViewModel)
│           ├── views/
│           │   └── LoginPage.tsx              ← thin component
│           └── components/
│               └── LoginForm.tsx
├── core/
│   ├── network/
│   │   └── httpClient.ts
│   ├── di/
│   │   └── container.ts                       ← dependency wiring
│   └── errors/
│       └── AppError.ts
└── shared/
    ├── ui/
    │   └── Button.tsx
    └── utils/
        └── validators.ts
```

---

## Key Patterns

### Domain Entity (no React, no axios)

```typescript
// features/auth/domain/entities/User.ts

export interface User {
  readonly id: string;
  readonly email: string;
  readonly name: string;
}
```

Plain TypeScript. No library imports.

---

### Repository Interface (domain layer)

```typescript
// features/auth/domain/repositories/AuthRepository.ts

import { User } from '../entities/User';

export interface AuthRepository {
  login(email: string, password: string): Promise<User>;
  logout(): Promise<void>;
  getCurrentUser(): Promise<User | null>;
}
```

No axios. No fetch. No HTTP concepts.

---

### Use Case (domain layer)

```typescript
// features/auth/domain/use_cases/LoginUseCase.ts

import { AuthRepository } from '../repositories/AuthRepository';
import { User } from '../entities/User';

export class LoginUseCase {
  constructor(private readonly repository: AuthRepository) {}

  async execute(email: string, password: string): Promise<User> {
    return this.repository.login(email, password);
  }
}
```

One class. One method. No framework imports.

---

### ViewModel — Custom Hook

```typescript
// features/auth/presentation/viewmodels/useLoginViewModel.ts

import { useState } from 'react';
import { LoginUseCase } from '../../domain/use_cases/LoginUseCase';
import { User } from '../../domain/entities/User';

interface LoginState {
  user: User | null;
  isLoading: boolean;
  error: string | null;
}

export function useLoginViewModel(loginUseCase: LoginUseCase) {
  const [state, setState] = useState<LoginState>({
    user: null,
    isLoading: false,
    error: null,
  });

  async function login(email: string, password: string): Promise<void> {
    setState(prev => ({ ...prev, isLoading: true, error: null }));
    try {
      const user = await loginUseCase.execute(email, password);
      setState({ user, isLoading: false, error: null });
    } catch (err) {
      setState(prev => ({ ...prev, isLoading: false, error: String(err) }));
    }
  }

  return { state, login };
}
```

The hook manages state.

The hook delegates to the use case.

The hook never calls APIs directly.

---

### View (thin component — no logic)

```tsx
// features/auth/presentation/views/LoginPage.tsx

import { useLoginViewModel } from '../viewmodels/useLoginViewModel';
import { LoginForm } from '../components/LoginForm';
import { container } from '../../../../core/di/container';

export function LoginPage() {
  const { state, login } = useLoginViewModel(container.loginUseCase);

  if (state.isLoading) return <p>Loading...</p>;

  return (
    <LoginForm
      onSubmit={login}
      error={state.error}
    />
  );
}
```

The component renders state and delegates interactions.

No business logic. No API calls. No conditional domain logic.

---

### Repository Implementation (data layer)

```typescript
// features/auth/data/repositories/AuthRepositoryImpl.ts

import { AuthRepository } from '../../domain/repositories/AuthRepository';
import { User } from '../../domain/entities/User';
import { AuthApiClient } from '../datasources/AuthApiClient';
import { UserResponse } from '../models/UserResponse';

export class AuthRepositoryImpl implements AuthRepository {
  constructor(private readonly apiClient: AuthApiClient) {}

  async login(email: string, password: string): Promise<User> {
    const response: UserResponse = await this.apiClient.login(email, password);
    return { id: response.user_id, email: response.email, name: response.full_name };
  }

  async logout(): Promise<void> {
    await this.apiClient.logout();
  }

  async getCurrentUser(): Promise<User | null> {
    return this.apiClient.me().catch(() => null);
  }
}
```

Maps from API response shape to domain entity.

Domain entity never knows about the API response shape.

---

### Dependency Wiring

```typescript
// core/di/container.ts

import { AuthRepositoryImpl } from '../../features/auth/data/repositories/AuthRepositoryImpl';
import { AuthApiClient } from '../../features/auth/data/datasources/AuthApiClient';
import { LoginUseCase } from '../../features/auth/domain/use_cases/LoginUseCase';
import { httpClient } from '../network/httpClient';

const authApiClient = new AuthApiClient(httpClient);
const authRepository = new AuthRepositoryImpl(authApiClient);

export const container = {
  loginUseCase: new LoginUseCase(authRepository),
};
```

All wiring happens in one place.

Components and hooks receive ready-to-use instances.

---

## Dependency Direction

```
LoginPage (View)
  └── useLoginViewModel (ViewModel hook)
        └── LoginUseCase
              └── AuthRepository (interface)
                    └── AuthRepositoryImpl
                          └── AuthApiClient (axios)
```

React never appears below the presentation layer.

axios never appears above the data layer.

---

## Testing

```typescript
// Unit test — ViewModel hook with mocked use case
import { renderHook, act } from '@testing-library/react';
import { useLoginViewModel } from './useLoginViewModel';

test('login sets user on success', async () => {
  const mockUseCase = {
    execute: jest.fn().mockResolvedValue({ id: '1', email: 'a@b.com', name: 'Alice' }),
  } as unknown as LoginUseCase;

  const { result } = renderHook(() => useLoginViewModel(mockUseCase));

  await act(async () => {
    await result.current.login('a@b.com', 'password');
  });

  expect(result.current.state.user?.email).toBe('a@b.com');
  expect(result.current.state.isLoading).toBe(false);
});
```

No component rendering needed to test the ViewModel.

No HTTP calls. No real dependencies.
