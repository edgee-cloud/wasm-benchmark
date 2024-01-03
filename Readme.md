# wasm-benchmark

## Prerequisites
- [Rust](https://www.rust-lang.org/tools/install)
- [Golang](https://go.dev/doc/install)
- [Wasmer](https://docs.wasmer.io/install)
- [WasmCloud](https://wasmcloud.com/docs/installation)
- [Wasmedge](https://wasmedge.org/docs/start/install)

Since some of our WebAssembly bytecode are written in Rust, you will need a Rust compiler. 
Make sure that you install the wasm32-wasi compiler target as follows, in order to generate WebAssembly bytecode.

```bash
rustup target add wasm32-wasi
```

Since some of our WebAssembly bytecode are written in Rust for Wasmer (wasix standard), you will need a wasix compiler.

```bash
cargo install cargo-wasix
```

## Build all the wasm bytecodes

```bash
make build
```

## Run each wasm bytecode and launch the benchmark

```bash
make run-rust
# then, open a new terminal and run
make siege
```

Do the same with `run-rust-old`, `make run-go`, `make make run-go-old`, `make run-rust-wasmer`, `make run-rust-wasmedge` and `make run-rust-wash`.

After the last one, don't forget to run `wash down` to stop the wasmcloud host.