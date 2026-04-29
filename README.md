# BeGraceful

A cross-platform mobile app for tracking fitness goals, daily activity, and body progress. Built with Flutter frontend and Go backend.

## Features

- **Goal tracking** — set and monitor daily fitness goals
- **Weight progress** — log and visualize weight changes over time
- **Calendar view** — track activity by day
- **User profile** — personal stats and settings
- **Light / Dark theme** — toggle between themes

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart), Provider, HTTP |
| Backend | Go |
| Auth | Registration / Login |

## Getting Started

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

### Backend

```bash
cd backend
go run ./cmd
```

## Project Structure

```
BeGraceful/
├── frontend/        # Flutter app
│   ├── lib/
│   │   └── src/
│   │       ├── ui/          # screens and widgets
│   │       ├── models/      # data models
│   │       ├── providers/   # state management
│   │       └── services/    # API layer
│   └── assets/      # icons and images
└── backend/         # Go server
```

## Team

Built as a university project. Frontend and UI design by [Irina](https://github.com/1r444444).
