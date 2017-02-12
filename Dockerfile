FROM fedora:25
MAINTAINER Gerard Braad <me@gbraad.nl>

RUN dnf update -y && \
    dnf clean all

# /home/steam/.local/share/Steam/ ?
ENV WORKSPACE=/home/steam \
    UID=1000

# Create user, make root folder and change ownership
RUN mkdir -p ${WORKSPACE} && \
    chown -R ${UID}:0 ${WORKSPACE} && \
    adduser user -u ${UID} -g 0 -r -m -d ${WORKSPACE} -c "Default Application User" -l

# Dependencies
RUN dnf install -y \
        glibc.i686 \
        libstdc++.i686 \
        wget \
        tar && \
    dnf clean all

WORKDIR ${WORKSPACE}
USER 1000
#VOLUME ${WORKSPACE}/.steam

# Install into user's workspace
RUN mkdir -p ${WORKSPACE}/.steam && \
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz -P /tmp/ && \
    tar -xvzf /tmp/steamcmd_linux.tar.gz -C ${WORKSPACE}/.steam && \
    rm -f /tmp/steamcmd_linux.tar.gz

# Allow update process to run for first-run
RUN ${WORKSPACE}/.steam/steamcmd.sh +quit

CMD ${WORKSPACE}/.steam/steamcmd.sh
