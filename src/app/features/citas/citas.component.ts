import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { forkJoin } from 'rxjs';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Mascota } from '../../core/models/mascota.model';
import { Cita, Veterinaria } from '../../core/models/panel.model';
import { limpiar } from '../../core/utils';

function formVacio() {
  return {
    id_mascota: null as number | null,
    id_veterinaria: null as number | null,
    fecha_hora: '',
    motivo: '',
    notas: ''
  };
}

@Component({
  selector: 'app-citas',
  imports: [FormsModule, DatePipe, RouterLink],
  template: `
    <div class="topbar">
      <h1>📅 Citas</h1>
      @if (!mostrarForm()) {
        <button class="btn btn-primary" (click)="nueva()">+ Agendar cita</button>
      }
    </div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    @if (mostrarForm()) {
      <div class="card">
        <h3>Nueva cita</h3>
        @if (mascotas().length === 0) {
          <p class="muted">Primero registra una mascota en <a routerLink="/mascotas">Mis mascotas</a>.</p>
        } @else if (veterinarias().length === 0) {
          <p class="muted">No hay veterinarias registradas. Agrega una en <a routerLink="/veterinarias">Veterinarias</a>.</p>
        } @else {
          <form ngNativeValidate (ngSubmit)="guardar()">
            <div class="form-grid">
              <label class="f">Mascota *
                <select name="id_mascota" [(ngModel)]="form.id_mascota" required>
                  <option [ngValue]="null" disabled>Selecciona...</option>
                  @for (m of mascotas(); track m.id_mascota) {
                    <option [ngValue]="m.id_mascota">{{ m.nombre }}</option>
                  }
                </select>
              </label>
              <label class="f">Veterinaria *
                <select name="id_veterinaria" [(ngModel)]="form.id_veterinaria" required>
                  <option [ngValue]="null" disabled>Selecciona...</option>
                  @for (v of veterinarias(); track v.id_veterinaria) {
                    <option [ngValue]="v.id_veterinaria">{{ v.nombre_comercial }}</option>
                  }
                </select>
              </label>
              <label class="f">Fecha y hora *
                <input type="datetime-local" name="fecha_hora" [(ngModel)]="form.fecha_hora" required />
              </label>
              <label class="f">Motivo *
                <input name="motivo" [(ngModel)]="form.motivo" required />
              </label>
              <label class="f ancho">Notas
                <textarea name="notas" rows="2" [(ngModel)]="form.notas"></textarea>
              </label>
            </div>
            <div class="form-botones">
              <button class="btn btn-primary" type="submit">Agendar</button>
              <button class="btn" type="button" (click)="mostrarForm.set(false)">Cancelar</button>
            </div>
          </form>
        }
        @if (mascotas().length === 0 || veterinarias().length === 0) {
          <div class="form-botones"><button class="btn" (click)="mostrarForm.set(false)">Cerrar</button></div>
        }
      </div>
    }

    <div class="card">
      @if (loading()) {
        <p class="muted">Cargando citas...</p>
      } @else if (ordenadas().length === 0) {
        <p class="muted">No tienes citas agendadas.</p>
      } @else {
        <div class="scroll">
          <table>
            <thead>
              <tr><th>Fecha</th><th>Mascota</th><th>Veterinaria</th><th>Motivo</th><th>Estado</th><th></th></tr>
            </thead>
            <tbody>
              @for (c of ordenadas(); track c.id_cita) {
                <tr>
                  <td>{{ c.fecha_hora | date: 'dd/MM/yyyy, h:mm a' }}</td>
                  <td>{{ nombreMascota(c.id_mascota) }}</td>
                  <td>{{ nombreVeterinaria(c.id_veterinaria) }}</td>
                  <td>{{ c.motivo }}@if (c.notas) { <div class="muted">{{ c.notas }}</div> }</td>
                  <td><span [class]="'badge ' + c.estado">{{ c.estado }}</span></td>
                  <td class="acciones">
                    @if (c.estado !== 'cancelada') {
                      <button class="btn btn-sm" (click)="cancelarCita(c)">Cancelar cita</button>
                    }
                    <button class="btn btn-sm btn-danger" (click)="eliminar(c)">Eliminar</button>
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
export class CitasComponent implements OnInit {
  private http = inject(HttpClient);

  citas = signal<Cita[]>([]);
  mascotas = signal<Mascota[]>([]);
  veterinarias = signal<Veterinaria[]>([]);
  loading = signal(true);
  error = signal('');
  ok = signal('');
  mostrarForm = signal(false);
  form = formVacio();

  ordenadas = computed(() =>
    [...this.citas()].sort((a, b) => new Date(b.fecha_hora).getTime() - new Date(a.fecha_hora).getTime())
  );

  ngOnInit(): void {
    this.cargar();
  }

  cargar(): void {
    forkJoin({
      citas: this.http.get<Cita[]>(`${API_URL}/citas`),
      mascotas: this.http.get<Mascota[]>(`${API_URL}/mascotas`),
      veterinarias: this.http.get<Veterinaria[]>(`${API_URL}/veterinarias`)
    }).subscribe({
      next: (r) => {
        this.citas.set(r.citas);
        this.mascotas.set(r.mascotas);
        this.veterinarias.set(r.veterinarias);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudieron cargar las citas.'));
        this.loading.set(false);
      }
    });
  }

  nombreMascota(id: number): string {
    return this.mascotas().find((m) => m.id_mascota === id)?.nombre ?? '—';
  }

  nombreVeterinaria(id: number): string {
    return this.veterinarias().find((v) => v.id_veterinaria === id)?.nombre_comercial ?? '—';
  }

  nueva(): void {
    this.form = formVacio();
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  guardar(): void {
    this.http.post<Cita>(`${API_URL}/citas`, limpiar(this.form)).subscribe({
      next: () => {
        this.ok.set('Cita agendada.');
        this.error.set('');
        this.mostrarForm.set(false);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo agendar la cita.'))
    });
  }

  cancelarCita(c: Cita): void {
    this.http.patch<Cita>(`${API_URL}/citas/${c.id_cita}`, { estado: 'cancelada' }).subscribe({
      next: () => {
        this.ok.set('Cita cancelada.');
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo cancelar la cita.'))
    });
  }

  eliminar(c: Cita): void {
    if (!confirm('¿Eliminar esta cita?')) return;
    this.http.delete(`${API_URL}/citas/${c.id_cita}`).subscribe({
      next: () => {
        this.ok.set('Cita eliminada.');
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo eliminar la cita.'))
    });
  }
}