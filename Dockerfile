FROM python:2.7

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-multilib \
    g++-multilib \
    git \
    m4 \
    scons \
    zlib1g \
    zlib1g-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libprotoc-dev \
    libgoogle-perftools-dev \
    python-dev \
    python \
    wget \
    libpci3 \
    libelf1 \
    vim

# Get files needed for gem5, apply patches, build
RUN git clone --single-branch --branch agutierr/master-gcn3-staging https://gem5.googlesource.com/amd/gem5
COPY gem5.patch .
RUN git -C /gem5/ checkout d0945dc2 && git apply gem5.patch --directory=gem5
RUN chmod 777 /gem5

COPY tests/ tests/

RUN cd /gem5 && scons -j$(nproc) build/GCN3_X86/gem5.opt --ignore-style

CMD bash
