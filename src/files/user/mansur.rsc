# jan/16/2025 04:32:01 by RouterOS 6.49.17
# software id = LKC4-15KU
#
# model = 951Ui-2HnD
# serial number = DE3B0D1FB6B8
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no mode=ap-bridge \
    ssid=hs1
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=tjkt.net hotspot-address=10.10.10.1 login-by=http-chap name=\
    hsprof1 use-radius=yes
/ip hotspot user profile
add name=Rp.3K rate-limit=4M/4M
add name=Rp.50K rate-limit=5M/5M
/ip pool
add name=dhcp_pool0 ranges=192.168.10.2-192.168.10.254
add name=hs-pool-6 ranges=10.10.10.2-10.10.10.254
add name=PPPoE-100K ranges=192.168.100.2-192.168.100.254
add name=PPPoE-150K ranges=192.168.150.2-192.168.150.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=ether2 name=dhcp1
add address-pool=hs-pool-6 disabled=no interface=wlan1 lease-time=1h name=\
    dhcp2
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=wlan1 name=hotspot1 profile=\
    hsprof1
/ppp profile
add local-address=192.168.100.1 name=Paket-100K remote-address=PPPoE-100K
add local-address=192.168.150.1 name=Paket-150K remote-address=PPPoE-150K
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/tool user-manager profile
add name=Rp.3K name-for-users="" override-shared-users=off owner=admin price=\
    3000 starts-at=logon validity=0s
add name=Rp.50K name-for-users="" override-shared-users=off owner=admin \
    price=50000 starts-at=logon validity=0s
add name=Paket-100K name-for-users="" override-shared-users=off owner=admin \
    price=0 starts-at=logon validity=0s
add name=Paket-150K name-for-users="" override-shared-users=off owner=admin \
    price=0 starts-at=logon validity=0s
/tool user-manager profile limitation
add address-list="" download-limit=0B group-name=Rp.3K ip-pool="" ip-pool6="" \
    name=Rp.3K owner=admin transfer-limit=0B upload-limit=0B uptime-limit=1d
add address-list="" download-limit=0B group-name=Rp.50K ip-pool="" ip-pool6=\
    "" name=Rp.50K owner=admin transfer-limit=0B upload-limit=0B \
    uptime-limit=4w2d
add address-list="" download-limit=0B group-name=Paket-100K ip-pool="" \
    ip-pool6="" name=Paket-100K owner=admin transfer-limit=0B upload-limit=0B \
    uptime-limit=0s
add address-list="" download-limit=0B group-name=Paket-150K ip-pool="" \
    ip-pool6="" name=Paket-150K owner=admin transfer-limit=0B upload-limit=0B \
    uptime-limit=0s
/interface pppoe-server server
add disabled=no interface=ether3 service-name=PPPoE
/ip address
add address=192.168.10.1/24 interface=ether2 network=192.168.10.0
add address=10.10.10.1/24 interface=wlan1 network=10.10.10.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=10.10.10.0/24 comment="hotspot network" gateway=10.10.10.1
add address=192.168.10.0/24 gateway=192.168.10.1
/ip dns
set allow-remote-requests=yes
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.10.10.0/24
add action=masquerade chain=srcnat out-interface=ether1
/ip hotspot user
add name=admin
/ppp aaa
set use-radius=yes
/radius
add address=172.16.54.48 secret=123 service=ppp,hotspot
/radius incoming
set accept=yes
/tool user-manager database
set db-path=user-manager
/tool user-manager profile profile-limitation
add from-time=0s limitation=Rp.3K profile=Rp.3K till-time=23h59m59s weekdays=\
    sunday,monday,tuesday,wednesday,thursday,friday,saturday
add from-time=0s limitation=Rp.50K profile=Rp.50K till-time=23h59m59s \
    weekdays=sunday,monday,tuesday,wednesday,thursday,friday,saturday
add from-time=0s limitation=Paket-100K profile=Paket-100K till-time=23h59m59s \
    weekdays=sunday,monday,tuesday,wednesday,thursday,friday,saturday
add from-time=0s limitation=Paket-150K profile=Paket-150K till-time=23h59m59s \
    weekdays=sunday,monday,tuesday,wednesday,thursday,friday,saturday
/tool user-manager router
add coa-port=1700 customer=admin disabled=no ip-address=172.16.54.48 log=\
    auth-fail name=server shared-secret=123 use-coa=no
/tool user-manager user
add customer=admin disabled=no ipv6-dns=:: password=2mq6 shared-users=1 \
    username=2mq6 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2xgz shared-users=1 \
    username=2xgz wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5tsf shared-users=1 \
    username=5tsf wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5wd8 shared-users=1 \
    username=5wd8 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5hka shared-users=1 \
    username=5hka wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
