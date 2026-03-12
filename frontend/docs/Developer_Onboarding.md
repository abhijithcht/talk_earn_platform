# Developer Onboarding Guide

> Welcome to the Talk & Earn Frontend repository. This guide covers how to set up the project, what to do immediately after cloning, and how the core authentication flow works.

---

## 🏗️ 1. Setup Environment

### Prerequisites

| Tool | Version Required |
|---|---|
| **Flutter SDK** | `^3.11.0` (or compatible beta/master if required) |
| **Dart SDK** | Automatically installed with Flutter |
| **Backend API** | NestJS backend running on port `3000` |

### Backend API Configuration

The app relies on a local NestJS backend. Ensure the backend is running before testing the frontend.

Depending on your platform, the app routes traffic automatically:
- **Android Emulator**: Uses `http://10.0.2.2:3000`
- **Desktop (Windows/macOS/Linux)**: Uses `http://localhost:3000`
- **Web**: Uses an empty string proxy (`''`) via `web_dev_config.yaml` to prevent CORS issues.

> [!TIP]
> This behavior is pre-configured in `lib/core/config/app_config.dart`.

---

## ⚡ 2. Things to Note After Git Clone

After running `git clone`, follow these exact steps to ensure the project runs properly.

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Run Code Generation (CRITICAL)
This project uses **Riverpod** and **Freezed**, which require code generation. You will see red errors in your editor until this step is completed.

Run the build runner:
```bash
dart run build_runner build --delete-conflicting-outputs
```

> [!IMPORTANT]
> **Always run this command** whenever you create a new Freezed model (`*.freezed.dart`), a new Riverpod provider (`@riverpod`), or a new JSON-serializable class. If you are actively developing, you can use the watch command instead: `dart run build_runner watch -d`

### Step 3: Start the App
Select your target device (e.g., Chrome, Edge, Android emulator, Windows desktop) and run:
```bash
flutter run
```

---

## 🔐 3. Authentication Flow Explained

Authentication is handled across several domains to ensure secure access to the app.

### 1. Data Flow (Register & Login)
- **Registration (`/auth/register`)**: Creates a new user. The user is marked as `isVerified: false`. The API sends an OTP code to their email.
- **OTP Verification (`/auth/verify-email`)**: User submits the OTP to verify their email.
- **Login (`/auth/token`)**: Exchanging credentials for a JWT token.

### 2. Token Storage
Upon successful login, the `AuthRepository` saves the JWT securely using the `TokenStorage` utility (backed by the `flutter_secure_storage` package).

```dart
// Saving the token securely
await TokenStorage.saveToken(token);
```

### 3. The `ApiClient` (Dio Interceptors)
You do **not** need to manually attach the Bearer token to your HTTP requests.
The global `ApiClient` (Dio singleton) has an interceptor that automatically reads the token from `TokenStorage` and injects it into the `Authorization` header of every outbound request.

Additionally, if the backend returns a `401 Unauthorized` response (e.g., expired token), the interceptor will automatically clear the local token, forcing a logout.

### 4. Router Guard (GoRouter)
The routing system (`core/router/app_router.dart`) includes a global `redirect` guard.
- Before transitioning to **any** route, the router checks for a valid token in `TokenStorage`.
- If the token **is missing**, the user is redirected to `/login` (unless they are explicitly going to `/login`, `/register`, or `/verify-email`).
- If the token **is present**, the user is blocked from viewing auth pages and sent directly to `/` (Home).

### 5. Riverpod State (`authProvider`)
The `authProvider` handles the current session state.
When the app launches, the provider reads the token. If valid, it fetches the current user's profile from `/profile/me`. If that request fails, the token is deemed invalid/expired, cleared, and the user is logged out.
