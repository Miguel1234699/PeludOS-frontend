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