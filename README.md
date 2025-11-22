# marketplace

Base de marketplace en Flutter con navegación declarativa (`go_router`), gestión de estado (`flutter_riverpod` o `bloc`), cliente HTTP (`dio`), modelos inmutables (`freezed` + `json_serializable`) e inyección de dependencias (`get_it`).

## Estructura de carpetas

```
lib/
  main.dart
  app/
    router/             # go_router, rutas y guards
    theme/              # temas, colores, tipografías
    l10n/               # delegados y utilidades de localización
  core/
    di/                 # get_it: service locator, inicialización
    network/            # dio client, interceptores
      interceptors/
    errors/             # failures/exceptions comunes
    utils/              # helpers y utilidades puras
    env/                # configuración por ambiente
    platform/           # integraciones con plataforma/permisos
  features/             # módulos por dominio
    auth/
      data/             # acceso a datos
        models/         # modelos freezed + json_serializable
        dtos/           # requests/responses específicos
        datasources/    # remoto/local
        repositories/   # implementaciones concretas
      domain/           # capa de dominio
        entities/
        repositories/   # abstracciones
        usecases/
      presentation/     # UI + estado
        providers/      # o bloc/ cubits
        controllers/    # notifiers/controllers
        views/          # screens/pages
        widgets/        # UI reutilizable del feature
    catalog/            # mismo layout data/domain/presentation
    product_detail/
    cart/
    checkout/
    profile/
  shared/               # reutilizables entre features
    widgets/
    providers/          # sesión, tema, etc.
    styles/             # tokens de diseño
    mappers/
    extensions/
    constants/
test/
  fixtures/             # JSONs/archivos de prueba
  mocks/                # dobles de prueba
  helpers/              # utils para tests (pumpWidget, overrides)
```

## Notas rápidas
- Configura `get_it` en `lib/core/di` y ejecútalo antes de `runApp`.
- Registra e inicializa `dio` con interceptores en `lib/core/network`.
- Declara rutas y guards de autenticación en `lib/app/router`.
- Ubica providers/BLoC de cada módulo en `presentation/providers` (o `bloc/` si prefieres BLoC).
- Modelos y entidades inmutables en `data/models` y `domain/entities` usando `freezed` + `json_serializable`.
