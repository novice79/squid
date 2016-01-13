# ubuntu
ubuntu14.04 with sshd softetherVPN

# start your vpn server like this
docker run -d -p 222:22 -p 500:500/udp -p 4500:4500/udp -p 1701:1701/tcp -p 443:443/tcp -p 992:992/tcp -p 5555:5555/tcp --name fg -t novice/ubuntu
ssh root user pass: *freego*

vpncmd localhost /SERVER /CSV /CMD IPsecEnable /L2TP:yes /L2TPRAW:yes /ETHERIP:no /PSK:freego2016 /DEFAULTHUB:DEFAULT
vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserCreate freego /GROUP:none /REALNAME:none /NOTE:none
vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserPasswordSet freego /PASSWORD:freego2016
# for DHCP
vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD SecureNatEnable
vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD SstpEnable yes
ServerCertSet /LOADCERT:/ww.crt /LOADKEY:/ww.key
ServerCertSet /LOADCERT:/root/fullchain.pem /LOADKEY:/root/privkey.pem
# and test it:
$ssh root@$(docker-machine ip default) -p 222
root@192.168.99.100's password:**freego**
root@1d0f67e86996:~# 