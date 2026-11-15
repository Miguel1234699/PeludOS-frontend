export type Rol = 'cliente' | 'veterinaria' | 'admin';

export interface Usuario {
  id_usuario: number;
  nombre_completo: string;
  correo_electronico: string;
  telefono: string | null;
  direccion: string | null;
  rol: Rol;
  activo: boolean;
  fecha_registro: string;
}

export interface RegistroRequest {
  nombre_completo: string;
  correo_electronico: string;
  contrasena: string;
  telefono?: string | null;
  direccion?: string | null;
}

export interface LoginRequest {
  correo: string;
  contrasena: string;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}
