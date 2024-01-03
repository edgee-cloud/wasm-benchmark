.PHONY: all
MAKEFLAGS += --silent


all: help

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| sed -e "s/^Makefile://" -e "s///" \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

build: ## Build all the things
	make build-rust
	make build-rust-old
	make build-rust-wasmedge
	make build-rust-wasmer
	make build-go
	make build-go-old

build-rust: ## Build rust
	cd rust && cargo build --release --bin rust-server
	mv rust/target/release/rust-server bin/rust-server

build-rust-old: ## Build rust old code
	cd rust-old && cargo build --release --bin rust-old-server
	mv rust-old/target/release/rust-old-server bin/rust-old-server

build-rust-wasmedge: ## Wasmedge build (from rust)
	cd rust-wasmedge && cargo build --target wasm32-wasi --release --bin rust-wasm-server
	mv rust-wasmedge/target/wasm32-wasi/release/rust-wasm-server.wasm bin/rust-wasm-server.wasm

build-rust-wasmer: ## Wasmer build (from rust)
	cd rust-wasmer && cargo wasix build --release
	mv rust-wasmer/target/wasm32-wasmer-wasi/release/rust-wasmer.wasm bin/rust-wasmer-server.wasm

build-go: ## Build go
	cd go && go build -o go-server main.go
	mv go/go-server bin/go-server

build-go-old: ## Build go old code
	cd go-old && go build -o go-old-server main.go
	mv go-old/go-old-server bin/go-old-server

run-rust: ## Run rust
	./bin/rust-server

run-rust-old: ## Run rust old
	./bin/rust-old-server

run-rust-wasm: ## Run rust wasm
	wasmedge bin/rust-wasm-server.wasm

run-rust-wasmer: ## Run rust wasmer
	wasmer run ./bin/rust-wasmer-server.wasm --net --enable-threads --enable-bulk-memory --env PORT=8080

run-rust-wash: ## Run rust wasmcloud (wash)
	cd rust-wash && wash up -d && wash app deploy wadm.yaml

run-go: ## Run go
	./bin/go-server

run-go-old: ## Run go old
	./bin/go-old-server

siege: ## Siege
	siege -c 5 -b -t 5s http://localhost:8080
