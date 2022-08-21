# WASM Cities

## Development

### Clone repo

```
git clone https://github.com/luehmann/wasm-cities.git --recurse-submodules
```

### Build

```
zig build
```

### Watch

```
zig build watch
```

### Test

```
zig build test
```

### Tools

#### generate_sprites

```
zig build generate_sprites
```

## Release

### Optimized `.wasm` file

```
zig build optimized
```

### Report on output size

```
ls -lh zig-out/lib
```

### Bundle

```
zig build bundle
```

## Dependencies

- [Zig](https://ziglang.org/)
- [WASM4](https://wasm4.org/)
- [wasm-opt](https://github.com/WebAssembly/binaryen)
- [wasmtime](https://wasmtime.dev/)

Other dependencies are provided under `/libs` as git submodules.
