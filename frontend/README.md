# BeGraceful Frontend

## Запуск для Web

### 1. Локально (dev-сервер)

```sh
flutter run -d chrome
```

или

```sh
flutter run -d web-server
```

Приложение будет доступно по адресу http://localhost:8000 (или другому, указанному в выводе команды).

### 2. Сборка и запуск через Docker

```sh
# Перейдите в папку frontend
cd frontend
# Соберите Docker-образ
docker build -t begraceful-frontend .
# Запустите контейнер
docker run -p 8080:80 begraceful-frontend
```

Приложение будет доступно по адресу http://localhost:8080

---

## Запуск для Android эмулятора

1. Запустите Android эмулятор через Android Studio или командой:
   ```sh
   emulator -avd <имя_эмулятора>
   ```
2. Запустите приложение на эмуляторе:
   ```sh
   flutter run -d emulator-5554
   ```
   (или выберите устройство в Android Studio)

---

## Примечания
- Для работы с backend убедитесь, что сервисы backend запущены и доступны по нужным адресам (см. lib/src/utils/config.dart).
- Для web-сборки используется Flutter web (Chrome/web-server).
- Для Android требуется установленный эмулятор и Android SDK.
- Для Docker требуется установленный Docker.
