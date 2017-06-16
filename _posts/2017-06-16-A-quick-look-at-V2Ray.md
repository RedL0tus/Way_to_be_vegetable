---
layout: post
title:  "A quick look at V2Ray"
date:   2017-06-16 15:04:50 +0800
---

A normal way to escape from censorship or blockage of access to information is to use proxy.

There are several different proxy protocols and software. And today I'm gonna talk about V2Ray.

It's home page is https://www.v2ray.com.

It's written in Golang, with these features:
1. It supports several protocols (SOCKS, HTTP, Shadowsocks, VMess)(And VMess is it's own protocol).
2. Built-in routing support.
3. Cross-platform support.

But these features also causes it's a bit hard for newbies to configure it.

But in fact, if you just need basic proxy features, it could be very easy to use.

First, V2Ray use JSON as the format of configuration file. A basic configuration of V2Ray can be split to several parts: `inbound`, `outbound` and `routing`.

`inbound` is just about how others connect to V2Ray software.  
`outbound` is about how V2Ray connect to the web or other V2Ray servers.  
`routing` is the part to configure the route of packages.

Also there are `inboundDetour`/`outboundDetour` and parts about how to transport packages.

###**In the part `inbound`:**
 
For servers, inbound have to be the protocol and ports that clients will connect. As an example:


    "inbound": {
      "port": 37192, // port
      "protocol": "vmess",    // main inbound protocol
      "settings": {
        "clients": [
          {
            "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",  // User ID
            "level": 1  // User level 
          }
        ]
      }
    }

In the example, `port` will be the port that clients will connect; `protocol` is the protocol it gonna use; `settings` are the parameters of inbound protocols.

For more detailed information about VMess and it's settings, please visit: https://www.v2ray.com/chapter_04/03_vmess.html

For clients, inbound have to be the settings of how other applications connects to it. For example:

    "inbound": {
      "port": 1080, // port
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": false
      }
    }

`port` is the port that other applications will connect; `protocol` is the protocol it will use. For now V2Ray supports SOCKS5 and HTTP.

For detailed information, please visit: https://www.v2ray.com/chapter_04/03_vmess.html


###**In the part `outbound`:**

For servers, this part is about how V2Ray communicates with the web.

    "outbound": {
      "protocol": "freedom",  
      "settings": {}
    }

In this example, traffics will use a protocol called `freedom`. In fact, it's just about to make normal TCP/UDP connections to the web.

For more detailed information about `freedom`, please visit: https://www.v2ray.com/chapter_02/protocols/freedom.html

For clients, this part is about how V2Ray communicates with V2Ray on the server.

    "outbound": {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "8.8.8.8", // Server IP
            "port": 17173,  // Server port
            "users": [
              {
                "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", // User ID
                "security": "aes-128-gcm", 
                "alterId": 128
              },
            ]
          }
        ]
      }
    }

Note that in this part, all of the settings **must** be the same with the server.

For more detailed information about VMess and it's settings, please visit: https://www.v2ray.com/chapter_04/03_vmess.html


###**In the part `routing`:**

Absolutely it's about routing of packages.

For detailed information, please visit: https://www.v2ray.com/chapter_02/03_routing.html

Here is an example about `routing`:

    "routing": {
      "strategy": "rules",
      "settings": {
        "rules": [
          {
            "type": "field",
            "ip": [
              "0.0.0.0/8",
              "10.0.0.0/8",
              "100.64.0.0/10",
              "127.0.0.0/8",
              "169.254.0.0/16",
              "172.16.0.0/12",
              "192.0.0.0/24",
              "192.0.2.0/24",
              "192.168.0.0/16",
              "198.18.0.0/15",
              "198.51.100.0/24",
              "203.0.113.0/24",
              "::1/128",
              "fc00::/7",
              "fe80::/10"
            ],
            "outboundTag": "blocked"
          }
        ]
      }
    }

P.S. "outboundTag" determines which route the traffics that meets the rules above will go. It's about inboundDetor/outboundDetor, please visit official manual.

###**Here is the basic config:**

**Server:**

    {
      "inbound": {
        "port": 12138,
        "protocol": "vmess",
        "settings": {
          "clients": [
            {
              "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
              "level": 1,
              "alterId": 128
            }
          ]
        }
      },
      "outbound": {
        "protocol": "freedom",
        "settings": {}
      },
      "outboundDetour": [
        {
          "protocol": "blackhole",
          "settings": {},
          "tag": "blocked"
        }
      ],
      "routing": {
        "strategy": "rules",
        "settings": {
          "rules": [
            {
              "type": "field",
              "ip": [
                "0.0.0.0/8",
                "10.0.0.0/8",
                "100.64.0.0/10",
                "127.0.0.0/8",
                "169.254.0.0/16",
                "172.16.0.0/12",
                "192.0.0.0/24",
                "192.0.2.0/24",
                "192.168.0.0/16",
                "198.18.0.0/15",
                "198.51.100.0/24",
                "203.0.113.0/24",
                "::1/128",
                "fc00::/7",
                "fe80::/10"
              ],
              "outboundTag": "blocked"
            }
          ]
        }
      }
    }

**Client:**

    {
      "inbound": {
        "port": 1080,
        "protocol": "socks",
        "settings": {
          "auth": "noauth",
          "udp": true
        }
      },
      "outbound": {
        "protocol": "vmess",
        "settings": {
          "vnext": [
            {
              "address": "8.8.8.8",
              "port": 12138,
              "users": [
                {
                  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                  "alterId": 128,
                  "security": "aes-128-gcm"
                }
              ]
            }
          ]
        }
      },
      "outboundDetour": [
        {
          "protocol": "freedom",
          "settings": {},
          "tag": "direct"
        }
      ],
      "routing": {
        "strategy": "rules",
        "settings": {
          "rules": [
            {
              "type": "field",
              "ip": [
                "0.0.0.0/8",
                "10.0.0.0/8",
                "100.64.0.0/10",
                "127.0.0.0/8",
                "169.254.0.0/16",
                "172.16.0.0/12",
                "192.0.0.0/24",
                "192.0.2.0/24",
                "192.168.0.0/16",
                "198.18.0.0/15",
                "198.51.100.0/24",
                "203.0.113.0/24",
                "::1/128",
                "fc00::/7",
                "fe80::/10"
              ],
              "outboundTag": "direct"
            }
          ]
        }
      }
    }