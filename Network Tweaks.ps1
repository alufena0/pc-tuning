netsh advfirewall set allprofiles state on # off/on
Get-NetFirewallRule -Group '*-32752*' | Where-Object 'Profile' -Match 'Domain' | Set-NetFirewallRule -Enabled 'False'
Get-NetFirewallRule -Group '*-32752*' | Where-Object 'Profile' -Match 'Private' | Set-NetFirewallRule -Enabled 'False'
Get-NetFirewallRule -Group '*-32752*' | Where-Object 'Profile' -Match 'Public' | Set-NetFirewallRule -Enabled 'False'
Set-NetFirewallRule -Group '*-32752*' -Enabled 'False'
netsh advfirewall firewall add rule name="Block Copilot Telemetry & Update" dir=out action=block remoteip=20.236.156.0/25,20.236.157.0/25,20.236.158.0/25,52.114.132.0/22 enable=yes
netsh advfirewall firewall add rule name="Block 40.76.0.0/14" dir=out action=block remoteip=40.76.0.0/14 enable=yes
netsh advfirewall firewall add rule name="Block 40.96.0.0/12" dir=out action=block remoteip=40.96.0.0/12 enable=yes
netsh advfirewall firewall add rule name="Block 40.124.0.0/16" dir=out action=block remoteip=40.124.0.0/16 enable=yes
#netsh advfirewall firewall add rule name="Block 40.112.0.0/13" dir=out action=block remoteip=40.112.0.0/13 enable=yes
netsh advfirewall firewall add rule name="Block 40.125.0.0/17" dir=out action=block remoteip=40.125.0.0/17 enable=yes
#netsh advfirewall firewall add rule name="Block 40.74.0.0/15" dir=out action=block remoteip=40.74.0.0/15 enable=yes
netsh advfirewall firewall add rule name="Block 40.80.0.0/12" dir=out action=block remoteip=40.80.0.0/12 enable=yes
netsh advfirewall firewall add rule name="Block 40.120.0.0/14" dir=out action=block remoteip=40.120.0.0/14 enable=yes
netsh advfirewall firewall add rule name="Block 137.116.0.0/16" dir=out action=block remoteip=137.116.0.0/16 enable=yes
#netsh advfirewall firewall add rule name="Block 23.192.0.0/11" dir=out action=block remoteip=23.192.0.0/11
#netsh advfirewall firewall add rule name="Block 23.32.0.0/11" dir=out action=block remoteip=23.32.0.0/11
#netsh advfirewall firewall add rule name="Block 23.64.0.0/14" dir=out action=block remoteip=23.64.0.0/14
netsh advfirewall firewall add rule name="Block 134.170.0.0/16" dir=out action=block remoteip=134.170.0.0/16 enable=yes
#netsh advfirewall firewall add rule name="Block 23.0.0.0/8" dir=out action=block remoteip=23.0.0.0/8 enable=yes
#netsh advfirewall firewall add rule name="Block 40.0.0.0/8" dir=out action=block remoteip=40.0.0.0/8 enable=yes
#netsh advfirewall firewall add rule name="Block 52.0.0.0/8" dir=out action=block remoteip=52.0.0.0/8 enable=yes
#netsh advfirewall firewall add rule name="Block 65.0.0.0/8" dir=out action=block remoteip=65.0.0.0/8 enable=yes
netsh advfirewall firewall add rule name="Block 131.107.0.0/16" dir=out action=block remoteip=131.107.0.0/16 enable=yes
#netsh advfirewall firewall add rule name="Block 157.54.0.0/15" dir=out action=block remoteip=157.54.0.0/15 enable=yes
netsh advfirewall firewall add rule name="Block 207.46.0.0/16" dir=out action=block remoteip=207.46.0.0/16 enable=yes
netsh advfirewall firewall add rule name="Block 207.68.0.0/16" dir=out action=block remoteip=207.68.0.0/16 enable=yes
#netsh advfirewall firewall add rule name="TCP Block" dir=out action=block protocol=TCP remoteport=1-42,44-79,81-442,444-586,588-852,854-992,994-1024,1025-3073,3075-5227,5229-27014,27051-65535
netsh advfirewall firewall add rule name="TCP Block A" dir=out action=block protocol=TCP remoteport="1-52,54-79,81-442,444-586,588-852,854-992,994-1024,1025-1118,1121-1934,4001-4999,5021-5221" enable=yes
netsh advfirewall firewall add rule name="TCP Block B" dir=out action=block protocol=TCP remoteport="5224-5227,5229-6111,6121-6462,25301-26099,26101-27013,28000-28889,45001-49151" enable=yes
#netsh advfirewall firewall add rule name="UDP Block" dir=out action=block protocol=UDP remoteport=1-52,54-122,124-442,444-1024 enable=yes
netsh advfirewall firewall add rule name="UDP Block (except DHCP + ControlD)" dir=out action=block protocol=UDP remoteport=1-52,54-66,69-122,124-442,444-1024 enable=yes
netsh advfirewall firewall add rule name="Allow DHCP Client (67-68)" dir=out action=allow protocol=UDP remoteport=67,68 enable=yes
netsh advfirewall firewall add rule name="Allow ControlD UDP 53" dir=out action=allow protocol=UDP remoteport=53 remoteip=76.76.2.0/24,76.76.10.0/24 enable=yes
netsh advfirewall firewall add rule name="Allow ControlD TCP 53" dir=out action=allow protocol=TCP remoteport=53 remoteip=76.76.2.0/24,76.76.10.0/24 enable=yes
netsh advfirewall firewall add rule name="Allow ControlD DoT TCP 853" dir=out action=allow protocol=TCP remoteport=853 remoteip=76.76.2.0/24,76.76.10.0/24 enable=yes
netsh advfirewall firewall add rule name="Allow ControlD DoH TCP 443" dir=out action=allow protocol=TCP remoteport=443 remoteip=76.76.2.0/24,76.76.10.0/24 enable=yes
netsh advfirewall firewall add rule name="Chrome TCP Block" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%ProgramFiles%\Google\Chrome\Application\chrome.exe" enable=yes
netsh advfirewall firewall add rule name="Chrome TCP Block (x86)" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" enable=yes
netsh advfirewall firewall add rule name="Chrome UDP Block" dir=out action=block protocol=UDP remoteport=1-442,444-65535 program="%ProgramFiles%\Google\Chrome\Application\chrome.exe" enable=yes
netsh advfirewall firewall add rule name="Firefox TCP Block" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%ProgramFiles%\Mozilla Firefox\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="Firefox UDP Block" dir=out action=block protocol=UDP remoteport=1-442,444-65535 program="%ProgramFiles%\Mozilla Firefox\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="Edge TCP Block" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" enable=yes
netsh advfirewall firewall add rule name="Edge UDP Block" dir=out action=block protocol=UDP remoteport=1-442,444-65535 program="%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" enable=yes
netsh advfirewall firewall add rule name="Brave TCP Block" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%LocalAppData%\BraveSoftware\Brave-Browser\Application\brave.exe" enable=yes
netsh advfirewall firewall add rule name="Brave UDP Block" dir=out action=block protocol=UDP remoteport=1-442,444-65535 program="%LocalAppData%\BraveSoftware\Brave-Browser\Application\brave.exe" enable=yes
netsh advfirewall firewall add rule name="SmartScreen Block" dir=out action=block program="%WinDir%\System32\smartscreen.exe" enable=yes
netsh advfirewall firewall add rule name="Start Block" dir=out action=block program="%WINDIR%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" enable=yes
netsh advfirewall firewall add rule name="Search Block" dir=out action=block program="%WINDIR%\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" enable=yes
netsh advfirewall firewall add rule name="OneDrive TCP Block" dir=out action=block protocol=TCP remoteport=1-442,444-65535 program="%ProgramFiles%\Microsoft OneDrive\OneDrive.exe" enable=yes
netsh advfirewall firewall add rule name="DNS UDP Block except ControlD" dir=out action=block protocol=UDP remoteport=53 remoteip=0.0.0.0-76.76.1.255,76.76.3.0-76.76.9.255,76.76.11.0-255.255.255.255 enable=yes
netsh advfirewall firewall add rule name="TCP DoT Block except ControlD" dir=out action=block protocol=TCP remoteport=853 remoteip=0.0.0.0-76.76.1.255,76.76.3.0-76.76.9.255,76.76.11.0-255.255.255.255 enable=yes
netsh advfirewall set allprofiles logging droppedconnections disable
netsh advfirewall set allprofiles logging allowedconnections disable
netsh dnsclient set global doh=no dot=no ddr=no
netsh advfirewall firewall set rule group="Network Discovery" new enable=No
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=no
netsh int 6to4 set state disabled
netsh int 6to4 set state disable
netsh int ipv6 6to4 set state disabled undoonstop=disabled
netsh int ipv6 6to4 set state disable undoonstop=disabled
netsh int ipv6 isatap set state disabled
netsh int ipv6 isatap set state disable
# netsh int ip set dynamicport udp start=60000 num=5000
netsh int ip set dynamicport udp start=32769 num=32766
netsh int ip set dynamicport tcp start=32769 num=32766
netsh int ip set global loopbackexecutionmode=inline
netsh int ip set global loopbacklargemtu=disabled # disabled/enabled
netsh int ip set global loopbacklargemtu=disable
netsh int ip set global loopbackworkercount=2 # 2/4/16
netsh int ip set global neighborcachelimit=4096
netsh int ip set global reassemblylimit=267748640 # 65535/267748640
netsh int ip set global reassemblyoutoforderlimit=1300 # 128/1300
netsh int ip set global routecachelimit=4096
netsh int ip set global sourcebasedecmp=enabled
netsh int ip set global sourcebasedecmp=enable
netsh int ip set global sourceroutingbehavior=drop
netsh int ip set global taskoffload=disabled # rss disabled/enabled
netsh int ip set global taskoffload=disable
netsh int ip set interface ethernet currenthoplimit=64 # 0/40/64/128
netsh int ipv4 set glob defaultcurhoplimit=64
netsh int ipv6 set glob defaultcurhoplimit=64
netsh int isatap set state disabled
netsh int isatap set state disable
netsh int tcp set global autotuninglevel=normal # disabled/normal
#netsh int tcp set global autotuninglevel=disable
netsh int tcp set global chimney=disabled
netsh int tcp set global chimney=disable
netsh int tcp set global congestionprovider=cubic # cubic w10/default/ctcp/dctcp/bbr2 w11
netsh int tcp set global dca=disabled # disabled/enabled
netsh int tcp set global dca=disable
netsh int tcp set global ecncapability=disabled # disabled/enabled
netsh int tcp set global ecncapability=disable
netsh int tcp set global fastopen=enabled # disabled/enabled
netsh int tcp set global fastopen=enable
netsh int tcp set global fastopenfallback=enabled # disabled/enabled
netsh int tcp set global fastopenfallback=enable
netsh int tcp set global hystart=disabled # disabled/enabled
netsh int tcp set global hystart=disable
netsh int tcp set global initialRto=300 # 300/2000/3000
netsh int tcp set global maxsynretransmissions=4 # 2/3/4
netsh int tcp set global netdma=enabled
netsh int tcp set global netdma=enable
netsh int tcp set global nonsackrttresiliency=disabled # disabled/enabled
netsh int tcp set global nonsackrttresiliency=disable
netsh int tcp set global pacingprofile=off # off/slowstart/always
netsh int tcp set global prr=enabled # disabled/enabled
netsh int tcp set global prr=enable
netsh int tcp set global rsc=disabled # disabled/enabled
netsh int tcp set global rsc=disable
netsh int tcp set global rss=disabled # disabled/enabled
netsh int tcp set global rss=disable
netsh int tcp set global timestamps=allowed # disabled/enabled/allowed
#netsh int tcp set global timestamps=enable
#netsh int tcp set heuristics wsh=disabled forcews=disabled # forcews disabled/enabled
netsh int tcp set heuristics disabled
netsh int tcp set heuristics disable
netsh int tcp set security mpp=disabled
netsh int tcp set security mpp=disable
netsh int tcp set security profiles=disabled
netsh int tcp set security profiles=disable
netsh int tcp set supplemental internet congestionprovider=cubic # cubic w10/newreno/ctcp/dctcp/bbr2 w11
netsh int tcp set supplemental internet enablecwndrestart=enabled # disabled/enabled
netsh int tcp set supplemental internet enablecwndrestart=enable
netsh int tcp set supplemental template=custom icw=10 # 2/10
netsh int teredo set state disabled
netsh int teredo set state disable
netsh int udp set global uro=disabled
netsh int udp set global uro=disable
netsh int udp set global uso=disabled
netsh int udp set global uso=disable
netsh winsock set autotuning on # off/on
#netsh int ipv6 set gl loopbacklargemtu=disabled
#netsh int ipv4 set gl loopbacklargemtu=disabled

