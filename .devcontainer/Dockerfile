FROM debian:bookworm

RUN apt-get update && apt-get -y install \
  curl \
  gnupg \
  ca-certificates \
  apt-transport-https \
  git \
  make \
  clang \
  zstd \
  brotli \
  bash \
  && rm -rf /var/lib/apt/lists/*

# Install Go
RUN curl -fsSL https://dl.google.com/go/go1.27.3.linux-amd64.tar.gz | tar -C /usr/local -xz

# Install Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/usr/local/go/bin:/root/.cargo/bin:$PATH"

WORKDIR /workspace/anubis

COPY . .
RUN npm install --ignore-scripts
RUN npm run assets:wasm 2>&1 || true
RUN npm run assets:wasm2js 2>&1 || true  
RUN npm run assets:web 2>&1 || true

CMD ["/usr/bin/sleep", "infinity"]
