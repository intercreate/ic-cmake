# Intercreate CMake

This CMake library adds convenience functions to the build system.

# Include in Your Project

1. Add the fetch file to your repo: 
  ```
  wget https://github.com/intercreate/ic-cmake/releases/latest/download/fetch_ic.cmake
  ```
2. Include and link in your CMakeLists.txt:
  ```cmake
  include(fetch_ic.cmake)
  ```

# Tests

```
cmake -P tests/script.cmake
```

# Contributions

* Fork this repository: https://github.com/intercreate/ic-cmake/fork
* Clone your fork: `git clone git@github.com:<YOUR_FORK>/ic-cmake.git`
  * then change directory to your cloned fork: `cd ic-cmake`
* Enable the githook: `git config core.hooksPath .githooks`
