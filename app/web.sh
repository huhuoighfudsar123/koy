echo '{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": '$PORT',
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$id'",
                        "flow": "xtls-rprx-direct"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 8880
                    },
                    {
                        "path": "/trojan",
                        "dest": 2052
                    },
                    {
                        "path": "/vmess",
                        "dest": 2095
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        },
        {
            "port": 8880,
            "listen": "0.0.0.0",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$id'"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        },
        {
            "port": 2052,
            "listen": "0.0.0.0",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "'$id'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/trojan"
                }
            }
        },
        {
            "port": 2095,
            "listen": "0.0.0.0",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "'$id'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/vmess"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}' > config.json

./web -config=config.json

ufw allow 2095/tcp
ufw allow 8080/tcp
ufw allow 8880/tcp
ufw allow 2052/tcp
