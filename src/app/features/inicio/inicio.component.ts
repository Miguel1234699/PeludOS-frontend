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