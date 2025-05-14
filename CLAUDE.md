# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The Primax Lucky Draw App is a Flutter mobile application that allows users to:
- Participate in lucky draw contests
- Scan barcodes to earn points
- Redeem rewards
- Make donations
- View their profile and transaction history

## Architecture

The application follows a Provider-based architecture with dependency injection using GetIt:

1. **Services Layer**: Handles API calls and business logic
2. **Providers Layer**: Manages state using the Provider pattern
3. **UI Layer**: Flutter widgets organized by feature/screen

### Key Architectural Components

- **Service Locator**: Uses GetIt for dependency injection (`lib/core/di/service_locator.dart`)
- **Routing**: Centralized routing system in `lib/routes/routes.dart`
- **Network Layer**: API client with interceptors for authentication and error handling
- **Authentication**: Firebase Authentication with custom token management
- **State Management**: Provider pattern with ChangeNotifierProvider

## Development Commands

### Setup Environment

```bash
# Install dependencies
flutter pub get

# Update dependencies (when needed)
flutter pub upgrade
```

### Running the App

```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d <device_id>

# Run release version
flutter run --release
```

### Building the App

```bash
# Build Android APK
flutter build apk

# Build Android App Bundle for Play Store
flutter build appbundle

# Build iOS
flutter build ios

# Build with specific flavor (if configured)
flutter build apk --flavor production
```

### Firebase Configuration

The app uses Firebase for authentication and cloud services. When setting up a new development environment:

1. Configure Firebase project on the Firebase console
2. Download and place the configuration files:
   - `android/app/google-services.json` for Android
   - `ios/Runner/GoogleService-Info.plist` for iOS

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
```

## Key Dependencies

- **Provider**: State management (`provider: ^6.1.4`)
- **Firebase**: Authentication and cloud services 
  - `firebase_core: ^3.11.0`
  - `firebase_auth: ^5.4.2`
  - `cloud_firestore: ^5.6.3`
- **GetIt**: Dependency injection (`get_it: ^8.0.3`)
- **Mobile Scanner**: For barcode scanning (`mobile_scanner: ^6.0.10`)
- **UI Components**:
  - `flutter_svg: ^2.0.10+1`
  - `google_fonts: ^6.2.1`
  - `lottie: ^3.3.1`
  - `animated_bottom_navigation_bar: ^1.4.0`

## Project Structure

- **lib/core/**: Core utilities, services, and providers
  - **di/**: Dependency injection setup
  - **network/**: API client and network handling
  - **providers/**: State management providers
  - **utils/**: Utility classes and constants
- **lib/models/**: Data models
- **lib/routes/**: Route definitions
- **lib/screen/**: UI screens organized by feature
- **lib/services/**: Service classes for business logic
- **lib/widgets/**: Reusable UI components

## Best Practices for this Codebase

1. **State Management**:
   - Use the Provider pattern for state management
   - Register providers in the service locator when appropriate

2. **API Calls**:
   - Create service classes for API calls in the services/ directory
   - Handle exceptions with the custom exception classes

3. **UI Components**:
   - Follow existing patterns when creating new screens
   - Reuse existing widgets from the widgets/ directory

4. **Authentication**:
   - Handle authentication through the AuthProvider
   - Protected routes should check authentication status