netsh interface tcp set supplemental template=automatic congestionprovider=cubic
netsh interface tcp set supplemental template=automatic delayedackfrequency=1 # 1/2
netsh interface tcp set supplemental template=automatic delayedacktimeout=40 # 1/10/40
netsh interface tcp set supplemental template=automatic enablecwndrestart=enabled
netsh interface tcp set supplemental template=automatic icw=10
netsh interface tcp set supplemental template=automatic minrto=300 # 300/2000
netsh interface tcp set supplemental template=automatic rack=enabled
netsh interface tcp set supplemental template=automatic taillossprobe=enabled

netsh interface tcp set supplemental template=datacenter congestionprovider=cubic
netsh interface tcp set supplemental template=datacenter delayedackfrequency=1
netsh interface tcp set supplemental template=datacenter delayedacktimeout=40
netsh interface tcp set supplemental template=datacenter enablecwndrestart=enabled
netsh interface tcp set supplemental template=datacenter icw=10
netsh interface tcp set supplemental template=datacenter minrto=300
netsh interface tcp set supplemental template=datacenter rack=enabled
netsh interface tcp set supplemental template=datacenter taillossprobe=enabled

netsh interface tcp set supplemental template=internet congestionprovider=cubic
netsh interface tcp set supplemental template=internet delayedackfrequency=1
netsh interface tcp set supplemental template=internet delayedacktimeout=40
netsh interface tcp set supplemental template=internet enablecwndrestart=enabled
netsh interface tcp set supplemental template=internet icw=10
netsh interface tcp set supplemental template=internet minrto=300
netsh interface tcp set supplemental template=internet rack=enabled
netsh interface tcp set supplemental template=internet taillossprobe=enabled

