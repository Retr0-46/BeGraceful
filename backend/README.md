# BeGraceful Backend

## Запуск локально (Go)

1. Установите Go (https://golang.org/dl/)
2. Перейдите в папку нужного сервиса, например:
   ```sh
   cd backend/auth_service
   go run ./cmd/auth/main.go
   ```
   Аналогично для profile_service и calories_service:
   ```sh
   cd backend/profile_service
   go run ./cmd/profile/main.go
   
   cd backend/calories_service
   go run ./cmd/calories/main.go
   ```

3. Сервисы будут доступны по портам:
   - auth_service:     http://localhost:8001
   - profile_service:  http://localhost:8002
   - calories_service: http://localhost:8003

---

## Запуск через Docker Compose

1. Перейдите в папку backend:
   ```sh
   cd backend
   docker-compose up --build
   ```
2. Все сервисы поднимутся в отдельных контейнерах и будут доступны по тем же портам.

---

## Миграции базы данных

- SQL миграции лежат в папке `backend/migrations/`.
- Для применения миграций используйте ваш инструмент (например, psql, migrate и т.д.)

---

## Примечания
- Все сервисы используют порты 8001, 8002, 8003 (см. docker-compose.yml).
- Swagger спецификации для каждого сервиса лежат в соответствующих папках.
- Для работы требуется PostgreSQL (или другой, если настроено иначе).
- Переменные окружения можно задать через docker-compose или .env файлы. 