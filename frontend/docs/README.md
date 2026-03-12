# Talk & Earn — Frontend Documentation

> Flutter web application for the Talk & Earn platform.

## Quick Start

```bash
cd D:\laragon\www\talk_earn_platform\frontend
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

> Requires the NestJS backend running on `http://localhost:3000`.

## Documentation Index

### Getting Started
- [Developer Onboarding & Setup](Developer_Onboarding.md) — Setup environment, post-clone steps, and auth flow

### Architecture
- [Architecture Overview](architecture/Architecture_Overview.md) — Tech stack, directory structure, data flow
- [Network Layer](architecture/Network_Layer.md) — Dio client, interceptors, token storage, endpoints
- [Design System](architecture/Design_System.md) — Colors, spacing, glass effects, reusable widgets
- [State Management](architecture/State_Management.md) — Riverpod patterns, provider conventions

### API
- [API Reference](api/API_Reference.md) — All 15 endpoints with request/response schemas

### Router
- [Route Implementation](router/Route_Implementation.md) — GoRouter setup, auth guard, route map

## Key Commands

| Command | Purpose |
|---|---|
| `flutter pub get` | Install dependencies |
| `dart run build_runner build` | Generate Freezed/Riverpod code |
| `dart analyze` | Run static analysis |
| `dart format .` | Format code |
| `flutter run -d chrome` | Run in Chrome |

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` | State management |
| `go_router` | Declarative routing |
| `dio` | HTTP client |
| `freezed` + `json_serializable` | Immutable models |
| `flutter_secure_storage` | JWT token persistence |
| `google_fonts` | Outfit typeface |
| `cached_network_image` | Image caching |
| `socket_io_client` | Real-time communication |
| `very_good_analysis` | Lint rules |
