import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';

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

  private router = inject(Router);

  onSubmit() {
    alert('¡Registro exitoso! Redirigiendo al login...');
    this.router.navigate(['/login']);
  }
}
