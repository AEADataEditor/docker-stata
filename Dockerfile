# First stage
FROM ubuntu:20.04 as install
# cheating for now
ENV VERSION 17
COPY bin-exclude/stata-installed-${VERSION}.tgz /root/stata.tgz
RUN cd / && tar xzf $HOME/stata.tgz \
    && rm $HOME/stata.tgz 
ADD stata.lic.${VERSION} /usr/local/stata${VERSION}/stata.lic
# do a small install and update
RUN apt-get update \
    && apt-get install -y locales libncurses5 
RUN /usr/local/stata${VERSION}/stata update all 

# Final build
FROM ubuntu:20.04
RUN apt-get update \
    && apt-get upgrade -y  \
    && apt-get install -y locales libncurses5 \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# Create a non-root user
RUN groupadd -g 1000 stata \ 
    && useradd -r -u 1000 -g stata statauser \
    && mkdir -p /home/statauser \
    && chown statauser:stata /home/statauser

# Set a few more things
ENV LANG en_US.utf8
ENV VERSION 17

# copying from first stage
COPY --from=install /usr/local/stata${VERSION}/ /usr/local/stata${VERSION}/
RUN ln -s /usr/local/stata${VERSION} /usr/local/stata \
    && echo "export PATH=/usr/local/stata:${PATH}" >> /root/.bashrc
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

