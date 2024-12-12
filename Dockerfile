FROM containers.mathworks.com/matlab-runtime:r2024b

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/simnibs /opt/downloads /opt/install && \
    useradd -m simnibs && \
    chown simnibs /opt/simnibs /opt/downloads /opt/install

WORKDIR /opt/install

USER simnibs

RUN wget -O /opt/downloads/simnibs_installer_linux.tar.gz https://github.com/simnibs/simnibs/releases/download/v3.2.6/simnibs_installer_linux.tar.gz && \
    tar -xzf /opt/downloads/simnibs_installer_linux.tar.gz && \
    simnibs_installer/install -t /opt/simnibs -s && \
    rm -rf /opt/install/* /opt/downloads/*

WORKDIR /home/simnibs

ENV PATH="/opt/simnibs/bin:${PATH}"

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}\
/opt/matlabruntime/R2024b/runtime/glnxa64:\
/opt/matlabruntime/R2024b/bin/glnxa64:\
/opt/matlabruntime/R2024b/sys/os/glnxa64:\
/opt/matlabruntime/R2024b/extern/bin/glnxa64"

ENTRYPOINT ["/bin/bash"]
