FROM swift:5.1

RUN apt-get update && \
    apt-get install -y \
    aapt \
    lib32z1 \
    libc6-dev-i386 \
    libgd-dev \
    libssl-dev \
    openssl \
    software-properties-common \
    unzip && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    python3.8 \
    python3-dev \
    python3-pip \
    python3-software-properties \
    python3-virtualenv && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
