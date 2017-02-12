FROM fedora:25
MAINTAINER Gerard Braad <me@gbraad.nl>

RUN dnf update -y && \
    dnf clean all

ENV HOME=/home/user \
    USERNAME=user \
    UID=1000 \
    WORKSPACE=/home/user/Steam

# Create user, make root folder and change ownership
RUN mkdir -p ${HOME} && \
    chown -R ${UID}:0 ${HOME} && \
    adduser ${USERNAME} -u ${UID} -g 0 -r -m -d ${HOME} -c "Default Application User" -l

# Dependencies
RUN dnf install -y \
        glibc.i686 \
        libstdc++.i686 \
        curl \
        tar && \
    dnf clean all

USER ${UID}

# Install into user's workspace
RUN mkdir -p ${WORKSPACE} && \
    cd ${WORKSPACE} && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

WORKDIR ${WORKSPACE}
VOLUME ${WORKSPACE}

# Allow update process to run for first-run
RUN ${WORKSPACE}/steamcmd.sh +quit

CMD ${WORKSPACE}/steamcmd.sh

