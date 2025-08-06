FROM golang:1.24-alpine AS builder
WORKDIR /app

# 모듈 파일 먼저 복사해서 의존성 계층 캐시 활용
COPY go.mod go.sum ./
# 소스 코드 복사 & 빌드
COPY main.go ./
RUN go mod tidy
RUN go build -o stress_app

FROM alpine:3.18
COPY --from=builder /app/stress_app /stress_app
ENTRYPOINT ["/stress_app"]
