import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="login-container">
      <h2>Iniciar Sesión - PELUDOS</h2>
      <form (ngSubmit)="onLogin()">
        <div>
          <label>Correo:</label>
          <input type="email" [(ngModel)]="email" name="email" required />
        </div>
        <div>
          <label>Contraseña:</label>
          <input type="password" [(ngModel)]="password" name="password" required />
        </div>
        <button type="submit">Ingresar</button>
        <p *ngIf="errorMessage" style="color: red;">{{ errorMessage }}</p>
      </form>
    </div>
  `
})
export class LoginComponent {
  email = '';
  password = '';
  errorMessage = '';

  constructor(private authService: AuthService, private router: Router) {}

  onLogin() {
    const credentials = {
      username: this.email,
      password: this.password
    };

    this.authService.login(credentials).subscribe({
      next: (res: any) => {
        if (res && res.access_token) {
          localStorage.setItem('token', res.access_token);
          this.router.navigate(['/perfil']);
        }
      },
      error: (err: any) => {
        console.error('Error de autenticación', err);
        this.errorMessage = 'Usuario no registrado o contraseña incorrecta.';
        localStorage.removeItem('token');
      }
    });
  }
}
