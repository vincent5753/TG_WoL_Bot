# TG_WoL_Bot
## Intro
A bot that sends WoL to the host, whenever receive messages matched in `BootPhrase.txt`.

## Dependencies
`etherwake` for sending wake on lan packet
```
sudo apt-get install -y etherwake
```

Packages that is probably already built-in is your distro.
(if not, go install them)
1. `jq` for parsing json format messages.
2. `sed` for replacing chracters.


## Usage
1. Rename `Credential-example.sh` to `Credential.sh` and replace the token with your own one.
2. Add it to cron or use the way you wish it to run with.

## TDL
Adding feature to select host to boot up with.
