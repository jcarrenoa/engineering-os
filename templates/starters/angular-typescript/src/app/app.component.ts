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
  readonly title = '__PROJECT_NAME__';
  status = '';
  ok     = false;

  constructor(private http: HttpClient) {}

  checkHealth() {
    this.status = 'Connecting...';
    this.http.get('/health').subscribe({
      next: (data) => {
        this.ok     = true;
        this.status = '✓  ' + JSON.stringify(data);
      },
      error: (e) => {
        this.ok     = false;
        this.status = '✗  ' + e.message;
      },
    });
  }
}
