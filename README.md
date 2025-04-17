# Wempro Form App

A Flutter application that demonstrates dynamic form rendering based on JSON data. The app follows modern Flutter development practices and implements a clean architecture pattern.

## Features

- Dynamic form field rendering based on JSON data
- Support for multiple input types:
  - Text fields
  - Radio buttons
  - Dropdown menus
  - Checkboxes
- Form validation
- State management using Riverpod
- Clean and modern UI design
- Responsive layout

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/wempro.git
```

2. Navigate to the project directory:
```bash
cd wempro
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
  ├── models/
  │   └── form_field_model.dart
  ├── providers/
  │   └── form_provider.dart
  ├── screens/
  │   ├── form_screen.dart
  │   └── summary_screen.dart
  ├── services/
  │   └── api_service.dart
  └── main.dart
```

## Architecture

The project follows a clean architecture pattern with the following layers:

- **Models**: Data classes that represent the domain entities
- **Providers**: State management using Riverpod
- **Screens**: UI components and widgets
- **Services**: API and external service integrations

## Dependencies

- `flutter_riverpod`: State management
- `dio`: HTTP client for API requests

## API Integration

The app integrates with a REST API endpoint to fetch form field configurations:
```
http://team.dev.helpabode.com:54292/api/wempro/flutter-dev/coding-test-2025/
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
# Home_Cleaning_Service
