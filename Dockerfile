FROM ubuntu:16.04
MAINTAINER MichaelPak

ARG SERVER_PORT
ARG TICK_RATE
ARG MAX_PLAYERS
ARG MAP
ARG GAME_TYPE
ARG GAME_MODE

ENV USER steam
ENV HOME /home/$USER
ENV SERVER $HOME/server

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install lib32gcc1 wget net-tools lib32stdc++6 zlib1g libffi6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -m $USER

USER $USER
RUN mkdir $SERVER && cd $SERVER \
    && wget http://media.steampowered.com/client/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz \
    && ./steamcmd.sh +login anonymous +force_install_dir ./csgo +app_update 740 validate +quit

EXPOSE $SERVER_PORT/udp

WORKDIR $SERVER

ENTRYPOINT ["sh", "-c", "csgo/srcds_run"]
CMD ["-game csgo", "-console", "-tickrate $TICK_RATE", "-port $SERVER_PORT", "-maxplayers_override $MAX_PLAYERS", "+game_type $GAME_TYPE", "+game_mode $GAME_MODE", "+map $MAP", "+sv_steamaccount $TOKEN"]