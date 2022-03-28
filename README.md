

## How to download and update fw-test-im3000e submodule.

```
git submodule update --init --recursive
```

## Build fw-test-im3000e

Once you have the repo cloned (as submodule) it can be built in a build directory like this:

```
fw-test-im3000e$ mkdir build && cd build
fw-test-im3000e/build$ cmake -DIMSYS_IMTOOLS_DIR=/opt/tool-imtools ..
fw-test-im3000e/build$ cmake --build .
```

The first cmake command is needed only the first time. But it is also fine if both commands are executed always.
You get generated files in fw-test-im3000e/build/bin.