FROM sandreas/m4b-tool

VOLUME /temp
VOLUME /config

ENV PUID=""
ENV PGID=""
ENV CPU_CORES=""
ENV SLEEPTIME=""

WORKDIR /temp

ADD runscript.sh /
ADD auto-m4b-tool.sh /

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  apk add --no-cache --update --upgrade \
  setpriv \
  coreutils \
  findutils \
  bash

CMD ["/auto-m4b-tool.sh"]
ENTRYPOINT ["/runscript.sh"]
