ipconfig /flushdns
ipconfig /registerdns
nbtstat -R
nbtstat -RR
arp -d *
netsh http flush logbuffer
exit