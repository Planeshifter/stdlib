
# VARIABLES #

# Define the path to a script for compiling a C benchmark:
compile_c_benchmark_bin := $(TOOLS_DIR)/scripts/compile_c_benchmark


# TARGETS #

#/
# Runs C benchmarks consecutively.
#
# ## Notes
#
# -   This recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This recipe is useful when wanting to glob for C benchmark files (e.g., run all C benchmarks for a particular package).
#
#
# @param {string} [BENCHMARKS_FILTER] - filepath pattern (e.g., `.*/math/base/special/abs/.*`)
# @param {string} [C_COMPILER] - C compiler (e.g., `gcc`)
# @param {string} [BLAS] - BLAS library name (e.g., `openblas`)
# @param {string} [BLAS_DIR] - BLAS directory
#
# @example
# make benchmark-c
#/
benchmark-c:
	$(QUIET) $(FIND_C_BENCHMARKS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && $(MAKE) clean && \
		OS="$(OS)" \
		NODE="$(NODE)" \
		NODE_PATH="$(NODE_PATH)" \
		C_COMPILER="$(CC)" \
		BLAS="$(BLAS)" \
		BLAS_DIR="$(BLAS_DIR)" \
		CEPHES="$(DEPS_CEPHES_BUILD_OUT)" \
		CEPHES_SRC="$(DEPS_CEPHES_SRC)" \
		"${compile_c_benchmark_bin}" $$file && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-c

#/
# Runs a specified list of C benchmarks consecutively.
#
# ## Notes
#
# -   This recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This recipe is useful when wanting to run a list of C benchmark files generated by some other command (e.g., a list of changed C benchmark files obtained via `git diff`).
#
#
# @param {string} FILES - list of C benchmark file paths
# @param {string} [C_COMPILER] - C compiler (e.g., `gcc`)
# @param {string} [BLAS] - BLAS library name (e.g., `openblas`)
# @param {string} [BLAS_DIR] - BLAS directory
#
# @example
# make benchmark-c-files FILES='/foo/benchmark.c /bar/benchmark.c'
#/
benchmark-c-files:
	$(QUIET) for file in $(FILES); do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && $(MAKE) clean && \
		OS="$(OS)" \
		NODE="$(NODE)" \
		NODE_PATH="$(NODE_PATH)" \
		C_COMPILER="$(CC)" \
		BLAS="$(BLAS)" \
		BLAS_DIR="$(BLAS_DIR)" \
		CEPHES="$(DEPS_CEPHES_BUILD_OUT)" \
		CEPHES_SRC="$(DEPS_CEPHES_SRC)" \
		"${compile_c_benchmark_bin}" $$file && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-c-files
