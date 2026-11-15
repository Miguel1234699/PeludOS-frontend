export interface Mascota {
  id_mascota: number;
  id_usuario: number;
  activo: boolean;
  nombre: string;
  especie: string;
  raza: string | null;
  sexo: string | null;
  fecha_nacimiento: string | null; // 'YYYY-MM-DD'
  peso_kg: string | null;          // Pydantic v2 serializa Decimal como string
  color_mascota: string | null;
  numero_chip: string | null;
  foto_url: string | null;
  alergias: string | null;
  condiciones_medicas: string | null;
}