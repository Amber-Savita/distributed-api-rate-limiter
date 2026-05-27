# External Dependencies

This folder is intended for third-party source or library dependencies.

## hiredis

Place the hiredis source tree in `external/hiredis`, or install a system library.

### Option 1: Vendored source
Clone the hiredis repo:

```bash
git clone https://github.com/redis/hiredis.git external/hiredis
```

Then rerun CMake from the project root.

### Option 2: System library
Install hiredis using your package manager or vcpkg and make sure CMake can find it.

### Build steps

From repository root:

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### Redis runtime

If you want to run the server in Docker:

```bash
docker run -p 6379:6379 redis:latest
```
