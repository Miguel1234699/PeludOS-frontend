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