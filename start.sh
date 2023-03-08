#!/bin/sh

# thanks to https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc

# `--init` makes Tini PID 1 instead of TogglDesktop, allowing signals to work
# properly. See https://github.com/krallin/tini#using-tini,
# https://hackernoon.com/my-process-became-pid-1-and-now-signals-behave-strangely-b05c52cc551c

docker run -d \
	-v /etc/localtime:/etc/localtime:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e "DISPLAY=unix${DISPLAY}" \
	-v /usr/share/X11:/usr/share/X11:ro \
	-e "XAUTHORITY=/root/.Xauthority" \
	-v "${HOME}/.Xauthority:/root/.Xauthority" \
    -v "/tmp:/tmp" \
	-v "${HOME}/Documents/toggl-docker/homedir:/home/toggl" \
	--net host \
    --init \
	--name toggl \
	--rm \
    toggl \
|| exit 1

# wait for the window to appear initially
timeout 5 xdotool search --sync --onlyvisible --classname 'TogglDesktop' > /dev/null \
|| exit 1

# wait for it to disappear!
while [ $(xdotool search --onlyvisible --classname 'TogglDesktop' | wc -l) -ge 2 ]; do sleep 1; done

# kill the wretched thing
docker stop toggl
