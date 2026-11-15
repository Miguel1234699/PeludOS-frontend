import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.html',
  styleUrl: './login.css'
})
export class Login {
  correo = '';
  contrasena = '';

  private authService = inject(AuthService);
  private router = inject(Router);

  onLogin() {
    const credenciales = { correo: this.correo, contrasena: this.contrasena };
    this.authService.login(credenciales).subscribe({
      next: () => {
        alert('¡Bienvenido a PeludOS!');
        this.router.navigate(['/inicio']);
      },
      error: (err) => {
        console.error('Error de autenticación', err);
        alert('Correo o contraseña incorrectos.');
      }
    });
  }
}
