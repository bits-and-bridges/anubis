FROM golang:1.27.3-alpine AS builder
WORKDIR /app
COPY . .
# Install all dependencies including C compiler, Cargo, zstd, and brotli
RUN apk add --no-cache nodejs npm python3 make bash git curl clang cargo zstd brotli
# Install Rust stable with WASM target
ENV PATH="/root/.cargo/bin:$PATH"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rustup target add wasm32-unknown-unknown
# Build Anubis
RUN make build

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/var/anubis /app/anubis
COPY --from=builder /app/var/robots2policy /app/robots2policy
EXPOSE 8080
CMD ["./anubis"]
