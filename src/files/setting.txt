# apr/10/2025 14:03:57 by RouterOS 6.49.17
# software id = LKC4-15KU
#
# model = 951Ui-2HnD
# serial number = DE3B0D1FB6B8
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no mode=ap-bridge \
    ssid=UKK_32
/interface vlan
add interface=ether2 name=vlan-10 vlan-id=10
add interface=ether2 name=vlan-20 vlan-id=20
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=portalsmk.sch.id hotspot-address=192.168.40.1 name=hsprof1
/ip hotspot user profile
add name=kepalasekolah rate-limit=512k
add name=Guru rate-limit=256k
add name=siswa rate-limit=128k
/ip pool
add name=dhcp_pool0 ranges=192.168.10.10-192.168.10.50
add name=dhcp_pool1 ranges=192.168.20.10-192.168.20.50
add name=hs-pool-1 ranges=192.168.40.10-192.168.40.50
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=vlan-10 name=dhcp1
add address-pool=dhcp_pool1 disabled=no interface=vlan-20 name=dhcp2
add address-pool=hs-pool-1 disabled=no interface=wlan1 lease-time=1h name=\
    dhcp3
/ip hotspot
add address-pool=hs-pool-1 disabled=no interface=wlan1 name=hotspot1 profile=\
    hsprof1
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/ip address
add address=192.168.10.1/24 interface=vlan-10 network=192.168.10.0
add address=192.168.20.1/24 interface=vlan-20 network=192.168.20.0
add address=192.168.30.1/24 interface=ether3 network=192.168.30.0
add address=192.168.40.1/24 interface=wlan1 network=192.168.40.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 domain=VLAN-10-Siswa gateway=192.168.10.1
add address=192.168.20.0/24 domain=VLAN-20-Guru gateway=192.168.20.1
add address=192.168.40.0/24 comment="hotspot network" gateway=192.168.40.1
/ip dns
set allow-remote-requests=yes
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.40.0/24
/ip hotspot user
add name=adminsmk
add name=kepalasekolah password=123 profile=kepalasekolah
add name=guru password=456 profile=Guru
add name=siswa password=789 profile=siswa
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=UKK_SMK
/tool user-manager database
set db-path=user-manager
