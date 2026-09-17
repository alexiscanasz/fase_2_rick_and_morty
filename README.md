# Portal Remoto — Fase 2

App Flutter de la Fase 2 de la ruta de crecimiento, consume la [API de Rick and Morty](https://rickandmortyapi.com/) para listar, buscar y ver el detalle de personajes.

## Funcionalidad

- Listado de personajes obtenido desde `GET /api/character`.
- Busqueda por nombre (`?name=`).
- Detalle de personaje (`GET /api/character/{id}`) con su propio estado de carga/error.
- Estados de carga, error (con reintento) y vacío (sin resultados de búsqueda).

## Arquitectura

Organización por capas dentro de `lib/features/characters/`:

- `data/` — modelos, datasource remoto (Dio) y repositorio.
- `domain/` — entidad `Character`, contrato del repositorio y use cases.
- `presentation/` — providers de **Riverpod 3** (estado de la lista, búsqueda y detalle) y las pantallas.

El manejo de errores usa un tipo `Result<T>` (`Success`/`Failure`) en `core/error/`, evitando exponer excepciones directamente a la UI.

## Cómo ejecutar

```bash
flutter pub get
flutter run
```
