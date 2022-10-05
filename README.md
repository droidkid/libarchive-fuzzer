Scripts and results from Fuzzing libarchive for [CS6963 Lab 3](https://www.cs.utah.edu/~snagy/courses/cs5963/assignments.html).

Some results of my fuzzing campaign are in campaign-results.

This was basically adapted from the oss-fuzz libarchive project. 
The scripts I've written are very brittle, so YMMV.

## Fuzz Campaign

To run fuzz campaign,
```
$ ./build-coverage.sh
$ cd fuzzer
$ afl-fuzz -i seed/ -o campaign -- ./fuzzer @@
```

## Coverage
To generate coverage report, cd into `src-cov` and run
```
$ ./build-aflharness.sh
$ ./build-coverage.sh
```

This should generate a folder named `html-coverage` which should have coverage results.
