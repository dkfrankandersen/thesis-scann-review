FROM ubuntu:18.04

RUN apt update
RUN apt install -y python3-numpy python3-scipy python3-pip build-essential git
RUN pip3 install -U pip

RUN apt install -y software-properties-common curl gnupg rsync

RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt update && apt install -y bazel-3.4.1

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt update
RUN apt install -y g++-9 clang-8
RUN apt install -y nano

RUN pip3 install --upgrade pip

WORKDIR /home/
COPY . .

RUN pip3 install tensorflow-2.6.0-cp36-cp36m-manylinux2010_x86_64.whl

#RUN git clone https://github.com/google-research/google-research.git --depth=1
#RUN cd google-research/scann && python3 configure.py
#RUN git clone https://github.com/dkfrankandersen/thesis-scann-review
RUN cd scann && python3 configure.py
RUN PY3="$(which python3)" && cd scann && PYTHON_BIN_PATH=$PY3 CC=clang-8 bazel-3.4.1 build -c opt --features=thin_lto --copt=-mavx2 --copt=-mfma --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --cxxopt="-std=c++17" --copt=-fsized-deallocation --copt=-w :build_pip_pkg
RUN cd scann && PYTHON=python3 ./bazel-bin/build_pip_pkg && pip3 install *.whl
#RUN python3 -c 'import scann'