netsh interface tcp set supplemental template=compat congestionprovider=cubic
netsh interface tcp set supplemental template=compat delayedackfrequency=1
netsh interface tcp set supplemental template=compat delayedacktimeout=40
netsh interface tcp set supplemental template=compat enablecwndrestart=enabled
netsh interface tcp set supplemental template=compat icw=10
netsh interface tcp set supplemental template=compat minrto=300
netsh interface tcp set supplemental template=compat rack=enabled
netsh interface tcp set supplemental template=compat taillossprobe=enabled

netsh interface tcp set supplemental template=custom congestionprovider=cubic
netsh interface tcp set supplemental template=custom delayedackfrequency=1
netsh interface tcp set supplemental template=custom delayedacktimeout=40
netsh interface tcp set supplemental template=custom enablecwndrestart=enabled
netsh interface tcp set supplemental template=custom icw=10
netsh interface tcp set supplemental template=custom minrto=300
netsh interface tcp set supplemental template=custom rack=enabled
netsh interface tcp set supplemental template=custom taillossprobe=enabled

netsh int tcp set supplemental template=internetcustom congestionprovider=cubic # cubic w10/bbr2 w11/BBR/ctcp/dctcp/NewReno

netsh interface ipv4 set subinterface Ethernet mtu=1500 store=persistent

Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_implat'
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_lldp'
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_lltdio'
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_msclient' # If you share files on the network, DO NOT disable the client
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_pacer' # Disable/Enable QoS
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_rspndr'
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_server'
Disable-NetAdapterBinding -Name "*" -ComponentId 'ms_tcpip6'
Disable-NetAdapterBinding -Name "*" -ComponentId 'vmware_bridge'
Disable-NetAdapterBinding -Name "*" -DisplayName 'Client for Microsoft Networks'
Disable-NetAdapterBinding -Name "*" -DisplayName 'File and Printer Sharing for Microsoft Networks'
Disable-NetAdapterBinding -Name "*" -DisplayName 'Link-Layer Topology Discovery Mapper I/O Driver'
Disable-NetAdapterBinding -Name "*" -DisplayName 'Link-Layer Topology Discovery Responder'
Disable-NetAdapterBinding -Name "*" -DisplayName 'Microsoft LLDP Protocol Driver'
Disable-NetAdapterBinding -Name "*" -DisplayName 'Microsoft Network Adapter Multiplexor Protocol'
Disable-NetAdapterIPsecOffload -Name '*' # Disable/Enable
Disable-NetAdapterLso -Name "*"
Disable-NetAdapterPowerManagement -Name "*"
Disable-NetAdapterQos -Name "*" # Disable/Enable
Disable-NetAdapterRdma -Name '*'
Disable-NetAdapterRsc -Name "*" # Disable/Enable
Disable-NetAdapterSriov -Name '*' # Disable/Enable
Disable-NetAdapterUso -Name '*'
Disable-NetAdapterVmq -Name '*' # Disable/Enable
Disable-NetAdapterChecksumOffload -Name "*" # rss Disable/Enable
Disable-NetAdapterEncapsulatedPacketTaskOffload -Name "*" # Disable/Enable
Disable-NetAdapterRss -Name "*" # Disable/Enable
Set-NetAdapterDataPathConfiguration -Name '*' -IncludeHidden -Profile Dispatch # Dispatch/Passive
Set-NetAdapterIPsecOffload -Name "*" -Enabled $False # False/True
#Set-NetAdapterRdma -Name "*" -Enabled $True
#Set-NetAdapterRss -Name "*" -BaseProcessorGroup 0 -BaseProcessorNumber 2 -MaxProcessorGroup 0 -MaxProcessorNumber 2 -MaxProcessors 1 -NumberOfReceiveQueues 1 -Profile NUMAStatic -Enabled $true
Set-NetOffloadGlobalSetting -Chimney Disabled
Set-NetOffloadGlobalSetting -NetworkDirectAcrossIPSubnets Allowed # Blocked/Allowed
Set-NetOffloadGlobalSetting -NetworkDirect Enabled # Disabled/Enabled
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled # Disabled/Enabled
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled # Disabled/Enabled
Set-NetOffloadGlobalSetting -ReceiveSideScaling Disabled # rss Disabled/Enabled
Set-NetOffloadGlobalSetting -Taskoffload Disabled # rss Disabled/Enabled
Set-NetTCPSetting -SettingName "*" -AutoTuningLevelLocal Normal # Disabled/Normal
Set-NetTCPSetting -SettingName internet -MinRto 300 # 20/300/2000
Set-NetTCPSetting -SettingName "*" -ScalingHeuristics Disabled
Set-NetUDPSetting -DynamicPortRangeNumberOfPorts 32766 # 5000/32766
Set-NetUDPSetting -DynamicPortRangeStartPort 32769 # 32769/60000
Set-NetTCPSetting -SettingName InternetCustom -Timestamps Enabled # Disabled/Enabled

