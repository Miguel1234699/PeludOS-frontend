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

          <a routerLink="/mascotas" routerLinkActive="active">🐶 Mis mascotas</a>
          <a routerLink="/citas" routerLinkActive="active">📅 Citas</a>
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
