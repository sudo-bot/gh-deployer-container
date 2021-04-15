# gh-deployer-container

The container for gh-deployer

/!\ This is designed to deploy phpMyAdmin instances, improve it if you want.

## manual use of the phpMyAdmin container

You can also specify:

- a SHA `-e GIT_SHA=8669c00fff7c08ac58917e3fcc7f87e28f2052c5`
- a network `--network mynetwork` (see: `docker network ls`)
- a config `-e PMA_CONFIG="$(cat config.inc.php | base64 -w0)"` (if not provided the one built into the container will be used)

(RANDOM_STRING is just for phpMyAdmin config `blowfish_secret`)

```sh
docker run --rm --name myDeployedContainer1 \
    -p 8085:80 \
    -e GIT_URL=https://github.com/iifawzi/phpmyadmin.git \
    -e GIT_BRANCH=designer-rtl-support \
    -e RANDOM_STRING=d4a5c8571aff3df8965e7086fd500a88b64c41411d9 \
        ghcr.io/sudo-bot/gh-deployer-container/phpmyadmin
```

### Stop the container

/!\ This will auto destroy the containers contents (`--rm`)
Run: `docker stop myDeployedContainer1`
