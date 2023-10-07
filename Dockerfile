# syntax=docker/dockerfile:1.2
ARG SRCVERSION=18
ARG SRCTAG=2023-10-04
ARG SRCHUBID=dataeditors

FROM ${SRCHUBID}/stata${SRCVERSION}:${SRCTAG}

# install any packages into the home directory as the user,
USER statauser
COPY setup.do /setup.do
WORKDIR /home/statauser

# copy the license in so we can do the install of packages
USER root
RUN --mount=type=secret,id=statalic \
    cp /run/secrets/statalic /usr/local/stata/stata.lic \
    && chmod a+r /usr/local/stata/stata.lic \
    && /usr/local/stata/stata do /setup.do | tee setup.$(date +%F).log \
    && rm /usr/local/stata/stata.lic

# Setup for standard operation
USER statauser
VOLUME /project
WORKDIR /project
#ENTRYPOINT ["stata-mp"]

