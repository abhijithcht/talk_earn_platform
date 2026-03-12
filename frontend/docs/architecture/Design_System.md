# Design System

> **Last updated:** 2026-03-12

## Overview

The app uses a **dark glassmorphism** design system, centralized in three files to ensure consistency across all screens.

## Key Components

| File | Class | Purpose |
|---|---|---|
| `core/theme/design_constants.dart` | `DesignConstants` | Colors, spacing, gradients, glass effects |
| `core/theme/app_theme.dart` | `AppTheme` | Material ThemeData configuration |
| `core/theme/app_strings.dart` | `AppStrings` | All user-facing text (105 strings) |

## Color Palette

| Token | Hex | Usage |
|---|---|---|
| `bgDeep` | `#050B14` | Scaffold background |
| `glassBg` | `#7310192B` (45%) | Glass card fill |
| `glassBorder` | `#14FFFFFF` (8%) | Glass card border |
| `primary` | `#4F46E5` | Buttons, primary actions |
| `secondary` | `#0EA5E9` | Highlights, focused borders |
| `accent` | `#10B981` | Success states |
| `danger` | `#EF4444` | Errors, delete actions |
| `textMain` | `#F8FAFC` | Primary text |
| `textMuted` | `#94A3B8` | Hints, labels |
| `surfaceSolid` | `#0F172A` | Opaque surfaces |
| `surfaceOverlay` | `#F210192B` (95%) | Popup backgrounds |
| `dialogBackground` | `#10192B` | Dialog backgrounds |

## Spacing Scale

| Token | Value | Usage |
|---|---|---|
| `pXS` | 4px | Micro gaps |
| `pS` | 8px | Small gaps |
| `pM` | 16px | Standard padding |
| `pL` | 24px | Section spacing |
| `pXL` | 32px | Large containers |
| `pXXL` | 48px | Hero sections |

## Breakpoints

| Token | Width | Layout |
|---|---|---|
| `mobileLimit` | 600px | Single column |
| `tabletLimit` | 900px | Two-column |
| `desktopLimit` | 1200px | Full desktop |

## Gradients

```dart
// Primary gradient (buttons, highlights)
DesignConstants.primaryGradient  // primary → secondary

// Text gradient (hero headings)
DesignConstants.textGradient     // #38BDF8 → #818CF8 → #C084FC

// Wallet gradient
walletGradientStart → walletGradientMiddle → walletGradientEnd
```

## Glass Effects

| Token | Value |
|---|---|
| `glassBlur` | 20.0 sigma |
| `glassBorderWidth` | 1.2px |
| `glassRadius` | 24px radius |
| `glassShadow` | black 37%, blur 32, offset (0,8) |

## Reusable Widgets

### GlassCard

Frosted-glass container used across all screens.

```dart
GlassCard(
  padding: const EdgeInsets.all(DesignConstants.pL),
  child: Text('Content'),
)
```

**Props:** `width`, `height`, `padding`, `borderRadius`, `blur`

### AnimatedBackground

Full-screen background with floating emoji particles (💬💰🚀⭐💎📱🔥). Uses a `CustomPainter` with a 15-second loop.

```dart
AnimatedBackground(child: yourContent)
```

### Responsive

Layout switcher that picks `mobile`, `tablet`, or `desktop` widget based on screen width.

```dart
Responsive(
  mobile: MobileLayout(),
  desktop: DesktopLayout(),
)

// Static helpers:
if (Responsive.isMobile(context)) { ... }
```

### DashLayout

Dashboard layout with optional sidebar. Renders side-by-side on desktop (3:7 ratio), stacked on mobile.

```dart
DashLayout(
  sidebar: WalletSummary(),
  main: MainContent(),
)
```

## AppTheme

Applied in `main.dart` via `MaterialApp.router(theme: AppTheme.lightTheme)`.

**Configured components:**
- `textTheme` — Google Fonts Outfit, `textMain` color
- `colorScheme` — dark scheme with project colors
- `inputDecorationTheme` — filled, glass-bordered inputs
- `elevatedButtonTheme` — full-width, primary-colored, rounded
- `cardTheme` — glass background, glass border
- `appBarTheme` — transparent, no elevation
- `popupMenuTheme` / `dropdownMenuTheme` — glass-styled overlays
