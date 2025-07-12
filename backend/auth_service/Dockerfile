# BeGraceful/backend/auth_service/Dockerfile

# 1) Базовый образ
FROM golang:1.24-alpine AS builder

# 2) Рабочая директория
WORKDIR /app

# 3) Кэшируем зависимости
COPY go.mod go.sum ./
RUN go mod download

# 4) Копируем весь код и собираем бинарь
COPY . .
RUN go build -o auth_service cmd/auth/main.go

# 5) Финальный стадии: только бинарь
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/auth_service ./

# 6) Порты и команда
EXPOSE 8080
ENTRYPOINT ["./auth_service"]
