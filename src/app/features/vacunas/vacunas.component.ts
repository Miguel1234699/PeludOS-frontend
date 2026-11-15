import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { forkJoin } from 'rxjs';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Mascota } from '../../core/models/mascota.model';
import { Vacuna } from '../../core/models/panel.model';
import { limpiar } from '../../core/utils';

function formVacio() {
  return {
    id_mascota: null as number | null,
    nombre_vacuna: '',
    fecha_aplicacion: '',
    fecha_proxima: '',
    lote: '',
    observaciones: ''
  };
}

@Component({
  selector: 'app-vacunas',
  imports: [FormsModule, DatePipe, RouterLink],
  template: `
    <div class="topbar">
      <h1>💉 Vacunas</h1>
      @if (!mostrarForm()) {
        <button class="btn btn-primary" (click)="nueva()">+ Registrar vacuna</button>
      }
    </div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    @if (mostrarForm()) {
      <div class="card">
        <h3>Nueva vacuna</h3>
        @if (mascotas().length === 0) {
          <p class="muted">Primero registra una mascota en <a routerLink="/mascotas">Mis mascotas</a>.</p>
          <div class="form-botones"><button class="btn" (click)="mostrarForm.set(false)">Cerrar</button></div>
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
              <label class="f">Vacuna *
                <input name="nombre_vacuna" [(ngModel)]="form.nombre_vacuna" required maxlength="100" />
              </label>
              <label class="f">Fecha de aplicación *
                <input type="date" name="fecha_aplicacion" [(ngModel)]="form.fecha_aplicacion" required />
              </label>
              <label class="f">Próxima dosis
                <input type="date" name="fecha_proxima" [(ngModel)]="form.fecha_proxima" />
              </label>
              <label class="f">Lote
                <input name="lote" [(ngModel)]="form.lote" maxlength="50" />
              </label>
              <label class="f ancho">Observaciones
                <textarea name="observaciones" rows="2" [(ngModel)]="form.observaciones"></textarea>
              </label>
            </div>
            <div class="form-botones">
              <button class="btn btn-primary" type="submit">Guardar</button>
              <button class="btn" type="button" (click)="mostrarForm.set(false)">Cancelar</button>
            </div>
          </form>
        }
      </div>
    }

    <div class="card">
      @if (loading()) {
        <p class="muted">Cargando vacunas...</p>
      } @else if (vacunas().length === 0) {
        <p class="muted">No hay vacunas registradas.</p>
      } @else {
        <div class="scroll">
          <table>
            <thead>
              <tr><th>Mascota</th><th>Vacuna</th><th>Aplicada</th><th>Próxima</th><th>Lote</th><th></th></tr>
            </thead>
            <tbody>
              @for (v of vacunas(); track v.id_vacuna) {
                <tr>
                  <td>{{ nombreMascota(v.id_mascota) }}</td>
                  <td>{{ v.nombre_vacuna }}@if (v.observaciones) { <div class="muted">{{ v.observaciones }}</div> }</td>
                  <td>{{ v.fecha_aplicacion | date: 'dd/MM/yyyy' }}</td>
                  <td>{{ v.fecha_proxima ? (v.fecha_proxima | date: 'dd/MM/yyyy') : '—' }}</td>
                  <td>{{ v.lote || '—' }}</td>
                  <td class="acciones">
                    <button class="btn btn-sm btn-danger" (click)="eliminar(v)">Eliminar</button>
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
export class VacunasComponent implements OnInit {
  private http = inject(HttpClient);

  vacunas = signal<Vacuna[]>([]);
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
      vacunas: this.http.get<Vacuna[]>(`${API_URL}/vacunas`),
      mascotas: this.http.get<Mascota[]>(`${API_URL}/mascotas`)
    }).subscribe({
      next: (r) => {
        this.vacunas.set(r.vacunas);
        this.mascotas.set(r.mascotas);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudieron cargar las vacunas.'));
        this.loading.set(false);
      }
    });
  }

  nombreMascota(id: number): string {
    return this.mascotas().find((m) => m.id_mascota === id)?.nombre ?? '—';
  }

  nueva(): void {
    this.form = formVacio();
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  guardar(): void {
    this.http.post<Vacuna>(`${API_URL}/vacunas`, limpiar(this.form)).subscribe({
      next: () => {
        this.ok.set('Vacuna registrada.');
        this.error.set('');
        this.mostrarForm.set(false);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo registrar la vacuna.'))
    });
  }

  eliminar(v: Vacuna): void {
    if (!confirm(`¿Eliminar la vacuna «${v.nombre_vacuna}»?`)) return;
    this.http.delete(`${API_URL}/vacunas/${v.id_vacuna}`).subscribe({
      next: () => {
        this.ok.set('Vacuna eliminada.');
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo eliminar la vacuna.'))
    });
  }
}