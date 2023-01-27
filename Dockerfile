# syntax=docker/dockerfile:1.2
# First stage
FROM ubuntu:20.04 as install
# cheating for now
ENV VERSION 15
COPY bin-exclude/stata-installed-${VERSION}.tgz /root/stata.tgz
RUN cd / && tar xzf $HOME/stata.tgz \
    && rm $HOME/stata.tgz 
# No need to update old versions
# make sure we don't accidentally copy in the license
RUN test -f /usr/local/stata/stata.lic && rm /usr/local/stata/stata.lic || echo "Not found"

# Final build
FROM ubuntu:20.04
RUN apt-get update \
    && apt-get install -y locales libncurses5  \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV libpng http://ppa.launchpad.net/linuxuprising/libpng12/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1+1~ppa0~focal_amd64.deb
RUN apt-get update \
    && apt-get install -y wget \
    && wget -O libpng.deb "${libpng}" \
    && dpkg --install libpng.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f libpng.deb

# Create a non-root user
RUN groupadd -g 1000 stata \ 
    && useradd -r -u 1000 -g stata statauser \
    && mkdir -p /home/statauser \
    && chown statauser:stata /home/statauser

# Set a few more things
ENV LANG en_US.utf8

# copying from first stage
COPY --from=install /usr/local/stata/ /usr/local/stata/
RUN echo "export PATH=/usr/local/stata:${PATH}" >> /root/.bashrc
ENV PATH "$PATH:/usr/local/stata" 

USER statauser:stata
WORKDIR /code

# if you wanted to make this a project specific image,
# do the following:
#
#  COPY setup.do /code
#  RUN cd /code && stata -b do setup.do
#

ENTRYPOINT ["stata-mp"]

