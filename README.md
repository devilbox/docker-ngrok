# Ngrok

[![Build Status](https://travis-ci.org/devilbox/docker-ngrok.svg?branch=master)](https://travis-ci.org/devilbox/docker-ngrok)
[![Tag](https://img.shields.io/github/tag/devilbox/docker-ngrok.svg)](https://github.com/devilbox/docker-ngrok/releases)
[![Gitter](https://badges.gitter.im/devilbox/Lobby.svg)](https://gitter.im/devilbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Discourse](https://img.shields.io/discourse/https/devilbox.discourse.group/status.svg?colorB=%234CB697)](https://devilbox.discourse.group)
[![](https://images.microbadger.com/badges/version/devilbox/ngrok.svg)](https://microbadger.com/images/devilbox/ngrok "ngrok")
[![](https://images.microbadger.com/badges/image/devilbox/ngrok.svg)](https://microbadger.com/images/devilbox/ngrok "ngrok")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

| Docker Hub | Upstream Project |
|------------|------------------|
| <a href="https://hub.docker.com/r/devilbox/ngrok"><img height="82px" src="http://dockeri.co/image/devilbox/ngrok" /></a> | <a href="https://github.com/cytopia/devilbox" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |


## Documentation

In case you seek help, go and visit the community pages.

<table width="100%" style="width:100%; display:table;">
 <thead>
  <tr>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.readthedocs.io">Documentation</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://gitter.im/devilbox/Lobby">Chat</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.discourse.group">Forum</a></h3></th>
  </tr>
 </thead>
 <tbody style="vertical-align: middle; text-align: center;">
  <tr>
   <td>
    <a target="_blank" href="https://devilbox.readthedocs.io">
     <img title="Documentation" name="Documentation" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/readthedocs.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://gitter.im/devilbox/Lobby">
     <img title="Chat on Gitter" name="Chat on Gitter" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/gitter.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://devilbox.discourse.group">
     <img title="Devilbox Forums" name="Forum" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/discourse.png" />
    </a>
   </td>
  </tr>
  <tr>
  <td><a target="_blank" href="https://devilbox.readthedocs.io">devilbox.readthedocs.io</a></td>
  <td><a target="_blank" href="https://gitter.im/devilbox/Lobby">gitter.im/devilbox</a></td>
  <td><a target="_blank" href="https://devilbox.discourse.group">devilbox.discourse.group</a></td>
  </tr>
 </tbody>
</table>


## Build

```bash
# Build the Docker image locally
make build

# Rebuild the Docker image locally without cache
make rebuild

# Test the Docker image after building
make test
```


## Environment variables

| Variable     | Default value | Description |
|--------------|---------------|-------------|
| HTTP_TUNNELS | `` | HTTP tunnel definition in the form of:<br/><code>&lt;domain.tld&gt;:&lt;addr&gt;:&lt;port&gt;</code><br/>or<br/><code>&lt;domain1.tld&gt;:&lt;addr&gt;:&lt;port&gt;,&lt;domain2.tld&gt;:&lt;addr&gt;:&lt;port&gt;</code><br/><br/><strong>Note:</strong> If you don't use a license you can only specify a single tunnel. If your license is pro enough, you can have multiple comma separated tunnels |
| REGION       | `` | Choose the region where the ngrok client will connect to host its tunnels. (Defaults to `us`) |.
| AUTHTOKEN    | `` | Your Ngrok license authtoken. You don't need to have a license for a single tunnel and can ommit this variable. Nevertheless they also have a free license that might be worth checking out |.

### HTTP_TUNNELS

* `<domain.tld>` is the virtual hostname that you want to serve via Ngrok
* `<addr>` is the hostname or IP address of the web server
* `<port>` is the port on which the web server is reachable via HTTP

```bash
# Make vhost "project1.loc" which runs on localhost:8080 available
HTTP_TUNNELS=project1.loc:localhost:8080

# Make two vhosts available which run on host apache:80
HTTP_TUNNELS=project1.loc:apache:80,project2.loc:apache:80

# Make two vhosts from two different web server addresses available 
HTTP_TUNNELS=project1.loc:localhost:8080,project2.loc:apache:80
```

### AUTHTOKEN

This token is provided to you after registering https://ngrok.com


## Exposed ports

| Container Port | Description |
|----------------|-------------|
| 4040           | Ngrok management console. Use it to obtain created outside DNS names after startup |


## Example

Forward webserver running on host os on ip `192.168.0.2` on port `8080` to the internet via Ngrok.

```bash
docker run -d --rm --name devilbox-ngrok \
  -e HTTP_TUNNELS="project1.loc:192.168.0.2:8080" \
  -p "4040:4040" \
  devilbox/ngrok
```

Open up your browser at http://127.0.0.1:4040 to see your DNS names.


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
