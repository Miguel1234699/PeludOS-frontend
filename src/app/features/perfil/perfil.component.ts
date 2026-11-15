import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Usuario } from '../../core/models/usuario.model';
import { AuthService } from '../../core/services/auth.service';
import { limpiar } from '../../core/utils';

@Component({
  selector: 'app-perfil',
  imports: [FormsModule, DatePipe],
  template: `
    <div class="topbar"><h1>👤 Mi perfil</h1></div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    <div class="card">
      <h3>Datos de la cuenta</h3>
      <p><b>Correo:</b> {{ auth.usuario()?.correo_electronico }}</p>
      <p><b>Rol:</b> {{ auth.usuario()?.rol }}</p>
      <p class="muted">Miembro desde {{ auth.usuario()?.fecha_registro | date: 'dd/MM/yyyy' }}</p>
    </div>

    <div class="card">
      <h3>Editar datos</h3>
      <form ngNativeValidate (ngSubmit)="guardar()">
        <div class="form-grid">
          <label class="f">Nombre completo *
            <input name="nombre_completo" [(ngModel)]="form.nombre_completo" required maxlength="100" />
          </label>
          <label class="f">Teléfono
            <input name="telefono" [(ngModel)]="form.telefono" maxlength="20" />
          </label>
          <label class="f ancho">Dirección
            <input name="direccion" [(ngModel)]="form.direccion" />
          </label>
        </div>
        <div class="form-botones">
          <button class="btn btn-primary" type="submit">Guardar cambios</button>
        </div>
      </form>
    </div>
  `
})
export class PerfilComponent implements OnInit {
  private http = inject(HttpClient);
  auth = inject(AuthService);

  error = signal('');
  ok = signal('');
  form = { nombre_completo: '', telefono: '', direccion: '' };

  ngOnInit(): void {
    const u = this.auth.usuario();
    this.form = {
      nombre_completo: u?.nombre_completo ?? '',
      telefono: u?.telefono ?? '',
      direccion: u?.direccion ?? ''
    };
  }

  guardar(): void {
    this.http.patch<Usuario>(`${API_URL}/usuarios/me`, limpiar(this.form, true)).subscribe({
      next: (u) => {
        this.auth.usuario.set(u);
        this.ok.set('Datos actualizados.');
        this.error.set('');
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudieron guardar los cambios.'))
    });
  }
}