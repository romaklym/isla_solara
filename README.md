# Taxhavistan (Isla Solara)

Isla Solara is a Flutter web/mobile app. This repository contains the Flutter source code and assets to run the experience locally and deploy to the web.

## Features

- Responsive UI for mobile and desktop
- Map-based screen and interactive dialogs
- Asset pipeline configured for Flutter web

## Getting Started

Prerequisites:

- Flutter SDK installed and set up
- Dart SDK (bundled with Flutter)

Install dependencies:

```bash
flutter pub get
```

Run in debug mode:

```bash
flutter run -d chrome
```

Build for the web:

```bash
flutter build web --release
```

## Screenshots

Below are in-app screenshots located in the `screenshots/` directory.

<p align="center">
  <img src="screenshots/Screenshot_1.png" alt="Screenshot 1" width="320" />
  <img src="screenshots/Screenshot_2.png" alt="Screenshot 2" width="320" />
  <img src="screenshots/Screenshot_3.png" alt="Screenshot 3" width="320" />
  <br/>
  <img src="screenshots/Screenshot_4.png" alt="Screenshot 4" width="320" />
  <img src="screenshots/Screenshot_5.png" alt="Screenshot 5" width="320" />
  <img src="screenshots/Screenshot_6.png" alt="Screenshot 6" width="320" />
  
</p>

## Project Structure

- `lib/` — Dart source code
- `assets/` — images and fonts bundled with the app
- `web/` — web-specific static files (icons, index.html, manifest)
- `screenshots/` — app screenshots for documentation

## License

This project is provided as-is. Add your preferred license if needed.
