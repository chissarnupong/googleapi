# jan/06/1980 10:33:19 by RouterOS 6.43.1
# software id = D7RG-H8FB
#
# model = RB912R-2nD
# serial number = 8F00092FF0BC
/interface lte
set [ find ] mac-address=AC:FF:FF:00:00:00 name=lte1
/interface bridge
add admin-mac=B8:69:F4:08:F9:41 auto-mac=no comment=defconf name=bridge
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa2-psk eap-methods="" management-protection=\
    allowed mode=dynamic-keys name=profile1 supplicant-identity="" \
    wpa2-pre-shared-key=0823506275
add authentication-types=wpa2-psk eap-methods="" management-protection=\
    allowed mode=dynamic-keys name=profile2 supplicant-identity="" \
    wpa2-pre-shared-key=0288921386252
add authentication-types=wpa2-psk eap-methods="" management-protection=\
    allowed mode=dynamic-keys name=profile3 supplicant-identity="" \
    wpa2-pre-shared-key=0288921386251
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no distance=indoors \
    frequency=2462 security-profile=profile3 ssid=EGCO_WiFi_MDP \
    wireless-protocol=802.11 wps-mode=disabled
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
/port
set 1 name=usb2
/interface ppp-client
add apn=internet name=ppp-out1 port=usb2
/interface bridge port
add bridge=bridge comment=defconf interface=ether1
add bridge=bridge comment=defconf disabled=yes interface=wlan1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
add interface=lte1 list=WAN
/interface wireless sniffer
set file-limit=100 file-name=test_102206 memory-limit=1024 multiple-channels=\
    yes only-headers=yes
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=\
    192.168.88.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=wlan1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none
/system clock
set time-zone-name=Asia/Bangkok
/system console
set [ find ] disabled=yes
/system gps
set port=serial0
/system logging
add topics=script
/system ntp client
set enabled=yes server-dns-names=clock.nectec.or.th
/system routerboard settings
# Firmware upgraded successfully, please reboot for changes to take effect!
set auto-upgrade=yes silent-boot=no
/system scheduler
add disabled=yes interval=1s name=GPS on-event=GPS policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add disabled=yes interval=10s name=Sniffer on-event=Sniffer policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add disabled=yes interval=10s name=Push on-event=Push policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script
add name=Sniffer owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \r\
    \n:loc time [/sys clock get time];:glo Fname (\"test\".\"_\".[:pick [\$tim\
    e] 0 2].[:pick [\$time] 3 5].[:pick [\$time] 6 8]);\r\
    \n:put \$Fname;\r\
    \n/interface wireless sniffer set multiple-channels=yes file-n=\"\$Fname\"\
    \_receive-errors=no only-headers=yes memory-limit=1024;\r\
    \n:delay 1;\r\
    \n/int wi sniffer sniff wlan1 duration=1 interval=00:00:05;\r\
    \n\r\
    \ndelay 2;\r\
    \n/tool fetch upload=yes src-path=\$Fname dst-path=\$Fname mode=ftp user=a\
    dmin password=\"123456\" address=192.168.1.94 keep=no;\r\
    \ndelay 2;\r\
    \n/file rem \$Fname;\r\
    \n:log info (\"file rem\")\r\
    \n }"
add name=Push owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    :loc Fcount [/file find name~\"test\"];if (:len [\$Fcount])\r\
    \n{:loc Nfile;\r\
    \n:loc Fcount [/file print cou where name~\"test\"];\r\
    \n\r\
    \nif (\$Fcount!=0) do={\r\
    \n:put \$Fcount;\r\
    \nfor i from=1 to=(\$Fcount) do={:set \$Nfile [/file get \$i name];\r\
    \n/tool fetch upload=yes src-path=\$Nfile dst-path=\$Nfile mode=ftp user=a\
    dmin password=\"123456\" address=192.168.1.94 keep-result=no\r\
    \n:put \$Nfile;\r\
    \n}\r\
    \n:delay 1;\r\
    \n#fore i in=\$Fcount do={/file rem \$i}\r\
    \n} }\r\
    \n"
add name=GPS owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    glo Gps;:global la;:glo lo;/sys gps monitor once do={:set la \$(\"latitude\
    \");:set \$lo \$(\"longitude\")}\r\
    \nif ((\$la!=\"none\")||(\$lo!=\"none\")) do{:set Gps true;/tool fet;} els\
    e={:set Gps false;}"

