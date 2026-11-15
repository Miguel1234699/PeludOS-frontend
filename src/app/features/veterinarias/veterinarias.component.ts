import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Veterinaria } from '../../core/models/panel.model';
import { limpiar } from '../../core/utils';

function formVacio() {
  return {
    nombre_comercial: '',
    direccion: '',
    telefono: '',
    correo_electronico: '',
    horario_atencion: ''
  };
}

@Component({
  selector: 'app-veterinarias',
  imports: [FormsModule],
  template: `
    <div class="topbar">
      <h1>🏥 Veterinarias</h1>
      @if (!mostrarForm()) {
        <button class="btn btn-primary" (click)="nueva()">+ Agregar veterinaria</button>
      }
    </div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    @if (mostrarForm()) {
      <div class="card">
        <h3>Nueva veterinaria</h3>
        <form ngNativeValidate (ngSubmit)="guardar()">
          <div class="form-grid">
            <label class="f">Nombre comercial *
              <input name="nombre_comercial" [(ngModel)]="form.nombre_comercial" required />
            </label>
            <label class="f">Dirección *
              <input name="direccion" [(ngModel)]="form.direccion" required />
            </label>
            <label class="f">Teléfono *
              <input name="telefono" [(ngModel)]="form.telefono" required />
            </label>
            <label class="f">Correo
              <input type="email" name="correo_electronico" [(ngModel)]="form.correo_electronico" />
            </label>
            <label class="f ancho">Horario de atención
              <input name="horario_atencion" placeholder="Lun a Vie 8:00 - 18:00" [(ngModel)]="form.horario_atencion" />
            </label>
          </div>
          <div class="form-botones">
            <button class="btn btn-primary" type="submit">Guardar</button>
            <button class="btn" type="button" (click)="mostrarForm.set(false)">Cancelar</button>
          </div>
        </form>
      </div>
    }

    <div class="card">
      @if (loading()) {
        <p class="muted">Cargando veterinarias...</p>
      } @else if (veterinarias().length === 0) {
        <p class="muted">No hay veterinarias registradas todavía.</p>
      } @else {
        <div class="scroll">
          <table>
            <thead>
              <tr><th>Nombre</th><th>Dirección</th><th>Teléfono</th><th>Horario</th><th>Calificación</th></tr>
            </thead>
            <tbody>
              @for (v of veterinarias(); track v.id_veterinaria) {
                <tr>
                  <td><b>{{ v.nombre_comercial }}</b>@if (v.correo_electronico) { <div class="muted">{{ v.correo_electronico }}</div> }</td>
                  <td>{{ v.direccion }}</td>
                  <td>{{ v.telefono }}</td>
                  <td>{{ v.horario_atencion || '—' }}</td>
                  <td>⭐ {{ v.calificacion_promedio }}</td>
                </tr>
              }
            </tbody>
          </table>
        </div>
      }
    </div>
  `
})
export class VeterinariasComponent implements OnInit {
  private http = inject(HttpClient);

  veterinarias = signal<Veterinaria[]>([]);
  loading = signal(true);
  error = signal('');
  ok = signal('');
  mostrarForm = signal(false);
  form = formVacio();

  ngOnInit(): void {
    this.cargar();
  }

  cargar(): void {
    this.http.get<Veterinaria[]>(`${API_URL}/veterinarias`).subscribe({
      next: (data) => {
        this.veterinarias.set(data);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudieron cargar las veterinarias.'));
        this.loading.set(false);
      }
    });
  }

  nueva(): void {
    this.form = formVacio();
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  guardar(): void {
    this.http.post<Veterinaria>(`${API_URL}/veterinarias`, limpiar(this.form)).subscribe({
      next: () => {
        this.ok.set('Veterinaria agregada.');
        this.error.set('');
        this.mostrarForm.set(false);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo agregar la veterinaria.'))
    });
  }
}