Set-NetIPv4Protocol -AddressMaskReply Disabled
Set-NetIPv4Protocol -DeadGatewayDetection Enabled
Set-NetIPv4Protocol -DefaultHopLimit 64 # 64/128
Set-NetIPv4Protocol -DhcpMediaSense Enabled # Disabled/Enabled
Set-NetIPv4Protocol -GroupForwardedFragments Disabled
Set-NetIPv4Protocol -IcmpRedirects Disabled
Set-NetIPv4Protocol -IGMPLevel All
Set-NetIPv4Protocol -IGMPVersion Version3
Set-NetIPv4Protocol -MediaSenseEventLog Disabled
Set-NetIPv4Protocol -MinimumMtu 1500
Set-NetIPv4Protocol -MulticastForwarding Disabled # Disabled/Enabled
Set-NetIPv4Protocol -NeighborCacheLimitEntries 256
Set-NetIPv4Protocol -RandomizeIdentifiers Enabled
Set-NetIPv4Protocol -ReassemblyLimitBytes 267748640
Set-NetIPv4Protocol -RouteCacheLimitEntries 256
Set-NetIPv4Protocol -SourceRoutingBehavior Drop

Set-NetIPv6Protocol -AddressMaskReply Disabled
Set-NetIPv6Protocol -DeadGatewayDetection Enabled
Set-NetIPv6Protocol -DefaultHopLimit 64
Set-NetIPv6Protocol -DhcpMediaSense Enabled
Set-NetIPv6Protocol -GroupForwardedFragments Disabled
Set-NetIPv6Protocol -IcmpRedirects Disabled
Set-NetIPv6Protocol -IGMPLevel All
Set-NetIPv6Protocol -IGMPVersion Version3
Set-NetIPv6Protocol -MediaSenseEventLog Disabled
Set-NetIPv6Protocol -MinimumMtu 1500
Set-NetIPv6Protocol -MulticastForwarding Disabled
Set-NetIPv6Protocol -NeighborCacheLimitEntries 256
Set-NetIPv6Protocol -RandomizeIdentifiers Enabled
Set-NetIPv6Protocol -ReassemblyLimitBytes 267748640
Set-NetIPv6Protocol -RouteCacheLimitEntries 256
Set-NetIPv6Protocol -SourceRoutingBehavior Drop

Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -AdvertiseDefaultRoute Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -AdvertisedRouterLifetime (New-TimeSpan -Seconds 450)
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -Advertising Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -BaseReachableTimeMs 15
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -ClampMss Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -CurrentHopLimit 64 # 0/64
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -DadRetransmitTimeMs 1000
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -DadTransmits 5
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -DirectedMacWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -EcnMarking AppDecide
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -ForceArpNdWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -Forwarding Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -IgnoreDefaultRoutes Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -InterfaceMetric 50 # 10/50
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -ManagedAddressConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -NeighborDiscoverySupported No # Disabled/No
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -NeighborUnreachabilityDetection Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -NlMtuBytes 1500
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -OtherStatefulConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -PolicyStore ActiveStore
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -ReachableTime 5000
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -RetransmitTimeMs 500
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -RouterDiscovery Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -WeakHostReceive Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 -WeakHostSend Disabled

Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -AdvertiseDefaultRoute Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -AdvertisedRouterLifetime (New-TimeSpan -Seconds 450)
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -Advertising Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -BaseReachableTimeMs 15
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -ClampMss Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -CurrentHopLimit 64 # 0/64
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -DadRetransmitTimeMs 1000
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -DadTransmits 5
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -DirectedMacWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -EcnMarking AppDecide
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -ForceArpNdWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -Forwarding Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -IgnoreDefaultRoutes Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -InterfaceMetric 50
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -ManagedAddressConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -NeighborDiscoverySupported No
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -NeighborUnreachabilityDetection Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -NlMtuBytes 1500
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -OtherStatefulConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -PolicyStore ActiveStore
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -ReachableTime 5000
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -RetransmitTimeMs 500
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -RouterDiscovery Enabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -WeakHostReceive Disabled
Set-NetIPInterface -InterfaceAlias 'Wi-Fi' -AddressFamily IPv6 -WeakHostSend Disabled

Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -AdvertiseDefaultRoute Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -AdvertisedRouterLifetime (New-TimeSpan -Seconds 450)
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -Advertising Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -BaseReachableTimeMs 15
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -ClampMss Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -CurrentHopLimit 64 # 0/64
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -DadRetransmitTimeMs 1000
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -DadTransmits 5
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -DirectedMacWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -EcnMarking AppDecide
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -ForceArpNdWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -Forwarding Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -IgnoreDefaultRoutes Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -InterfaceMetric 5 # 5/20
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -ManagedAddressConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -NeighborDiscoverySupported No
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -NeighborUnreachabilityDetection Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -NlMtuBytes 1500
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -OtherStatefulConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -PolicyStore ActiveStore
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -ReachableTime 5000
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -RetransmitTimeMs 500
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -RouterDiscovery Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -WeakHostReceive Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -WeakHostSend Disabled

Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -AdvertiseDefaultRoute Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -AdvertisedRouterLifetime (New-TimeSpan -Seconds 450)
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -Advertising Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -BaseReachableTimeMs 15
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -ClampMss Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -CurrentHopLimit 64 # 0/64
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -DadRetransmitTimeMs 1000
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -DadTransmits 5
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -DirectedMacWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -EcnMarking AppDecide
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -ForceArpNdWolPattern Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -Forwarding Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -IgnoreDefaultRoutes Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -InterfaceMetric 5
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -ManagedAddressConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -NeighborDiscoverySupported No
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -NeighborUnreachabilityDetection Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -NlMtuBytes 1500
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -OtherStatefulConfiguration Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -PolicyStore ActiveStore
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -ReachableTime 5000
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -RetransmitTimeMs 500
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -RouterDiscovery Enabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -WeakHostReceive Disabled
Set-NetIPInterface -InterfaceAlias 'Ethernet' -AddressFamily IPv6 -WeakHostSend Disabled

