import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  readonly title   = '__PROJECT_NAME__';
  readonly stack   = 'Angular';
  status   = '';
  response = '';
  ok       = false;
  loading  = false;

  constructor(private http: HttpClient) {}

  checkHealth() {
    this.loading  = true;
    this.status   = '';
    this.response = '';
    this.http.get('/health').subscribe({
      next: (data) => {
        this.ok       = true;
        this.status   = 'healthy';
        this.response = JSON.stringify(data, null, 2);
        this.loading  = false;
      },
      error: (e) => {
        this.ok       = false;
        this.status   = 'unreachable';
        this.response = e.message;
        this.loading  = false;
      },
    });
  }
}
