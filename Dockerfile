FROM nvcr.io/nvidia/cuda:12.0.0-devel-ubuntu20.04
MAINTAINER Howardkhh

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y \
    && apt-get install -y tzdata && ln -fs /usr/share/zoneinfo/Asia/Taiwan /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && apt install -y sudo vim wget zip git libgl1-mesa-glx libglib2.0-0\
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libgflags-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/colmap/colmap.git \
    && cd colmap \
    && git checkout dev \
    && mkdir build \
    && sed -i '1s/^/set(CMAKE_CUDA_ARCHITECTURES "all-major") /' CMakeLists.txt \
    && cd build \
    && cmake .. -GNinja \
    && ninja \
    && sudo ninja install \
    && cd .. \
    && rm -rf colmap

COPY ./requirements.txt ./
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "Running $(conda --version)" \
    && conda init bash \
    && . /root/.bashrc \
    && conda create -n multinerf -c conda-forge -y python==3.9 \
    && conda activate multinerf \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
	&& pip install --no-cache-dir --upgrade "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    && git clone https://github.com/rmbrualla/pycolmap.git ./internal/pycolmap 

RUN echo "conda activate multinerf" >> /root/.bashrc

WORKDIR /root/multinerf
CMD ["/bin/bash"]