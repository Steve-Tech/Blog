---
layout: post
title:  "Docker Rclone schedule sync with cron inside container"
---

I was looking for a way to backup my frigate snapshots to a cloud service, and the [official rclone docker container](https://hub.docker.com/r/rclone/rclone) actually already ships with cron installed, so all you have to do is run the container with the command<!--more-->:

```sh
/bin/sh -c '(echo "* * * * * if ! pidof rclone; then rclone sync /data remote:data; fi" | crontab -) && crond -f'
```

That will add the rclone command to the crontab to run every minute if it's not already running, then start the cron daemon in the foreground, so the container doesn't exit.

**For example, here's the full docker command**:

```sh
docker run \
    --volume ~/.config/rclone:/config/rclone \
    --volume ~/data:/data:shared \
    --user $(id -u):$(id -g) \
    --entrypoint '/bin/sh' \
    rclone/rclone \
    '-c' '(echo "* * * * * if ! pidof rclone; then rclone sync /data remote:data; fi" | crontab -) && crond -f'
```

Yes, you could also just start the container from cron on the host, but I didn't like the log spam it created and wanted to keep it all in docker.
