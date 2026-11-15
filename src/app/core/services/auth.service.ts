import { Injectable, computed, inject, signal } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, tap } from 'rxjs';
import { API_URL } from '../api.config';
import { LoginRequest, RegistroRequest, TokenResponse, Usuario } from '../models/usuario.model';

const TOKEN_KEY = 'token';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http = inject(HttpClient);
  private router = inject(Router);

  private readonly _token = signal<string | null>(localStorage.getItem(TOKEN_KEY));
  readonly token = this._token.asReadonly();
  readonly autenticado = computed(() => !!this._token());
  readonly usuario = signal<Usuario | null>(null);

  // El backend usa OAuth2PasswordRequestForm: form-urlencoded con "username" y "password"
  login(credenciales: LoginRequest): Observable<TokenResponse> {
    const body = new HttpParams()
      .set('username', credenciales.correo)
      .set('password', credenciales.contrasena);

    return this.http.post<TokenResponse>(`${API_URL}/auth/login`, body).pipe(
      tap((res) => {
        localStorage.setItem(TOKEN_KEY, res.access_token);
        this._token.set(res.access_token);
      })
    );
  }

  registrar(datos: RegistroRequest): Observable<Usuario> {
    return this.http.post<Usuario>(`${API_URL}/auth/register`, datos);
  }

  cargarPerfil(): Observable<Usuario> {
    return this.http
      .get<Usuario>(`${API_URL}/usuarios/me`)
      .pipe(tap((u) => this.usuario.set(u)));
  }

  cerrarSesion(): void {
    localStorage.removeItem(TOKEN_KEY);
    this._token.set(null);
    this.usuario.set(null);
    this.router.navigate(['/login']);
  }
}