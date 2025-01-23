# jan/23/2025 02:52:34 by RouterOS 6.49.17
# software id = LKC4-15KU
#
# model = 951Ui-2HnD
# serial number = DE3B0D1FB6B8
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no mode=ap-bridge \
    ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=tjkt.net hotspot-address=10.24.24.1 login-by=http-chap,http-pap \
    name=hsprof1 use-radius=yes
/ip hotspot user profile
add name=3K rate-limit=4M/4M
/ip pool
add name=hs-pool-6 ranges=10.24.24.2-10.24.24.254
add name=dhcp_pool1 ranges=192.168.30.2-192.168.30.254
add name=pool-pppoe ranges=192.168.100.2-192.168.100.254
/ip dhcp-server
add address-pool=hs-pool-6 disabled=no interface=wlan1 lease-time=1h name=\
    dhcp1
add address-pool=dhcp_pool1 disabled=no interface=ether2 name=dhcp2
/ip hotspot
add address-pool=hs-pool-6 disabled=no interface=wlan1 name=hotspot1 profile=\
    hsprof1
/ppp profile
add local-address=192.168.100.1 name=100K rate-limit=5M/5M remote-address=\
    pool-pppoe
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/tool user-manager profile
add name=3k name-for-users="" override-shared-users=off owner=admin price=\
    3000 starts-at=logon validity=0s
add name=100K name-for-users="" override-shared-users=off owner=admin price=0 \
    starts-at=logon validity=0s
/tool user-manager profile limitation
add address-list="" download-limit=0B group-name=3K ip-pool="" ip-pool6="" \
    name=3 owner=admin transfer-limit=0B upload-limit=0B uptime-limit=1d
add address-list="" download-limit=0B group-name=100K ip-pool="" ip-pool6="" \
    name=100K owner=admin transfer-limit=0B upload-limit=0B uptime-limit=0s
/interface pppoe-server server
add disabled=no interface=ether2 service-name=service1
/ip address
add address=10.24.24.1/24 interface=wlan1 network=10.24.24.0
add address=192.168.30.1/24 disabled=yes interface=ether2 network=\
    192.168.30.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=10.24.24.0/24 comment="hotspot network" gateway=10.24.24.1
add address=192.168.30.0/24 gateway=192.168.30.1
/ip dns
set allow-remote-requests=yes
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.24.24.0/24
/ip hotspot user
add name=admin
/ppp aaa
set use-radius=yes
/radius
add address=172.16.54.139 secret=123 service=ppp,hotspot
/radius incoming
set accept=yes
/tool user-manager database
set db-path=user-manager
/tool user-manager profile profile-limitation
add from-time=0s limitation=3 profile=3k till-time=23h59m59s weekdays=\
    sunday,monday,tuesday,wednesday,thursday,friday,saturday
add from-time=0s limitation=100K profile=100K till-time=23h59m59s weekdays=\
    sunday,monday,tuesday,wednesday,thursday,friday,saturday
/tool user-manager router
add coa-port=1700 customer=admin disabled=no ip-address=172.16.54.139 log=\
    auth-fail name=se shared-secret=123 use-coa=no
/tool user-manager user
add customer=admin disabled=no ipv6-dns=:: password=5pvf shared-users=1 \
    username=5pvf wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5ig5 shared-users=1 \
    username=5ig5 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=52sv shared-users=1 \
    username=52sv wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5eds shared-users=1 \
    username=5eds wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=5eq7 shared-users=1 \
    username=5eq7 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=COBA shared-users=1 \
    username=COBA wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2nhm shared-users=1 \
    username=2nhm wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2nyd shared-users=1 \
    username=2nyd wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2z55 shared-users=1 \
    username=2z55 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2gz8 shared-users=1 \
    username=2gz8 wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2srp shared-users=1 \
    username=2srp wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2biz shared-users=1 \
    username=2biz wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2yha shared-users=1 \
    username=2yha wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2p5x shared-users=1 \
    username=2p5x wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2pxz shared-users=1 \
    username=2pxz wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
add customer=admin disabled=no ipv6-dns=:: password=2d9p shared-users=1 \
    username=2d9p wireless-enc-algo=none wireless-enc-key="" wireless-psk=""
