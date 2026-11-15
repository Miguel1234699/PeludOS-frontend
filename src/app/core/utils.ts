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