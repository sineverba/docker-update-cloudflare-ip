Docker Update Cloudflare IP
===========================

> Docker image to update Cloudflare IP into Home Assistant config file

This image download the list of IP of Cloudflare from [https://www.cloudflare.com/ips-v4](https://www.cloudflare.com/ips-v4) and overwrite
a list found in `configuration.yml` file of [Home Assistant](https://www.home-assistant.io/)

Cloudflare is a trademark of Cloudflare itself.


| CI / CD | Status |
| ------- | ------ |
| Semaphore | [![Build Status](https://sineverba.semaphoreci.com/badges/docker-update-cloudflare-ip/branches/master.svg?style=shields&key=941be431-667e-48be-ac26-0e15e69f934d)](https://sineverba.semaphoreci.com/projects/docker-update-cloudflare-ip) |


## Available architectures

+ linux/amd64
+ linux/arm/v6
+ linux/arm/v7
+ linux/arm64/v8

## Run

1. Edit your `config/configuration.yaml` file adding `#STARTCLOUDFLARE` and `#ENDCLOUDFLARE` block.

```yaml
# Configure a default setup of Home Assistant (frontend, api, etc)
default_config:

http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.18.0.0/24
    - 172.19.0.0/24
#STARTCLOUDFLARE
	- 172.64.0.0/13
	- 104.24.0.0/14
	- 104.16.0.0/13
	- 162.158.0.0/15
	- 198.41.128.0/17
	- 197.234.240.0/22
	- 188.114.96.0/20
	- 190.93.240.0/20
	- 108.162.192.0/18
	- 141.101.64.0/18
	- 103.31.4.0/22
	- 103.22.200.0/22
	- 103.21.244.0/22
	- 173.245.48.0/20
#ENDCLOUDFLARE
    #- 172.10.0.0/24
    #- 172.20.0.0/24
    #- 172.21.0.0/24
    #- 172.19.0.0/24
    #- 172.18.0.0/24

homeassistant:
  customize: !include customize.yaml
  packages: !include_dir_named packages
```

2. Run Docker container __from homeassistant directory itself__ `$ docker run --rm -it -v "$(PWD)"/config:/config --name update-cloudflare-ip sineverba/update-cloudflare-ip:1.0.0`

3. Check in Home Assistant if file is working before restart
