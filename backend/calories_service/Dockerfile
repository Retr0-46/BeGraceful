# Stage 1: build
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o calories_service cmd/calories/main.go

# Stage 2: runtime
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/calories_service ./
EXPOSE 8080
ENTRYPOINT ["./calories_service"]
