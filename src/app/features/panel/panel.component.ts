import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-panel',
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <div class="layout">
      <aside class="sidebar">
        <h2>&#128062; PeludOS</h2>
        <nav>
          <a routerLink="/inicio" routerLinkActive="active">&#127968; Inicio</a>
          <a routerLink="/mascotas" routerLinkActive="active">&#128054; Mis mascotas</a>
          <a routerLink="/citas" routerLinkActive="active">&#128197; Citas</a>
          <a routerLink="/vacunas" routerLinkActive="active">&#128137; Vacunas</a>
          <a routerLink="/recordatorios" routerLinkActive="active">&#9200; Recordatorios</a>
          <a routerLink="/veterinarias" routerLinkActive="active">&#127973; Veterinarias</a>
          <a routerLink="/perfil" routerLinkActive="active">&#128100; Mi perfil</a>
        </nav>
        <p class="quien">{{ auth.usuario()?.nombre_completo }}</p>
        <button class="link" (click)="auth.cerrarSesion()">&#128682; Cerrar sesi&oacute;n</button>
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
