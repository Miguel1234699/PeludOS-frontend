import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-registro',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './registro.html',
  styleUrl: './registro.css'
})
export class Registro {
  nombre = '';
  correo = '';
  contrasena = '';
  telefono = '';
  direccion = '';

  private authService = inject(AuthService);
  private router = inject(Router);

  onSubmit() {
    const datos: any = {
      nombre_completo: this.nombre.trim(),
      correo_electronico: this.correo.trim(),
      contrasena: this.contrasena,
      telefono: this.telefono.trim() || null,
      direccion: this.direccion.trim() || null
    };

    this.authService.registrar(datos).subscribe({
      next: () => {
        alert('¡Registro exitoso! Redirigiendo al login...');
        this.router.navigate(['/login']);
      },
      error: (err) => {
        console.error('Error de registro', err);
        const detalle = err?.error?.detail;
        alert(typeof detalle === 'string' ? detalle : 'No se pudo registrar. Revisa los datos.');
      }
    });
  }
}
