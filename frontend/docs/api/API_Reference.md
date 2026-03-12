# API Reference

> **Last updated:** 2026-03-12  
> **Backend:** NestJS at `http://localhost:3000`

## Authentication

All endpoints except `login`, `register`, and `verify-email` require a Bearer JWT token in the `Authorization` header.

---

### POST `/auth/register`

Register a new user account.

| Field | Type | Required |
|---|---|---|
| `email` | string | ✅ |
| `password` | string | ✅ |
| `fullName` | string | ✅ |
| `gender` | string | ✅ |
| `genderPreference` | string | ✅ |

**Flutter:** `AuthRepository.register()`

---

### POST `/auth/token`

Login and receive a JWT access token.

| Field | Type | Required |
|---|---|---|
| `email` | string | ✅ |
| `password` | string | ✅ |

**Response:**
```json
{ "access_token": "eyJhbGci..." }
```

**Flutter:** `AuthRepository.login()` — token is auto-saved to `TokenStorage`

---

### POST `/auth/verify-email`

Verify email with OTP code.

| Field | Type | Required |
|---|---|---|
| `email` | string | ✅ |
| `otpCode` | string | ✅ |

**Flutter:** `AuthRepository.verifyEmail()`

---

## Profile

### GET `/profile/me` 🔒

Get the current user's profile.

**Response:** `User` model (see Models section below)

**Flutter:** `ProfileRepository.getProfile()`

---

### PATCH `/profile/update` 🔒

Update profile fields.

| Field | Type | Required |
|---|---|---|
| `fullName` | string | ❌ |
| `gender` | string | ❌ |
| `interests` | string | ❌ |

**Flutter:** `ProfileRepository.updateProfile()`

---

### POST `/profile/picture` 🔒

Upload a profile picture (multipart form data).

| Field | Type | Required |
|---|---|---|
| `file` | File | ✅ |

**Flutter:** `ProfileRepository.uploadProfilePicture()`

---

### POST `/profile/change-password` 🔒

Change the user's password.

| Field | Type | Required |
|---|---|---|
| `currentPassword` | string | ✅ |
| `newPassword` | string | ✅ |

**Flutter:** `ProfileRepository.changePassword()`

---

### DELETE `/profile/delete-account` 🔒

Permanently delete the user's account.

| Field | Type | Required |
|---|---|---|
| `password` | string | ✅ |

**Flutter:** `ProfileRepository.deleteAccount()`

---

### GET `/profile/avatars` 🔒

Get available avatar options.

**Flutter:** `ProfileRepository.getAvatars()`

---

## Wallet

### GET `/wallet/balance` 🔒

Get current coin balance.

**Response:**
```json
{ "balance": 1250 }
```

**Flutter:** `WalletRepository.getBalance()`

---

### POST `/wallet/withdraw` 🔒

Request a coin withdrawal.

| Field | Type | Required |
|---|---|---|
| `amount` | int | ✅ |
| `method` | string | ✅ |
| `details` | string | ✅ |

**Flutter:** `WalletRepository.withdraw()`

---

### POST `/wallet/earn` 🔒

Record coins earned from a session.

| Field | Type | Required |
|---|---|---|
| `amount` | int | ✅ |

**Flutter:** `ProfileRepository.earnCoins()` (via profile repo)

---

## Match

### POST `/match/find` 🔒

Start searching for a match partner.

| Field | Type | Required |
|---|---|---|
| `mode` | string | ✅ |

**Flutter:** `MatchRepository.findMatch()`

---

### POST `/match/cancel` 🔒

Cancel an active match search.

**Flutter:** `MatchRepository.cancelMatch()`

---

## Rating

### POST `/rating/submit` 🔒

Submit a rating for a completed session.

| Field | Type | Required |
|---|---|---|
| `matchId` | int | ✅ |
| `rating` | int | ✅ |
| `comment` | string | ❌ |

**Flutter:** `RatingRepository.submitRating()`

---

## Data Models

### User (Freezed)

```dart
@freezed
class User {
  int id;            // Required
  String email;      // Required
  String? fullName;
  String username;   // Default: ''
  String? gender;
  String genderPreference; // Default: 'any'
  bool isVerified;   // Default: false
  String verificationStatus; // Default: 'unverified'
  bool isActive;     // Default: true
  int warnings;      // Default: 0
}
```

## Postman Collection

A complete Postman collection with all endpoints and test scripts is available:
- **Collection:** Talk & Earn Platform API (`9f0431a2-1258-4bf6-9f2a-492d43b1cb98`)
- **Environment:** Talk Earn - Local (`30de59aa-adb6-47ce-ba2b-1322132b08ff`)
