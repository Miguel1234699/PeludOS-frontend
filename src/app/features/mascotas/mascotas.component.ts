import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Mascota } from '../../core/models/mascota.model';
import { limpiar } from '../../core/utils';

function formVacio() {
  return {
    nombre: '',
    especie: 'Perro',
    raza: '',
    sexo: '',
    fecha_nacimiento: '',
    peso_kg: null as number | null,
    color_mascota: '',
    numero_chip: '',
    alergias: '',
    condiciones_medicas: ''
  };
}

@Component({
  selector: 'app-mascotas',
  imports: [FormsModule, DatePipe],
  template: `
    <div class="topbar">
      <h1>🐶 Mis mascotas</h1>
      @if (!mostrarForm()) {
        <button class="btn btn-primary" (click)="nueva()">+ Agregar mascota</button>
      }
    </div>

    @if (error()) { <div class="msg-error">{{ error() }}</div> }
    @if (ok()) { <div class="msg-ok">{{ ok() }}</div> }

    @if (mostrarForm()) {
      <div class="card">
        <h3>{{ editandoId() === null ? 'Nueva mascota' : 'Editar mascota' }}</h3>
        <form ngNativeValidate (ngSubmit)="guardar()">
          <div class="form-grid">
            <label class="f">Nombre *
              <input name="nombre" [(ngModel)]="form.nombre" required maxlength="50" />
            </label>
            <label class="f">Especie *
              <select name="especie" [(ngModel)]="form.especie" required>
                <option value="Perro">Perro</option>
                <option value="Gato">Gato</option>
                <option value="Ave">Ave</option>
                <option value="Conejo">Conejo</option>
                <option value="Otro">Otro</option>
              </select>
            </label>
            <label class="f">Raza
              <input name="raza" [(ngModel)]="form.raza" maxlength="50" />
            </label>
            <label class="f">Sexo
              <select name="sexo" [(ngModel)]="form.sexo">
                <option value="">—</option>
                <option value="Macho">Macho</option>
                <option value="Hembra">Hembra</option>
              </select>
            </label>
            <label class="f">Fecha de nacimiento
              <input type="date" name="fecha_nacimiento" [(ngModel)]="form.fecha_nacimiento" />
            </label>
            <label class="f">Peso (kg)
              <input type="number" step="0.1" min="0" name="peso_kg" [(ngModel)]="form.peso_kg" />
            </label>
            <label class="f">Color
              <input name="color_mascota" [(ngModel)]="form.color_mascota" maxlength="30" />
            </label>
            <label class="f">N.º de chip
              <input name="numero_chip" [(ngModel)]="form.numero_chip" maxlength="50" />
            </label>
            <label class="f ancho">Alergias
              <textarea name="alergias" rows="2" [(ngModel)]="form.alergias"></textarea>
            </label>
            <label class="f ancho">Condiciones médicas
              <textarea name="condiciones_medicas" rows="2" [(ngModel)]="form.condiciones_medicas"></textarea>
            </label>
          </div>
          <div class="form-botones">
            <button class="btn btn-primary" type="submit">Guardar</button>
            <button class="btn" type="button" (click)="cancelar()">Cancelar</button>
          </div>
        </form>
      </div>
    }

    <div class="card">
      @if (loading()) {
        <p class="muted">Cargando mascotas...</p>
      } @else if (mascotas().length === 0) {
        <p class="muted">Aún no tienes mascotas. Usa «Agregar mascota» para registrar la primera.</p>
      } @else {
        <div class="scroll">
          <table>
            <thead>
              <tr><th>Nombre</th><th>Especie</th><th>Raza</th><th>Sexo</th><th>Nacimiento</th><th>Peso</th><th></th></tr>
            </thead>
            <tbody>
              @for (m of mascotas(); track m.id_mascota) {
                <tr>
                  <td><b>{{ m.nombre }}</b></td>
                  <td>{{ m.especie }}</td>
                  <td>{{ m.raza || '—' }}</td>
                  <td>{{ m.sexo || '—' }}</td>
                  <td>{{ m.fecha_nacimiento ? (m.fecha_nacimiento | date: 'dd/MM/yyyy') : '—' }}</td>
                  <td>{{ m.peso_kg ? m.peso_kg + ' kg' : '—' }}</td>
                  <td class="acciones">
                    <button class="btn btn-sm" (click)="editar(m)">Editar</button>
                    <button class="btn btn-sm btn-danger" (click)="eliminar(m)">Eliminar</button>
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
export class MascotasComponent implements OnInit {
  private http = inject(HttpClient);

  mascotas = signal<Mascota[]>([]);
  loading = signal(true);
  error = signal('');
  ok = signal('');
  mostrarForm = signal(false);
  editandoId = signal<number | null>(null);
  form = formVacio();

  ngOnInit(): void {
    this.cargar();
  }

  cargar(): void {
    this.http.get<Mascota[]>(`${API_URL}/mascotas`).subscribe({
      next: (data) => {
        this.mascotas.set(data);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudieron cargar las mascotas.'));
        this.loading.set(false);
      }
    });
  }

  nueva(): void {
    this.form = formVacio();
    this.editandoId.set(null);
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  editar(m: Mascota): void {
    this.form = {
      nombre: m.nombre,
      especie: m.especie,
      raza: m.raza ?? '',
      sexo: m.sexo ?? '',
      fecha_nacimiento: m.fecha_nacimiento ?? '',
      peso_kg: m.peso_kg ? Number(m.peso_kg) : null,
      color_mascota: m.color_mascota ?? '',
      numero_chip: m.numero_chip ?? '',
      alergias: m.alergias ?? '',
      condiciones_medicas: m.condiciones_medicas ?? ''
    };
    this.editandoId.set(m.id_mascota);
    this.ok.set('');
    this.error.set('');
    this.mostrarForm.set(true);
  }

  cancelar(): void {
    this.mostrarForm.set(false);
  }

  guardar(): void {
    const id = this.editandoId();
    const body = limpiar(this.form, id !== null);
    const req =
      id === null
        ? this.http.post<Mascota>(`${API_URL}/mascotas`, body)
        : this.http.patch<Mascota>(`${API_URL}/mascotas/${id}`, body);

    req.subscribe({
      next: () => {
        this.ok.set(id === null ? 'Mascota agregada.' : 'Mascota actualizada.');
        this.error.set('');
        this.mostrarForm.set(false);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo guardar la mascota.'))
    });
  }

  eliminar(m: Mascota): void {
    if (!confirm(`¿Eliminar a ${m.nombre}?`)) return;
    this.http.delete(`${API_URL}/mascotas/${m.id_mascota}`).subscribe({
      next: () => {
        this.ok.set(`${m.nombre} fue eliminada.`);
        this.cargar();
      },
      error: (err) => this.error.set(mensajeError(err, 'No se pudo eliminar.'))
    });
  }
}