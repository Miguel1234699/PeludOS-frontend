# Aplica el panel completo de PeludOS (resumen, mascotas, citas, vacunas,
# recordatorios, veterinarias y perfil).
# Uso, dentro de la carpeta pet-care-frontend:
#   powershell -ExecutionPolicy Bypass -File .\aplicar-panel.ps1
$ErrorActionPreference = 'Stop'
$base = $PSScriptRoot

function W($ruta, $contenido) {
  $full = Join-Path $base $ruta
  New-Item -ItemType Directory -Force -Path (Split-Path $full) | Out-Null
  [IO.File]::WriteAllText($full, $contenido, (New-Object Text.UTF8Encoding $false))
  Write-Host "OK  $ruta"
}

W 'src\styles.css' @'
* { box-sizing: border-box; }
body { margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f3f4f6; color: #1f2937; }

.layout { display: flex; min-height: 100vh; }
.sidebar { width: 240px; flex-shrink: 0; background: #111827; color: #fff; padding: 20px 14px; display: flex; flex-direction: column; position: sticky; top: 0; height: 100vh; }
.sidebar h2 { margin: 0 0 24px 8px; }
.sidebar nav { display: flex; flex-direction: column; gap: 4px; flex: 1; }
.sidebar a, .sidebar button.link { color: #cbd5e1; text-decoration: none; padding: 10px 12px; border-radius: 8px; cursor: pointer; background: none; border: 0; text-align: left; font: inherit; }
.sidebar a:hover, .sidebar button.link:hover { background: #1f2937; color: #fff; }
.sidebar a.active { background: #4f46e5; color: #fff; }
.sidebar .quien { font-size: 13px; color: #94a3b8; margin: 0 0 8px 8px; word-break: break-word; }
.content { flex: 1; padding: 28px 32px; min-width: 0; }

.topbar { display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap; margin-bottom: 20px; }
.topbar h1 { margin: 0; font-size: 24px; }

.card { background: #fff; border-radius: 10px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,.08); margin-bottom: 20px; }
.card h3 { margin: 0 0 12px; font-size: 17px; }

.stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 16px; margin-bottom: 20px; }
.stat { display: block; background: #fff; border-radius: 10px; padding: 18px; box-shadow: 0 1px 3px rgba(0,0,0,.08); text-decoration: none; color: inherit; }
.stat:hover { box-shadow: 0 3px 10px rgba(0,0,0,.12); }
.stat b { display: block; font-size: 30px; color: #4f46e5; }
.stat span { color: #6b7280; font-size: 14px; }

.cols { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
.lista { list-style: none; margin: 0; padding: 0; }
.lista li { padding: 10px 0; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
.lista li:last-child { border-bottom: 0; }

.form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 12px; }
.form-grid .ancho { grid-column: 1 / -1; }
label.f { display: flex; flex-direction: column; font-size: 13px; color: #4b5563; gap: 4px; }
input, select, textarea { padding: 9px 10px; border: 1px solid #d1d5db; border-radius: 6px; font: inherit; background: #fff; }
input:focus, select:focus, textarea:focus { outline: 2px solid #c7d2fe; border-color: #4f46e5; }

.btn { padding: 9px 16px; border-radius: 6px; border: 1px solid #d1d5db; background: #fff; cursor: pointer; font: inherit; text-decoration: none; color: #1f2937; display: inline-block; }
.btn:hover { background: #f9fafb; }
.btn-primary { background: #4f46e5; border-color: #4f46e5; color: #fff; }
.btn-primary:hover { background: #4338ca; }
.btn-danger { color: #b91c1c; border-color: #fecaca; }
.btn-danger:hover { background: #fef2f2; }
.btn-sm { padding: 5px 10px; font-size: 13px; }
.acciones { display: flex; gap: 8px; flex-wrap: wrap; }
.form-botones { display: flex; gap: 8px; margin-top: 14px; }

.scroll { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th, td { text-align: left; padding: 10px; border-bottom: 1px solid #e5e7eb; font-size: 14px; vertical-align: top; }
th { color: #6b7280; font-weight: 600; font-size: 13px; }

.badge { display: inline-block; padding: 2px 10px; border-radius: 999px; font-size: 12px; background: #e0e7ff; color: #3730a3; }
.badge.cancelada { background: #fee2e2; color: #991b1b; }
.badge.completada, .badge.confirmada { background: #d1fae5; color: #065f46; }

.msg-error { color: #b91c1c; background: #fef2f2; padding: 10px 12px; border-radius: 6px; margin-bottom: 14px; }
.msg-ok { color: #065f46; background: #ecfdf5; padding: 10px 12px; border-radius: 6px; margin-bottom: 14px; }
.muted { color: #6b7280; }

@media (max-width: 800px) {
  .layout { flex-direction: column; }
  .sidebar { width: 100%; height: auto; position: static; }
  .sidebar nav { flex-direction: row; flex-wrap: wrap; }
  .content { padding: 18px 14px; }
}
'@

W 'src\app\app.routes.ts' @'
import { Routes } from '@angular/router';
import { authGuard, guestGuard } from './core/guards/auth.guard';
import { Login } from './features/auth/login/login';
import { Registro } from './features/auth/registro/registro';
import { PanelComponent } from './features/panel/panel.component';
import { InicioComponent } from './features/inicio/inicio.component';
import { MascotasComponent } from './features/mascotas/mascotas.component';
import { CitasComponent } from './features/citas/citas.component';
import { VacunasComponent } from './features/vacunas/vacunas.component';
import { RecordatoriosComponent } from './features/recordatorios/recordatorios.component';
import { VeterinariasComponent } from './features/veterinarias/veterinarias.component';
import { PerfilComponent } from './features/perfil/perfil.component';

export const routes: Routes = [
  { path: 'login', component: Login, canActivate: [guestGuard] },
  { path: 'registro', component: Registro, canActivate: [guestGuard] },
  {
    path: '',
    component: PanelComponent,
    canActivate: [authGuard],
    children: [
      { path: '', redirectTo: 'inicio', pathMatch: 'full' },
      { path: 'inicio', component: InicioComponent },
      { path: 'mascotas', component: MascotasComponent },
      { path: 'citas', component: CitasComponent },
      { path: 'vacunas', component: VacunasComponent },
      { path: 'recordatorios', component: RecordatoriosComponent },
      { path: 'veterinarias', component: VeterinariasComponent },
      { path: 'perfil', component: PerfilComponent }
    ]
  },
  { path: '**', redirectTo: 'inicio' }
];
'@

W 'src\app\core\utils.ts' @'
// Quita los campos vacíos para no mandar "" al backend (p. ej. numero_chip es único).
// En edición (PATCH) los vacíos se mandan como null para poder borrar un dato.
export function limpiar(obj: object, paraEditar = false): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(obj)) {
    if (v === '' || v === undefined) {
      if (paraEditar) out[k] = null;
      continue;
    }
    out[k] = v;
  }
  return out;
}
'@

W 'src\app\core\models\panel.model.ts' @'
export interface Cita {
  id_cita: number;
  id_usuario: number;
  id_mascota: number;
  id_veterinaria: number;
  id_profesional: number | null;
  fecha_hora: string;
  motivo: string;
  estado: string;
  notas: string | null;
  fecha_creacion: string;
  activo: boolean;
}

export interface Vacuna {
  id_vacuna: number;
  id_mascota: number;
  nombre_vacuna: string;
  fecha_aplicacion: string;
  fecha_proxima: string | null;
  lote: string | null;
  observaciones: string | null;
  activo: boolean;
}

export interface Recordatorio {
  id_recordatorio: number;
  id_usuario: number;
  id_mascota: number | null;
  titulo: string;
  descripcion: string | null;
  tipo: string | null;
  fecha_recordatorio: string;
  completado: boolean;
  activo: boolean;
}

export interface Veterinaria {
  id_veterinaria: number;
  nombre_comercial: string;
  direccion: string;
  telefono: string;
  correo_electronico: string | null;
  horario_atencion: string | null;
  latitud: string | null;
  longitud: string | null;
  calificacion_promedio: string;
  activo: boolean;
}
'@

W 'src\app\features\panel\panel.component.ts' @'
import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-panel',
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <div class="layout">
      <aside class="sidebar">
        <h2>🐾 PeludOS</h2>
        <nav>
          <a routerLink="/inicio" routerLinkActive="active">🏠 Resumen</a>
          <a routerLink="/mascotas" routerLinkActive="active">🐶 Mis mascotas</a>
          <a routerLink="/citas" routerLinkActive="active">📅 Citas</a>
          <a routerLink="/vacunas" routerLinkActive="active">💉 Vacunas</a>
          <a routerLink="/recordatorios" routerLinkActive="active">⏰ Recordatorios</a>
          <a routerLink="/veterinarias" routerLinkActive="active">🏥 Veterinarias</a>
          <a routerLink="/perfil" routerLinkActive="active">👤 Mi perfil</a>
        </nav>
        <p class="quien">{{ auth.usuario()?.nombre_completo }}</p>
        <button class="link" (click)="auth.cerrarSesion()">🚪 Cerrar sesión</button>
      </aside>
      <main class="content">
        <router-outlet />
      </main>
    </div>
  `
})
export class PanelComponent {
  auth = inject(AuthService);
}
'@

W 'src\app\features\inicio\inicio.component.ts' @'
import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { RouterLink } from '@angular/router';
import { forkJoin } from 'rxjs';
import { API_URL } from '../../core/api.config';
import { mensajeError } from '../../core/http-error';
import { Mascota } from '../../core/models/mascota.model';
import { Cita, Recordatorio, Vacuna } from '../../core/models/panel.model';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-inicio',
  imports: [RouterLink, DatePipe],
  templateUrl: './inicio.component.html'
})
export class InicioComponent implements OnInit {
  private http = inject(HttpClient);
  auth = inject(AuthService);

  loading = signal(true);
  error = signal('');
  mascotas = signal<Mascota[]>([]);
  citas = signal<Cita[]>([]);
  vacunas = signal<Vacuna[]>([]);
  recordatorios = signal<Recordatorio[]>([]);

  proximasCitas = computed(() => {
    const ahora = Date.now();
    return this.citas()
      .filter((c) => c.estado !== 'cancelada' && new Date(c.fecha_hora).getTime() >= ahora)
      .sort((a, b) => new Date(a.fecha_hora).getTime() - new Date(b.fecha_hora).getTime());
  });

  pendientes = computed(() => this.recordatorios().filter((r) => !r.completado));

  proximasVacunas = computed(() => {
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    return this.vacunas()
      .filter((v) => v.fecha_proxima && new Date(v.fecha_proxima) >= hoy)
      .sort((a, b) => new Date(a.fecha_proxima!).getTime() - new Date(b.fecha_proxima!).getTime());
  });

  ngOnInit(): void {
    forkJoin({
      mascotas: this.http.get<Mascota[]>(`${API_URL}/mascotas`),
      citas: this.http.get<Cita[]>(`${API_URL}/citas`),
      vacunas: this.http.get<Vacuna[]>(`${API_URL}/vacunas`),
      recordatorios: this.http.get<Recordatorio[]>(`${API_URL}/recordatorios`)
    }).subscribe({
      next: (r) => {
        this.mascotas.set(r.mascotas);
        this.citas.set(r.citas);
        this.vacunas.set(r.vacunas);
        this.recordatorios.set(r.recordatorios);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(mensajeError(err, 'No se pudo cargar el resumen.'));
        this.loading.set(false);
      }
    });
  }

  nombreMascota(id: number | null): string {
    return this.mascotas().find((m) => m.id_mascota === id)?.nombre ?? '—';
  }
}
'@

W 'src\app\features\inicio\inicio.component.html' @'
<div class="topbar">
  <h1>Hola, {{ auth.usuario()?.nombre_completo }} 👋</h1>
  <div class="acciones">
    <a class="btn btn-primary" routerLink="/mascotas">+ Agregar mascota</a>
    <a class="btn" routerLink="/citas">Agendar cita</a>
  </div>
</div>

@if (loading()) {
  <p class="muted">Cargando resumen...</p>
}

@if (error()) {
  <div class="msg-error">{{ error() }}</div>
}

@if (!loading() && !error()) {
  <div class="stats">
    <a class="stat" routerLink="/mascotas"><b>{{ mascotas().length }}</b><span>Mascotas</span></a>
    <a class="stat" routerLink="/citas"><b>{{ proximasCitas().length }}</b><span>Citas próximas</span></a>
    <a class="stat" routerLink="/vacunas"><b>{{ vacunas().length }}</b><span>Vacunas registradas</span></a>
    <a class="stat" routerLink="/recordatorios"><b>{{ pendientes().length }}</b><span>Recordatorios pendientes</span></a>
  </div>

  <div class="cols">
    <div class="card">
      <h3>📅 Próximas citas</h3>
      <ul class="lista">
        @for (c of proximasCitas().slice(0, 5); track c.id_cita) {
          <li>
            <b>{{ c.fecha_hora | date: 'dd/MM/yyyy, h:mm a' }}</b> · {{ nombreMascota(c.id_mascota) }}
            <div class="muted">{{ c.motivo }}</div>
          </li>
        } @empty {
          <li class="muted">No tienes citas próximas.</li>
        }
      </ul>
    </div>

    <div class="card">
      <h3>💉 Próximas vacunas</h3>
      <ul class="lista">
        @for (v of proximasVacunas().slice(0, 5); track v.id_vacuna) {
          <li>
            <b>{{ v.fecha_proxima | date: 'dd/MM/yyyy' }}</b> · {{ nombreMascota(v.id_mascota) }}
            <div class="muted">{{ v.nombre_vacuna }}</div>
          </li>
        } @empty {
          <li class="muted">No hay vacunas programadas.</li>
        }
      </ul>
    </div>

    <div class="card">
      <h3>⏰ Recordatorios pendientes</h3>
      <ul class="lista">
        @for (r of pendientes().slice(0, 5); track r.id_recordatorio) {
          <li>
            <b>{{ r.titulo }}</b>
            <div class="muted">{{ r.fecha_recordatorio | date: 'dd/MM/yyyy, h:mm a' }}</div>
          </li>
        } @empty {
          <li class="muted">Estás al día. 🎉</li>
        }
      </ul>
    </div>
  </div>
}
'@

W 'src\app\features\mascotas\mascotas.component.ts' @'
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
'@

W 'src\app\features\citas\citas.component.ts' @'
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
'@

W 'src\app\features\vacunas\vacunas.component.ts' @'
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
'@

W 'src\app\features\recordatorios\recordatorios.component.ts' @'
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
'@

W 'src\app\features\veterinarias\veterinarias.component.ts' @'
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
'@

W 'src\app\features\perfil\perfil.component.ts' @'
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
'@

Set-Location $base
Write-Host ""
Write-Host "Compilando para verificar..."
npm run build
