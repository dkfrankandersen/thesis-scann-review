FROM fa-scann-base:latest

WORKDIR /home/
COPY . .

RUN cd scann && python3 configure.py
RUN PY3="$(which python3)" && cd scann && PYTHON_BIN_PATH=$PY3 CC=clang-8 bazel-3.4.1 build -c opt --features=thin_lto --copt=-mavx2 --copt=-mfma --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --cxxopt="-std=c++17" --copt=-fsized-deallocation --copt=-w :build_pip_pkg
RUN cd scann && PYTHON=python3 ./bazel-bin/build_pip_pkg && pip3 install *.whl

RUN /bin/bash