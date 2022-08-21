const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addSharedLibrary("cart", "src/main.zig", .unversioned);

    lib.setBuildMode(mode);
    initWasm4Lib(lib);
    lib.install();

    const small_lib = b.addSharedLibrary("cart_small", "src/main.zig", .unversioned);
    small_lib.setBuildMode(.ReleaseSmall);
    small_lib.strip = true;
    initWasm4Lib(small_lib);
    const install_small_lib = b.addInstallArtifact(small_lib);

    const optimize = b.addSystemCommand(&[_][]const u8{
        "wasm-opt",
        "-Oz",
        "--strip-dwarf",
        "--strip-producers",
        "--zero-filled-memory",
        "-o",
        "zig-out/lib/cart_optimized.wasm",
        "zig-out/lib/cart_small.wasm",
    });
    optimize.step.dependOn(&install_small_lib.step);

    const optimize_step = b.step("optimized", "creates a relase-fast and wasm-opt optimized build");
    optimize_step.dependOn(&optimize.step);

    const name = "wasm-cities";

    const copy_cart = b.addInstallBinFile(.{ .path = "zig-out/lib/cart_optimized.wasm" }, "cart.wasm");

    const bundle = b.addSystemCommand(&[_][]const u8{
        "w4",
        "bundle",
        "--title",
        "WASM Cities",
        "--html",
        "zig-out/bin/index.html",
        "--linux",
        "zig-out/bin/" ++ name ++ "-linux",
        "--mac",
        "zig-out/bin/" ++ name ++ "-mac",
        "--windows",
        "zig-out/bin/" ++ name ++ "-windows.exe",
        "zig-out/lib/cart_optimized.wasm",
    });
    bundle.step.dependOn(&optimize.step);

    const bundle_step = b.step("bundle", "creates a relase-fast and wasm-opt optimized build");
    bundle_step.dependOn(&bundle.step);
    bundle_step.dependOn(&copy_cart.step);

    const tests = b.addTest("src/main.zig");
    addPackages(tests);
    tests.setBuildMode(mode);
    tests.setTarget(.{ .cpu_arch = .wasm32, .os_tag = .wasi });
    tests.builder.enable_wasmtime = true;
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&tests.step);

    const native_target = b.standardTargetOptions(.{});
    const generate_sprites_exe = b.addExecutable("generate_sprites", "tools/generate_sprites.zig");
    generate_sprites_exe.use_stage1 = true;
    generate_sprites_exe.setTarget(native_target);
    generate_sprites_exe.setBuildMode(.Debug);
    generate_sprites_exe.addPackagePath("zigimg", "libs/zigimg/zigimg.zig");

    const run_generate_sprites = generate_sprites_exe.run();
    if (b.args) |args| {
        run_generate_sprites.addArgs(args);
    }

    const generate_sprites_step = b.step("generate_sprites", "Converts assets");
    generate_sprites_step.dependOn(&run_generate_sprites.step);

    const watch = b.addSystemCommand(&[_][]const u8{
        "w4",
        "watch",
        "--no-open",
    });

    const watch_step = b.step("watch", "runs w4 watch -n");
    watch_step.dependOn(&watch.step);
}

fn initWasm4Lib(lib: *std.build.LibExeObjStep) void {
    addPackages(lib);
    lib.setTarget(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    lib.use_stage1 = true;
    lib.import_memory = true;
    lib.initial_memory = 65536;
    lib.max_memory = 65536;
    lib.stack_size = 14752;
    lib.export_symbol_names = &[_][]const u8{ "start", "update" };
}

fn addPackages(lib: *std.build.LibExeObjStep) void {
    lib.addPackagePath("main", "src/main.zig");
    lib.addPackagePath("wasm4", "src/wasm4.zig");
}
