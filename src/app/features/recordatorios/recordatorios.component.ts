import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Mascota } from '../../core/models/mascota.model';
import { Recordatorio } from '../../core/models/panel.model';
import { limpiar } from '../../core/utils';

function formVacio() {
  return {
    titulo: '',
    descripcion: '',
    tipo: '',
    fecha_recordatorio: '',
    id_mascota: null as number | null
  };
}

@Component({
  selector: 'app-recordatorios',
  imports: [FormsModule, DatePipe],
  template: `
    <div class="topbar">
      <h1>⏰ Recordatorios</h1>
      @if (!mostrarForm()) {
        <button class="btn btn-primary" (click)="nuevo()">+ Nuevo recordatorio</button>
      }
    </div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    @if (mostrarForm()) {
      <div class="card">
        <h3>Nuevo recordatorio</h3>
        <form ngNativeValidate (ngSubmit)="guardar()">
          <div class="form-grid">
            <label class="f">Título *
              <input name="titulo" [(ngModel)]="form.titulo" required />
            </label>
            <label class="f">Fecha y hora *
              <input type="datetime-local" name="fecha_recordatorio" [(ngModel)]="form.fecha_recordatorio" required />
            </label>
            <label class="f">Tipo
              <select name="tipo" [(ngModel)]="form.tipo">
                <option value="">—</option>
                <option value="Vacuna">Vacuna</option>
                <option value="Medicamento">Medicamento</option>
                <option value="Cita">Cita</option>
                <option value="Desparasitación">Desparasitación</option>
                <option value="Otro">Otro</option>
              </select>
            </label>
            <label class="f">Mascota
              <select name="id_mascota" [(ngModel)]="form.id_mascota">
                <option [ngValue]="null">Ninguna</option>
                @for (m of mascotas(); track m.id_mascota) {
                  <option [ngValue]="m.id_mascota">{{ m.nombre }}</option>
                }
              </select>
            </label>
            <label class="f ancho">Descripción
              <textarea name="descripcion" rows="2" [(ngModel)]="form.descripcion"></textarea>
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
        <p class="muted">Cargando recordatorios...</p>
      } @else if (recordatorios().length === 0) {
        <p class="muted">No tienes recordatorios.</p>
      } @else {
        <div class="scroll">
          <table>
            <thead>
              <tr><th>Fecha</th><th>Título</th><th>Tipo</th><th>Mascota</th><th>Estado</th><th></th></tr>
            </thead>
            <tbody>
              @for (r of recordatorios(); track r.id_recordatorio) {
                <tr>
                  <td>{{ r.fecha_recordatorio | date: 'dd/MM/yyyy, h:mm a' }}</td>
                  <td>{{ r.titulo }}@if (r.descripcion) { <div class="muted">{{ r.descripcion }}</div> }</td>
                  <td>{{ r.tipo || '—' }}</td>
                  <td>{{ nombreMascota(r.id_mascota) }}</td>
                  <td>
                    <span [class]="'badge ' + (r.completado ? 'completada' : '')">
                      {{ r.completado ? 'Completado' : 'Pendiente' }}
                    </span>
                  </td>
                  <td class="acciones">
                    <button class="btn btn-sm" (click)="alternar(r)">
                      {{ r.completado ? 'Reabrir' : 'Marcar hecho' }}
                    </button>
                    <button class="btn btn-sm btn-danger" (click)="eliminar(r)">Eliminar</button>
                  </td>
                </tr>
              }
            </tbody>
          </table>
        </div>
      }
    </div>
  `
})
export class RecordatoriosComponent implements OnInit {
  private http = inject(HttpClient);

  recordatorios = signal<Recordatorio[]>([]);
  mascotas = signal<Mascota[]>([]);
  loading = signal(true);
  error = signal('');
  ok = signal('');
  mostrarForm = signal(false);
  form = formVacio();

  ngOnInit(): void {
    this.cargar();
  }

  cargar(): void {
    forkJoin({
      recordatorios: this.http.get<Recordatorio[]>(`${API_URL}/recordatorios`),
      mascotas: this.http.get<Mascota[]>(`${API_URL}/mascotas`)
    }).subscribe({
      next: (r) => {
        this.recordatorios.set(r.recordatorios);
        this.mascotas.set(r.mascotas);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudieron cargar los recordatorios.'));
        this.loading.set(false);
      }
    });
  }

  nombreMascota(id: number | null): string {
    if (id === null) return '—';
    return this.mascotas().find((m) => m.id_mascota === id)?.nombre ?? '—';
  }

  nuevo(): void {
    this.form = formVacio();
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  guardar(): void {
    this.http.post<Recordatorio>(`${API_URL}/recordatorios`, limpiar(this.form)).subscribe({
      next: () => {
        this.ok.set('Recordatorio creado.');
        this.error.set('');
        this.mostrarForm.set(false);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo crear el recordatorio.'))
    });
  }

  alternar(r: Recordatorio): void {
    this.http
      .patch<Recordatorio>(`${API_URL}/recordatorios/${r.id_recordatorio}`, { completado: !r.completado })
      .subscribe({
        next: () => this.cargar(),
        error: (err) => this.error.set(mensajeError(err, 'No se pudo actualizar.'))
      });
  }

  eliminar(r: Recordatorio): void {
    if (!confirm('¿Eliminar este recordatorio?')) return;
    this.http.delete(`${API_URL}/recordatorios/${r.id_recordatorio}`).subscribe({
      next: () => {
        this.ok.set('Recordatorio eliminado.');
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo eliminar.'))
    });
  }
}