#Remove-NetQosPolicy -Name "bufferbloat_throttle" -PolicyStore ActiveStore -Confirm:$false -ErrorAction SilentlyContinue
#Remove-NetQosPolicy -Name "bufferbloat_priority" -PolicyStore ActiveStore -Confirm:$false -ErrorAction SilentlyContinue

#New-NetQosPolicy Bufferbloat_throttle -PolicyStore ActiveStore -NetworkProfile Private -IPProtocol TCP -Precedence 254 -DSCPAction 16 -MinBandwidthWeightAction 5
#New-NetQosPolicy Bufferbloat_priority -PolicyStore ActiveStore -NetworkProfile Private -Default -Precedence 252 -DSCPAction 32 -MinBandwidthWeightAction 90

#$qos  = "Remove-NetQosPolicy -PolicyStore ActiveStore -name * -Confirm:`$false -ea 0"
#$qos += ";New-NetQosPolicy Bufferbloat_throttle -PolicyStore ActiveStore -NetworkProfile Private -IPProtocol TCP -Precedence 254 -DSCPAction 16 -MinBandwidthWeightAction 5"
#$qos += ";New-NetQosPolicy Bufferbloat_priority -PolicyStore ActiveStore -NetworkProfile Private -Default -Precedence 252 -DSCPAction 32 -MinBandwidthWeightAction 90"

#Unregister-ScheduledTask -TaskName 'Bufferbloat' -Confirm:$false -ErrorAction SilentlyContinue
#$sa = New-ScheduledTaskAction -Execute powershell.exe -Argument "-nop -c `"$qos`""
#$st = New-ScheduledTaskTrigger -AtStartup
#Register-ScheduledTask -TaskName 'Bufferbloat' -Action $sa -Trigger $st -User 'NT AUTHORITY\SYSTEM' -Force | Out-Null
#Start-ScheduledTask -TaskName 'Bufferbloat'

#Clear-DnsClientCache
#Start-Process -FilePath "ipconfig.exe" -ArgumentList "/flushdns" -NoNewWindow -Wait
#Start-Process -FilePath "ipconfig.exe" -ArgumentList "/renew" -NoNewWindow -Wait

exit
