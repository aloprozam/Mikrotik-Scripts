/ip firewall filter
add action=accept chain=input comment="Enstablished\\related" \
    connection-state=established,related in-interface-list=WAN
add action=accept chain=forward connection-state=established,related \
    in-interface-list=WAN
add action=accept chain=forward comment=DST-nat connection-nat-state=dstnat \
    connection-state=new in-interface-list=WAN
add action=reject chain=forward comment=Block-adult dst-address-list=\
    block-adult out-interface-list=WAN protocol=tcp reject-with=tcp-reset
add action=accept chain=input comment=RemoteAccess dst-port=22,8291 \
    in-interface-list=WAN protocol=tcp src-address-list=support
add action=accept chain=input comment=AcceptExternalICMP connection-rate=\
    0-128k in-interface-list=WAN packet-size=0-128 protocol=icmp
add action=drop chain=input comment=Invalid connection-state=invalid \
    in-interface-list=WAN log-prefix=InvalidInput
add action=drop chain=input comment=OtherExternalTrafficDrop \
    in-interface-list=WAN log-prefix=OtherExternal
add action=drop chain=forward in-interface-list=WAN
/interface list
add name=WAN
add name=LAN
add comment="Untrusted InterVLAN traffic" name=UntrustedVLANs
add comment="Trusted networks" name=Trusted
/ip firewall nat
add action=masquerade chain=srcnat comment="Hairpin NAT" connection-mark=\
    "Hairpin NAT" disabled=yes
add action=masquerade chain=srcnat out-interface-list=WAN