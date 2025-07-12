# profile_service/Dockerfile

FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o profile_service cmd/profile/main.go

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/profile_service ./
EXPOSE 8080
ENTRYPOINT ["./profile_service"]
