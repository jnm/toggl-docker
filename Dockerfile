FROM ubuntu:jammy
RUN apt-get update && apt-get install -y wget \
    && wget --quiet --output-document=/tmp/toggldesktop.deb \
        https://github.com/toggl-open-source/toggldesktop/releases/download/v7.5.363/toggldesktop_7.5.363_ubuntu1604_amd64.deb \
    && apt-get install -y /tmp/toggldesktop.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN adduser --disabled-password --gecos '' toggl
USER toggl:toggl
CMD ["/usr/lib/toggldesktop/bin/TogglDesktop"]
