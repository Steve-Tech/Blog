---
layout: post
title:  "Update MongoDB for Unifi Network Application 8"
---

I was trying to update MongoDB from 3.6 to 4.4 since the Unifi network app supports it now, and it'll get rid of those pesky GPG errors from APT.<!--more-->

**Make sure you have a backup before starting, especially of `/usr/lib/unifi/data/db`.**

#### Upgrade Steps

**You will need to iterate though each major version of MongoDB, e.g. 3.6 -> 4.0 -> 4.2 -> 4.4.**

1. Edit the APT repo

    ```sh
    nano /etc/apt/sources.list.d/mongodb-org-3.6.list
    ```

    Comment out the old one and add the new version, you will probably have to use `[allow-insecure=yes]` since the certificate has expired and APT doesn't like that.

    ```sh
    #deb [signed-by=/usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse

    deb [allow-insecure=yes] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse
    ```

    Remember you will need to iterate though every version, so you will need to change the `4.0` to `4.2`, then `4.4`, after each upgrade.

2. Update APT

    ```sh
    apt update
    apt upgrade
    # You will need this for the next step too:
    apt install mongodb-org-shell
    ```

3. Start `mongod` with the Unifi database

    ```sh
    screen mongod --dbpath /usr/lib/unifi/data/db
    ```

    Then detach the screen session so it runs in the background: `Ctrl+A`, then `D`

4. Upgrade the Mongo database

    Open a mongo shell, (using `mongo shell`) and follow the [official upgrade guide](https://www.mongodb.com/docs/manual/release-notes/4.0-upgrade-standalone/).

    For example, I did this for version 4.0:

    ```py
    db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )

    db.adminCommand( { setFeatureCompatibilityVersion: "4.0" } ) 

    db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )
    ```

5. Stop `mongod` from earlier

    ```sh
    screen -r
    ```

    Then type `Ctrl+C`, to stop it.

6. Restart from the beginning for the next version, until you get to your desired version.

#### Final Steps

1. Fix up the APT repo for version 4.4

    This will get rid of those GPG/verification errors.

    ```sh
    wget -qO- https://www.mongodb.org/static/pgp/server-4.4.asc \
    | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-org-server-4.4-archive-keyring.gpg

    echo "deb [arch=amd64,arm64 signed-by=/etc/apt/trusted.gpg.d/mongodb-org-server-4.4-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" \
    | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

    rm /etc/apt/sources.list.d/mongodb-org-3.6.list
    ```

2. Fix permissions (optional)

    If Unifi isn't starting, and you are getting permission denied errors in the mongo logs (`tail -f /var/log/unifi/mongod.log`), you may need to `chown` back to the unifi user.

    For example:

    ```sh
    chown -R unifi:unifi /usr/lib/unifi/data/db
    ```

#### Newer Versions

This guide should still work for newer versions of MongoDB, although there are a few exceptions:

- Versions 5.0 and newer no longer have major sub-versions, so you can skip some iteration steps e.g. only 4.4 -> 5.0 -> 6.0 -> 7.0 is required.
- Versions 7.0 and newer have added an additional `confirm` field to the set version command, so you will need to run `db.adminCommand( { setFeatureCompatibilityVersion: "7.0", confirm: true } )` instead.
