import { HttpErrorResponse } from '@angular/common/http';

export function mensajeError(err: unknown, porDefecto = 'Ocurrió un error inesperado'): string {
  if (!(err instanceof HttpErrorResponse)) return porDefecto;
  if (err.status === 0) return 'No hay conexión con el servidor';
  const detail = err.error?.detail;
  if (typeof detail === 'string') return detail;
  if (Array.isArray(detail) && detail.length) {
    return detail.map((d: { msg: string }) => d.msg).join('. ');
  }
  return porDefecto;
}
