#requires -Version 5.1
<#
.SYNOPSIS
    USB Latency Analyzer V2 - Count chips between your device and CPU
.DESCRIPTION
    Shows USB topology from CPU's perspective.
    CHIP 0 = direct to CPU, CHIP 1 = through chipset, CHIP 2+ = through hubs
    More chips = more latency.

    Device database from Linux kernel xhci-pci.c + pci.ids repository.
#>

# =============================================================================
# FULL DEVICE ID DATABASE (from Linux kernel xhci-pci.c + pci.ids)
# =============================================================================

# Intel CPU-Integrated (CHIP 0 - LOWEST LATENCY)
$IntelCpuIntegrated = @{
    '8a13' = @{ Name = "Ice Lake Thunderbolt 3 USB Controller"; Platform = "Ice Lake (10th Gen)"; USB = "USB 3.2/TB3"; Year = "2019" }
    '9a13' = @{ Name = "Tiger Lake-LP Thunderbolt 4 USB Controller"; Platform = "Tiger Lake (11th Gen)"; USB = "USB4/TB4"; Year = "2020" }
    '9a17' = @{ Name = "Tiger Lake-H Thunderbolt 4 USB Controller"; Platform = "Tiger Lake-H (11th Gen)"; USB = "USB4/TB4"; Year = "2021" }
    '461e' = @{ Name = "Alder Lake-P Thunderbolt 4 USB Controller"; Platform = "Alder Lake (12th Gen)"; USB = "USB4/TB4"; Year = "2022" }
    '464e' = @{ Name = "Alder Lake-N Processor USB 3.2 xHCI Controller"; Platform = "Alder Lake-N"; USB = "USB 3.2"; Year = "2023" }
    'a71e' = @{ Name = "Raptor Lake-P Thunderbolt 4 USB Controller"; Platform = "Raptor Lake (13th Gen)"; USB = "USB4/TB4"; Year = "2023" }
    '7ec0' = @{ Name = "Meteor Lake-P Thunderbolt 4 USB Controller"; Platform = "Meteor Lake (Core Ultra)"; USB = "USB4/TB4"; Year = "2024" }
    'a831' = @{ Name = "Lunar Lake-M Thunderbolt 4 USB Controller"; Platform = "Lunar Lake"; USB = "USB4/TB4"; Year = "2024" }
}

# Intel PCH/Chipset (CHIP 1)
$IntelPch = @{
    '7f6e' = @{ Name = "800 Series PCH USB 3.1 xHCI HC"; Platform = "800 Series PCH"; USB = "USB 3.1"; Year = "2024" }
    '7a60' = @{ Name = "Raptor Lake USB 3.2 Gen 2x2 XHCI Host Controller"; Platform = "700 Series PCH"; USB = "USB 3.2 Gen 2x2 (20Gbps)"; Year = "2023" }
    '7a61' = @{ Name = "Raptor Lake USB 3.2 Gen 1x1 xDCI Device Controller"; Platform = "700 Series PCH"; USB = "USB 3.2 Gen 1"; Year = "2023" }
    '7ae0' = @{ Name = "Alder Lake-S PCH USB 3.2 Gen 2x2 XHCI Controller"; Platform = "600 Series PCH (Desktop)"; USB = "USB 3.2 Gen 2x2 (20Gbps)"; Year = "2021" }
    '51ed' = @{ Name = "Alder Lake PCH USB 3.2 xHCI Host Controller"; Platform = "600 Series PCH"; USB = "USB 3.2"; Year = "2022" }
    '54ed' = @{ Name = "Alder Lake-N PCH USB 3.2 Gen 2x1 xHCI Host Controller"; Platform = "Alder Lake-N PCH"; USB = "USB 3.2 Gen 2 (10Gbps)"; Year = "2023" }
    '7e7d' = @{ Name = "Meteor Lake-P USB 3.2 Gen 2x1 xHCI Host Controller"; Platform = "Meteor Lake PCH"; USB = "USB 3.2 Gen 2"; Year = "2024" }
    '777d' = @{ Name = "Arrow Lake USB 3.2 xHCI Controller"; Platform = "Arrow Lake"; USB = "USB 3.2"; Year = "2024" }
    'a87d' = @{ Name = "Lunar Lake-M USB 3.2 Gen 2x1 xHCI Host Controller"; Platform = "Lunar Lake PCH"; USB = "USB 3.2 Gen 2"; Year = "2024" }
    'a0ed' = @{ Name = "Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller"; Platform = "500 Series PCH"; USB = "USB 3.2 Gen 2 (10Gbps)"; Year = "2020" }
    '43ed' = @{ Name = "Tiger Lake-H USB 3.2 Gen 2x1 xHCI Host Controller"; Platform = "500 Series PCH-H"; USB = "USB 3.2 Gen 2"; Year = "2021" }
    'a3af' = @{ Name = "Comet Lake PCH-V USB Controller"; Platform = "400 Series PCH"; USB = "USB 3.1"; Year = "2020" }
    '02ed' = @{ Name = "Comet Lake PCH-LP USB 3.1 xHCI Host Controller"; Platform = "400 Series PCH-LP"; USB = "USB 3.1"; Year = "2020" }
    '06ed' = @{ Name = "Comet Lake USB 3.1 xHCI Host Controller"; Platform = "400 Series PCH"; USB = "USB 3.1"; Year = "2020" }
    'a36d' = @{ Name = "Cannon Lake PCH USB 3.1 xHCI Host Controller"; Platform = "300 Series PCH"; USB = "USB 3.1"; Year = "2018" }
    '9ded' = @{ Name = "Cannon Point-LP USB 3.1 xHCI Controller"; Platform = "300 Series PCH-LP"; USB = "USB 3.1"; Year = "2018" }
    'a2af' = @{ Name = "200 Series/Z370 Chipset Family USB 3.0 xHCI Controller"; Platform = "200 Series PCH"; USB = "USB 3.0"; Year = "2017" }
    'a12f' = @{ Name = "100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller"; Platform = "100 Series PCH"; USB = "USB 3.0"; Year = "2015" }
    '9d2f' = @{ Name = "Sunrise Point-LP USB 3.0 xHCI Controller"; Platform = "100 Series PCH-LP"; USB = "USB 3.0"; Year = "2015" }
    '8cb1' = @{ Name = "9 Series Chipset Family USB xHCI Controller"; Platform = "9 Series PCH"; USB = "USB 3.0"; Year = "2014" }
    '9cb1' = @{ Name = "Wildcat Point-LP USB xHCI Controller"; Platform = "9 Series PCH-LP"; USB = "USB 3.0"; Year = "2014" }
    '8c31' = @{ Name = "8 Series/C220 Series Chipset Family USB xHCI"; Platform = "8 Series PCH"; USB = "USB 3.0"; Year = "2013" }
    '9c31' = @{ Name = "8 Series USB xHCI HC"; Platform = "8 Series PCH-LP"; USB = "USB 3.0"; Year = "2013" }
    '1e31' = @{ Name = "7 Series/C210 Series Chipset Family USB xHCI Host Controller"; Platform = "7 Series PCH"; USB = "USB 3.0"; Year = "2012" }
    '8d31' = @{ Name = "C610/X99 series chipset USB xHCI Host Controller"; Platform = "X99/C610 (HEDT/Server)"; USB = "USB 3.0"; Year = "2014" }
    'a1af' = @{ Name = "C620 Series Chipset Family USB 3.0 xHCI Controller"; Platform = "C620 (Server)"; USB = "USB 3.0"; Year = "2017" }
}

# Intel Thunderbolt (CHIP 0 - CPU-attached)
$IntelThunderbolt = @{
    '5782' = @{ Name = "JHL9580 Thunderbolt 5 USB Controller"; Platform = "Barlow Ridge Host 80G"; USB = "USB4/TB5 (80Gbps)"; Year = "2024" }
    '5785' = @{ Name = "JHL9540 Thunderbolt 4 USB Controller"; Platform = "Barlow Ridge Host 40G"; USB = "USB4/TB4 (40Gbps)"; Year = "2024" }
    '5787' = @{ Name = "JHL9480 Thunderbolt 5 USB Controller"; Platform = "Barlow Ridge Hub 80G"; USB = "USB4/TB5 (80Gbps)"; Year = "2024" }
    '57a5' = @{ Name = "JHL9440 Thunderbolt 4 USB Controller"; Platform = "Barlow Ridge Hub 40G"; USB = "USB4/TB4 (40Gbps)"; Year = "2024" }
    '1138' = @{ Name = "Thunderbolt 4 USB Controller [Maple Ridge 4C]"; Platform = "Maple Ridge 4C"; USB = "USB4/TB4 (40Gbps)"; Year = "2020" }
    '1135' = @{ Name = "Thunderbolt 4 USB Controller [Maple Ridge 2C]"; Platform = "Maple Ridge 2C"; USB = "USB4/TB4 (40Gbps)"; Year = "2020" }
    '0b27' = @{ Name = "Thunderbolt 4 USB Controller [Goshen Ridge]"; Platform = "Goshen Ridge"; USB = "USB4/TB4 (40Gbps)"; Year = "2020" }
    '15e9' = @{ Name = "JHL7540 Thunderbolt 3 USB Controller [Titan Ridge 2C]"; Platform = "Titan Ridge 2C"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2018" }
    '15ec' = @{ Name = "JHL7540 Thunderbolt 3 USB Controller [Titan Ridge 4C]"; Platform = "Titan Ridge 4C"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2018" }
    '15f0' = @{ Name = "JHL7440 Thunderbolt 3 USB Controller [Titan Ridge DD]"; Platform = "Titan Ridge DD"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2018" }
    '15b5' = @{ Name = "DSL6340 USB 3.1 Controller [Alpine Ridge 2C]"; Platform = "Alpine Ridge 2C"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2015" }
    '15b6' = @{ Name = "DSL6540 USB 3.1 Controller [Alpine Ridge 4C]"; Platform = "Alpine Ridge 4C"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2015" }
    '15c1' = @{ Name = "JHL6240 Thunderbolt 3 USB 3.1 Controller [Alpine Ridge LP]"; Platform = "Alpine Ridge LP"; USB = "USB 3.1/TB3"; Year = "2016" }
    '15d4' = @{ Name = "JHL6540 Thunderbolt 3 USB Controller [Alpine Ridge 4C]"; Platform = "Alpine Ridge 4C C-step"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2016" }
    '15db' = @{ Name = "JHL6340 Thunderbolt 3 USB 3.1 Controller [Alpine Ridge 2C]"; Platform = "Alpine Ridge 2C C-step"; USB = "USB 3.1/TB3 (40Gbps)"; Year = "2016" }
}

# AMD CPU-Integrated (CHIP 0 - LOWEST LATENCY)
$AmdCpuIntegrated = @{
    # Raphael / Granite Ridge (Ryzen 7000/9000)
    '15b6' = @{ Name = "Raphael/Granite Ridge USB 3.1 xHCI"; Platform = "Ryzen 7000/9000 Desktop (AM5)"; USB = "USB 3.1"; Year = "2022" }
    '15b7' = @{ Name = "Raphael/Granite Ridge USB 3.1 xHCI"; Platform = "Ryzen 7000/9000 Desktop (AM5)"; USB = "USB 3.1"; Year = "2022" }
    '15b8' = @{ Name = "Raphael/Granite Ridge USB 2.0 xHCI"; Platform = "Ryzen 7000/9000 Desktop (AM5)"; USB = "USB 2.0"; Year = "2022" }
    # Strix Halo (Zen 5)
    '1587' = @{ Name = "Strix Halo USB 3.1 xHCI"; Platform = "Strix Halo (Zen 5)"; USB = "USB 3.1"; Year = "2024" }
    '1588' = @{ Name = "Strix Halo USB 3.1 xHCI"; Platform = "Strix Halo (Zen 5)"; USB = "USB 3.1"; Year = "2024" }
    '1589' = @{ Name = "Strix Halo USB 3.1 xHCI"; Platform = "Strix Halo (Zen 5)"; USB = "USB 3.1"; Year = "2024" }
    '158b' = @{ Name = "Strix Halo USB 3.1 xHCI"; Platform = "Strix Halo (Zen 5)"; USB = "USB 3.1"; Year = "2024" }
    '158d' = @{ Name = "Strix Halo USB4 Host Router"; Platform = "Strix Halo (Zen 5)"; USB = "USB4"; Year = "2024" }
    '158e' = @{ Name = "Strix Halo USB4 Host Router"; Platform = "Strix Halo (Zen 5)"; USB = "USB4"; Year = "2024" }
    # Rembrandt (Ryzen 6000 Mobile)
    '161a' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '161b' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '161c' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '161d' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '161e' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '161f' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '15d6' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '15d7' = @{ Name = "Rembrandt USB4 XHCI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4"; Year = "2022" }
    '162e' = @{ Name = "Rembrandt USB4/Thunderbolt NHI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4/TB"; Year = "2022" }
    '162f' = @{ Name = "Rembrandt USB4/Thunderbolt NHI controller"; Platform = "Ryzen 6000 Mobile (Zen 3+)"; USB = "USB4/TB"; Year = "2022" }
    # Phoenix (Ryzen 7040)
    '15c4' = @{ Name = "Phoenix USB4/Thunderbolt NHI controller"; Platform = "Ryzen 7040 Mobile (Zen 4)"; USB = "USB4/TB"; Year = "2023" }
    '15c5' = @{ Name = "Phoenix USB4/Thunderbolt NHI controller"; Platform = "Ryzen 7040 Mobile (Zen 4)"; USB = "USB4/TB"; Year = "2023" }
    '1668' = @{ Name = "Pink Sardine USB4/Thunderbolt NHI controller"; Platform = "Pink Sardine"; USB = "USB4/TB"; Year = "2023" }
    '1669' = @{ Name = "Pink Sardine USB4/Thunderbolt NHI controller"; Platform = "Pink Sardine"; USB = "USB4/TB"; Year = "2023" }
    # Renoir / Cezanne (Ryzen 4000/5000 APU)
    '1639' = @{ Name = "Renoir/Cezanne USB 3.1"; Platform = "Ryzen 4000/5000 APU (Zen 2/3)"; USB = "USB 3.1"; Year = "2020" }
    # Raven Ridge / Picasso (Ryzen 2000/3000 APU)
    '15e0' = @{ Name = "Raven USB 3.1"; Platform = "Ryzen 2000 APU (Zen)"; USB = "USB 3.1"; Year = "2018" }
    '15e1' = @{ Name = "Raven USB 3.1"; Platform = "Ryzen 2000 APU (Zen)"; USB = "USB 3.1"; Year = "2018" }
    '15e5' = @{ Name = "Raven2 USB 3.1"; Platform = "Ryzen 3000 APU (Zen+)"; USB = "USB 3.1"; Year = "2019" }
    # Matisse / Vermeer (Ryzen 3000/5000 Desktop)
    '149c' = @{ Name = "Matisse USB 3.0 Host Controller"; Platform = "Ryzen 3000/5000 Desktop (Zen 2/3)"; USB = "USB 3.0"; Year = "2019" }
    '148c' = @{ Name = "Starship USB 3.0 Host Controller"; Platform = "EPYC Rome / Threadripper 3rd Gen"; USB = "USB 3.0"; Year = "2019" }
    # Zeppelin (Ryzen 1000)
    '145f' = @{ Name = "Zeppelin USB 3.0 xHCI Compliant Host Controller"; Platform = "Ryzen 1000 (Zen)"; USB = "USB 3.0"; Year = "2017" }
    '145c' = @{ Name = "Family 17h USB 3.0 Host Controller"; Platform = "Ryzen 1000 (Zen)"; USB = "USB 3.0"; Year = "2017" }
    # Van Gogh (Steam Deck)
    '162c' = @{ Name = "VanGogh USB2"; Platform = "Steam Deck (Van Gogh)"; USB = "USB 2.0"; Year = "2022" }
    '163a' = @{ Name = "VanGogh USB0"; Platform = "Steam Deck (Van Gogh)"; USB = "USB 3.1"; Year = "2022" }
    '163b' = @{ Name = "VanGogh USB1"; Platform = "Steam Deck (Van Gogh)"; USB = "USB 3.1"; Year = "2022" }
    # Other
    '15d4' = @{ Name = "FireFlight USB 3.1"; Platform = "FireFlight"; USB = "USB 3.1"; Year = "2020" }
    '15d5' = @{ Name = "FireFlight USB 3.1"; Platform = "FireFlight"; USB = "USB 3.1"; Year = "2020" }
    '13ed' = @{ Name = "Ariel USB 3.1 Type C (Gen2 + DP Alt)"; Platform = "Ariel"; USB = "USB 3.1 Gen 2"; Year = "2020" }
    '13ee' = @{ Name = "Ariel USB 3.1 Type A (Gen2 x 2 ports)"; Platform = "Ariel"; USB = "USB 3.1 Gen 2"; Year = "2020" }
    '1557' = @{ Name = "Turin USB 3.1 xHCI"; Platform = "EPYC Turin"; USB = "USB 3.1"; Year = "2024" }
}

# AMD Chipset (CHIP 1)
$AmdChipset = @{
    '43fc' = @{ Name = "800 Series Chipset USB 3.x XHCI Controller"; Platform = "X870/B850 (AM5)"; USB = "USB 3.2"; Year = "2024" }
    '43fd' = @{ Name = "800 Series Chipset USB 3.x XHCI Controller"; Platform = "X870/B850 (AM5)"; USB = "USB 3.2"; Year = "2024" }
    '43f7' = @{ Name = "600 Series Chipset USB 3.2 Controller"; Platform = "X670/B650 (AM5)"; USB = "USB 3.2"; Year = "2022" }
    '43ee' = @{ Name = "500 Series Chipset USB 3.1 XHCI Controller"; Platform = "X570/B550 (AM4)"; USB = "USB 3.1"; Year = "2019" }
    '43ec' = @{ Name = "A520 Series Chipset USB 3.1 XHCI Controller"; Platform = "A520 (AM4)"; USB = "USB 3.1"; Year = "2020" }
    '43d5' = @{ Name = "400 Series Chipset USB 3.1 xHCI Compliant Host Controller"; Platform = "X470/B450 (AM4)"; USB = "USB 3.1"; Year = "2018" }
    '43b9' = @{ Name = "X370 Series Chipset USB 3.1 xHCI Controller"; Platform = "X370 (AM4)"; USB = "USB 3.1"; Year = "2017" }
    '43ba' = @{ Name = "X399 Series Chipset USB 3.1 xHCI Controller"; Platform = "X399 (Threadripper)"; USB = "USB 3.1"; Year = "2017" }
    '43bb' = @{ Name = "300 Series Chipset USB 3.1 xHCI Controller"; Platform = "B350 (AM4)"; USB = "USB 3.1"; Year = "2017" }
    '43bc' = @{ Name = "A320 USB 3.1 XHCI Host Controller"; Platform = "A320 (AM4)"; USB = "USB 3.1"; Year = "2017" }
    '7814' = @{ Name = "FCH USB XHCI Controller"; Platform = "Legacy FCH"; USB = "USB 3.0"; Year = "2013" }
    '7812' = @{ Name = "FCH USB XHCI Controller"; Platform = "Legacy FCH"; USB = "USB 3.0"; Year = "2012" }
}

# Third-party add-in cards (CHIP 1+)
$ThirdParty = @{
    # ASMedia (VID: 1b21)
    '1b21:1042' = @{ Name = "ASM1042 SuperSpeed USB Host Controller"; Vendor = "ASMedia"; USB = "USB 3.0 (5Gbps)"; Year = "2011" }
    '1b21:1142' = @{ Name = "ASM1042A USB 3.0 Host Controller"; Vendor = "ASMedia"; USB = "USB 3.0 (5Gbps)"; Year = "2013" }
    '1b21:1242' = @{ Name = "ASM1142 USB 3.1 Host Controller"; Vendor = "ASMedia"; USB = "USB 3.1 Gen 2 (10Gbps)"; Year = "2015" }
    '1b21:1343' = @{ Name = "ASM1143 USB 3.1 Host Controller"; Vendor = "ASMedia"; USB = "USB 3.1 Gen 2 (10Gbps)"; Year = "2017" }
    '1b21:2142' = @{ Name = "ASM2142/ASM3142 USB 3.1 Host Controller"; Vendor = "ASMedia"; USB = "USB 3.1 Gen 2 (10Gbps)"; Year = "2016" }
    '1b21:3042' = @{ Name = "ASM3042 USB 3.2 Gen 1 xHCI Controller"; Vendor = "ASMedia"; USB = "USB 3.2 Gen 1 (5Gbps)"; Year = "2019" }
    '1b21:3142' = @{ Name = "ASM3142 USB 3.2 Gen 2x1 xHCI Controller"; Vendor = "ASMedia"; USB = "USB 3.2 Gen 2 (10Gbps)"; Year = "2019" }
    '1b21:3242' = @{ Name = "ASM3242 USB 3.2 Host Controller"; Vendor = "ASMedia"; USB = "USB 3.2 Gen 2x2 (20Gbps)"; Year = "2020" }
    '1b21:2425' = @{ Name = "ASM4242 USB 4 / Thunderbolt 3 Host Router"; Vendor = "ASMedia"; USB = "USB4/TB3 (40Gbps)"; Year = "2022" }
    '1b21:2426' = @{ Name = "ASM4242 USB 3.2 xHCI Controller"; Vendor = "ASMedia"; USB = "USB 3.2"; Year = "2022" }
    # VIA (VID: 1106)
    '1106:3483' = @{ Name = "VL805/806 xHCI USB 3.0 Controller"; Vendor = "VIA"; USB = "USB 3.0 (5Gbps)"; Year = "2014" }
    '1106:3432' = @{ Name = "VL800/801 xHCI USB 3.0 Controller"; Vendor = "VIA"; USB = "USB 3.0 (5Gbps)"; Year = "2012" }
    # Fresco Logic (VID: 1b73)
    '1b73:1000' = @{ Name = "FL1000G USB 3.0 Host Controller"; Vendor = "Fresco Logic"; USB = "USB 3.0 (5Gbps)"; Year = "2010" }
    '1b73:1009' = @{ Name = "FL1009 USB 3.0 Host Controller"; Vendor = "Fresco Logic"; USB = "USB 3.0 (5Gbps)"; Year = "2011" }
    '1b73:1100' = @{ Name = "FL1100 USB 3.0 Host Controller"; Vendor = "Fresco Logic"; USB = "USB 3.0 (5Gbps)"; Year = "2012" }
    '1b73:1400' = @{ Name = "FL1400 USB 3.0 Host Controller"; Vendor = "Fresco Logic"; USB = "USB 3.0 (5Gbps)"; Year = "2014" }
    # Etron (VID: 1b6f)
    '1b6f:7023' = @{ Name = "EJ168 USB 3.0 Host Controller"; Vendor = "Etron"; USB = "USB 3.0 (5Gbps)"; Year = "2011" }
    '1b6f:7052' = @{ Name = "EJ188/EJ198 USB 3.0 Host Controller"; Vendor = "Etron"; USB = "USB 3.0 (5Gbps)"; Year = "2013" }
    # Renesas (VID: 1912)
    '1912:0014' = @{ Name = "uPD720201 USB 3.0 Host Controller"; Vendor = "Renesas"; USB = "USB 3.0 (5Gbps)"; Year = "2011" }
    '1912:0015' = @{ Name = "uPD720202 USB 3.0 Host Controller"; Vendor = "Renesas"; USB = "USB 3.0 (5Gbps)"; Year = "2012" }
}

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

function Get-ControllerInfo {
    param([string]$Vid, [string]$Did)

    $vid = $Vid.ToLower()
    $did = $Did.ToLower()
    $key = "$vid`:$did"

    # Intel CPU-integrated = CHIP 0
    if ($vid -eq '8086' -and $IntelCpuIntegrated.ContainsKey($did)) {
        $data = $IntelCpuIntegrated[$did]
        return @{ Type = "CPU"; ChipCount = 0; Name = $data.Name; Platform = $data.Platform; USB = $data.USB }
    }

    # Intel Thunderbolt = CHIP 0 (CPU-attached)
    if ($vid -eq '8086' -and $IntelThunderbolt.ContainsKey($did)) {
        $data = $IntelThunderbolt[$did]
        return @{ Type = "TB"; ChipCount = 0; Name = $data.Name; Platform = $data.Platform; USB = $data.USB }
    }

    # Intel PCH = CHIP 1
    if ($vid -eq '8086' -and $IntelPch.ContainsKey($did)) {
        $data = $IntelPch[$did]
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = $data.Name; Platform = $data.Platform; USB = $data.USB }
    }

    # AMD CPU-integrated = CHIP 0
    if ($vid -eq '1022' -and $AmdCpuIntegrated.ContainsKey($did)) {
        $data = $AmdCpuIntegrated[$did]
        return @{ Type = "CPU"; ChipCount = 0; Name = $data.Name; Platform = $data.Platform; USB = $data.USB }
    }

    # AMD Chipset = CHIP 1
    if ($vid -eq '1022' -and $AmdChipset.ContainsKey($did)) {
        $data = $AmdChipset[$did]
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = $data.Name; Platform = $data.Platform; USB = $data.USB }
    }

    # Third-party
    if ($ThirdParty.ContainsKey($key)) {
        $data = $ThirdParty[$key]
        return @{ Type = "ADDON"; ChipCount = 1; Name = $data.Name; Platform = "PCIe Add-in"; USB = $data.USB }
    }

    # Unknown third-party vendors
    $vendors = @{ '1b21' = 'ASMedia'; '1106' = 'VIA'; '1b73' = 'Fresco Logic'; '1912' = 'Renesas'; '1b6f' = 'Etron'; '104c' = 'Texas Instruments' }
    if ($vendors.ContainsKey($vid)) {
        return @{ Type = "ADDON"; ChipCount = 1; Name = "$($vendors[$vid]) Controller"; Platform = "PCIe Add-in"; USB = "USB 3.x" }
    }

    # Intel unknown = assume PCH
    if ($vid -eq '8086') {
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = "Intel USB Controller"; Platform = "Unknown PCH (DID:$did)"; USB = "USB 3.x" }
    }

    # AMD unknown = assume chipset
    if ($vid -eq '1022') {
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = "AMD USB Controller"; Platform = "Unknown Chipset (DID:$did)"; USB = "USB 3.x" }
    }

    return @{ Type = "UNKNOWN"; ChipCount = 1; Name = "Unknown Controller"; Platform = "VID:$vid DID:$did"; USB = "?" }
}

function Get-MsiStatus {
    param([string]$InstanceId)

    if ($InstanceId -notmatch "^PCI\\") { return $null }
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$InstanceId\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"

    try {
        if (Test-Path $regPath) {
            $msi = Get-ItemProperty -Path $regPath -Name "MSISupported" -ErrorAction SilentlyContinue
            if ($null -ne $msi) {
                return @{ Enabled = ($msi.MSISupported -eq 1); Status = if ($msi.MSISupported -eq 1) { "MSI" } else { "Line-Based" } }
            }
        }
    } catch { }
    return @{ Enabled = $null; Status = "Unknown" }
}

function Get-PowerManagement {
    param([string]$InstanceId)

    $result = @{ SelectiveSuspend = $null; IdleEnabled = $null }
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$InstanceId\Device Parameters"

    try {
        if (Test-Path $regPath) {
            $params = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
            if ($null -ne $params.SelectiveSuspendEnabled) { $result.SelectiveSuspend = ($params.SelectiveSuspendEnabled -eq 1) }
            if ($null -ne $params.EnhancedPowerManagementEnabled) { $result.IdleEnabled = ($params.EnhancedPowerManagementEnabled -eq 1) }
        }
    } catch { }
    return $result
}

function Get-SystemUsbSuspend {
    # Check Windows power plan USB selective suspend setting
    try {
        $output = & powercfg /query SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND 2>&1
        $outputStr = $output -join "`n"
        if ($outputStr -match "Current AC Power Setting Index:\s*0x([0-9a-fA-F]+)") {
            $acValue = [int]("0x" + $Matches[1])
            return @{ AC = ($acValue -eq 1); DC = $null }
        }
    } catch { }
    return @{ AC = $null; DC = $null }
}

function Get-DriverInfo {
    param([string]$InstanceId)

    $result = @{ Version = $null; Date = $null; Provider = $null }
    try {
        $ver = Get-PnpDeviceProperty -InstanceId $InstanceId -KeyName "DEVPKEY_Device_DriverVersion" -ErrorAction Stop
        if ($ver.Data) { $result.Version = $ver.Data }
    } catch { }
    try {
        $date = Get-PnpDeviceProperty -InstanceId $InstanceId -KeyName "DEVPKEY_Device_DriverDate" -ErrorAction Stop
        if ($date.Data) { $result.Date = $date.Data.ToString("yyyy-MM-dd") }
    } catch { }
    try {
        $prov = Get-PnpDeviceProperty -InstanceId $InstanceId -KeyName "DEVPKEY_Device_DriverProvider" -ErrorAction Stop
        if ($prov.Data) { $result.Provider = $prov.Data }
    } catch { }
    return $result
}

function Get-DeviceChain {
    param([string]$InstanceId)

    $result = @{
        ControllerInstanceId = ""
        ControllerVid = ""
        ControllerDid = ""
        ControllerInfo = $null
        HubCount = 0
        HubNames = @()
        ChipCount = 0
    }

    $currentId = $InstanceId
    $count = 0

    while ($currentId -and $count -lt 15) {
        $count++
        $dev = Get-PnpDevice -InstanceId $currentId -ErrorAction SilentlyContinue

        if ($currentId -match "ROOT_HUB") {
            try {
                $parent = Get-PnpDeviceProperty -InstanceId $currentId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
                $ctrlId = $parent.Data

                $vid = ""; $did = ""
                if ($ctrlId -match 'VEN_([0-9A-Fa-f]{4})') { $vid = $Matches[1].ToLower() }
                if ($ctrlId -match 'DEV_([0-9A-Fa-f]{4})') { $did = $Matches[1].ToLower() }

                $result.ControllerInstanceId = $ctrlId
                $result.ControllerVid = $vid
                $result.ControllerDid = $did
                $result.ControllerInfo = Get-ControllerInfo -Vid $vid -Did $did
                $result.ChipCount = $result.ControllerInfo.ChipCount + $result.HubCount
            } catch { }
            break
        }

        if ($dev -and $dev.FriendlyName -match "Hub" -and $dev.FriendlyName -notmatch "Root") {
            $result.HubCount++
            $result.HubNames += $dev.FriendlyName
        }

        try {
            $parent = Get-PnpDeviceProperty -InstanceId $currentId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
            $currentId = $parent.Data
        } catch { break }
    }

    return $result
}

function Get-ShortName {
    param([string]$Name, [int]$MaxLen = 30)

    # Strip common prefixes
    $short = $Name -replace "^Razer\s+", "" -replace "^Logitech\s+", "" -replace "^SteelSeries\s+", "" -replace "^Corsair\s+", "" -replace "^HyperX\s+", ""

    if ($short.Length -gt $MaxLen) {
        $short = $short.Substring(0, $MaxLen - 3) + "..."
    }
    return $short
}

# =============================================================================
# DATA GATHERING
# =============================================================================

function Update-Progress {
    param([int]$Percent, [string]$Message)
    $ESC = [char]27
    $width = 25
    $filled = [int][math]::Floor($width * $Percent / 100)
    $empty = $width - $filled

    # Block chars: filled = # empty = -
    $filledStr = [string]::new([char]0x2593, $filled)
    $emptyStr = [string]::new([char]0x2591, $empty)
    $bar = "$ESC[38;2;0;255;135m$filledStr$ESC[38;2;60;60;60m$emptyStr$ESC[0m"

    Write-Host "`r  $bar $ESC[38;2;108;108;108m$Message$ESC[0m".PadRight(75) -NoNewline
}

function Get-UsbData {
    $data = @{
        Controllers = @()
        Devices = @()
        HasChip0 = $false
        HasChip1 = $false
        Optimizations = @()
        SystemSuspend = $null
    }

    Update-Progress 5 "Checking power settings..."

    # Check system-wide USB selective suspend (power plan setting)
    $data.SystemSuspend = Get-SystemUsbSuspend
    if ($data.SystemSuspend.AC -eq $true) {
        $data.Optimizations += @{ Type = "SystemSuspend"; Controller = $null; Name = "Windows Power Plan"; Desc = "Disable USB Selective Suspend in power plan" }
    }

    Update-Progress 15 "Scanning USB controllers..."

    # Get controllers
    $controllers = Get-PnpDevice -Class USB -Status OK -ErrorAction SilentlyContinue | Where-Object { $_.FriendlyName -match "Controller" }

    foreach ($ctrl in $controllers) {
        $vid = ""; $did = ""
        if ($ctrl.InstanceId -match 'VEN_([0-9A-Fa-f]{4})') { $vid = $Matches[1].ToLower() }
        if ($ctrl.InstanceId -match 'DEV_([0-9A-Fa-f]{4})') { $did = $Matches[1].ToLower() }

        $info = Get-ControllerInfo -Vid $vid -Did $did
        $msi = Get-MsiStatus -InstanceId $ctrl.InstanceId
        $power = Get-PowerManagement -InstanceId $ctrl.InstanceId
        $driver = Get-DriverInfo -InstanceId $ctrl.InstanceId

        $ctrlData = @{
            InstanceId = $ctrl.InstanceId
            FriendlyName = $ctrl.FriendlyName
            Vid = $vid
            Did = $did
            Info = $info
            Msi = $msi
            Power = $power
            Driver = $driver
            Devices = @()
        }

        $data.Controllers += $ctrlData

        if ($info.ChipCount -eq 0) { $data.HasChip0 = $true }
        else { $data.HasChip1 = $true }

        # Track optimization opportunities
        if ($msi -and $msi.Enabled -eq $false) {
            $data.Optimizations += @{ Type = "MSI"; Controller = $ctrl.InstanceId; Name = $info.Name; Desc = "Enable MSI interrupts" }
        }
        if ($power.SelectiveSuspend -eq $true) {
            $data.Optimizations += @{ Type = "Suspend"; Controller = $ctrl.InstanceId; Name = $info.Name; Desc = "Disable Selective Suspend (per-device)" }
        }
    }

    Update-Progress 30 "Finding input devices..."

    # Get HID devices (USB class 0x03) + Xbox controllers
    # USB Class 03 = Human Interface Device (keyboards, mice, game controllers, etc.)
    $inputDevices = @()

    # Method 1: USB devices with HID class (Class_03)
    $usbDevices = Get-PnpDevice -Status OK -ErrorAction SilentlyContinue | Where-Object { $_.InstanceId -match "^USB\\" }
    foreach ($dev in $usbDevices) {
        try {
            $compatIds = (Get-PnpDeviceProperty -InstanceId $dev.InstanceId -KeyName "DEVPKEY_Device_CompatibleIds" -ErrorAction SilentlyContinue).Data
            if ($compatIds -match "Class_03") {
                $inputDevices += $dev
            }
        } catch {}
    }

    # Method 2: Xbox-specific classes (these are handled specially by Windows)
    $xboxDevices = Get-PnpDevice -Class "XboxComposite", "XnaComposite", "XUSBClass" -Status OK -ErrorAction SilentlyContinue
    if ($xboxDevices) { $inputDevices += $xboxDevices }

    # Remove duplicates by InstanceId
    $inputDevices = $inputDevices | Sort-Object InstanceId -Unique

    $devCount = 0
    $totalDevs = [math]::Max(1, @($inputDevices).Count)

    foreach ($device in $inputDevices) {
        $devCount++
        # Progress from 30% to 95%
        $pct = 30 + [int](($devCount / $totalDevs) * 65)
        if ($devCount % 2 -eq 0) { Update-Progress $pct "Tracing device $devCount of $totalDevs..." }

        $instanceId = $device.InstanceId
        $usbParent = $instanceId

        if ($instanceId -match "^HID\\") {
            try {
                $parent = Get-PnpDeviceProperty -InstanceId $instanceId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
                $usbParent = $parent.Data
            } catch { continue }
        }

        $chain = Get-DeviceChain -InstanceId $usbParent
        if (-not $chain.ControllerInfo) { continue }

        # Get VID/PID
        $devVid = "????"; $devPid = "????"
        if ($usbParent -match "VID_([0-9A-F]{4})") { $devVid = $matches[1] }
        if ($usbParent -match "PID_([0-9A-F]{4})") { $devPid = $matches[1] }

        # Get USB product string (better than Windows generic names)
        $devName = $device.FriendlyName
        try {
            $busDesc = (Get-PnpDeviceProperty -InstanceId $usbParent -KeyName "DEVPKEY_Device_BusReportedDeviceDesc" -ErrorAction SilentlyContinue).Data
            if ($busDesc -and $busDesc.Trim()) { $devName = $busDesc.Trim() }
        } catch {}

        $devData = @{
            Name = $devName
            ShortName = Get-ShortName -Name $devName
            Vid = $devVid
            Pid = $devPid
            InstanceId = $usbParent
            Chain = $chain
            ChipCount = $chain.ChipCount
        }

        # Skip duplicates (same VID+PID = same physical device, multiple interfaces)
        $devKey = "$devVid`:$devPid"
        $existing = $data.Devices | Where-Object { "$($_.Vid):$($_.Pid)" -eq $devKey }
        if ($existing) { continue }

        $data.Devices += $devData

        # Add to controller's device list
        foreach ($ctrl in $data.Controllers) {
            if ($ctrl.InstanceId -eq $chain.ControllerInstanceId) {
                $ctrl.Devices += $devData
                break
            }
        }
    }

    return $data
}

# =============================================================================
# DISPLAY FUNCTIONS
# =============================================================================

function Show-Tree {
    param($Data)

    $ESC = [char]27
    # TrueColor palette
    $Mint = "$ESC[38;2;0;255;135m"        # 0 chips - best
    $Orange = "$ESC[38;2;255;179;71m"     # 1 chip - ok
    $Coral = "$ESC[38;2;255;107;107m"     # 2+ chips - slow
    $Dim = "$ESC[38;2;108;108;108m"
    $White = "$ESC[97m"
    $Reset = "$ESC[0m"
    $Bold = "$ESC[1m"

    # Group devices by chips BETWEEN device and CPU
    $chip0Devs = @($Data.Devices | Where-Object { $_.ChipCount -eq 0 })  # Direct to CPU = 0 chips between
    $chip1Devs = @($Data.Devices | Where-Object { $_.ChipCount -eq 1 })  # Via chipset = 1 chip between
    $chip2Devs = @($Data.Devices | Where-Object { $_.ChipCount -ge 2 })  # Via hub = 2+ chips between

    Write-Host ""
    Write-Host "  ${Dim}Count chips between your device and CPU. More chips = more latency.${Reset}"
    Write-Host ""

    # Visual chip path legend - showing what's BETWEEN device and CPU
    Write-Host "  ${Mint}${Bold}0 CHIPS${Reset}  device ${Mint}---${Reset} [CPU]"
    Write-Host "  ${Orange}${Bold}1 CHIP${Reset}   device -${Orange}[CHIPSET]${Reset}- [CPU]"
    Write-Host "  ${Coral}${Bold}2 CHIPS${Reset}  device -${Coral}[HUB]${Reset}-[CHIPSET]- [CPU]"
    Write-Host ""

    Write-Host "  ${Dim}=============================================================${Reset}"
    Write-Host ""

    if ($Data.Devices.Count -eq 0) {
        Write-Host "  ${Dim}No USB input devices detected${Reset}"
    } else {
        # Warning if no direct CPU USB
        if (-not $Data.HasChip0) {
            Write-Host "  ${Orange}! This system has no direct CPU USB${Reset}"
            Write-Host "  ${Dim}  1 chip is your best option here${Reset}"
            Write-Host ""
        }

        # 0 CHIPS - Direct to CPU (best)
        if ($chip0Devs.Count -gt 0) {
            Write-Host "  ${Mint}0 chips${Reset} ${Dim}- direct to CPU${Reset}"
            $count = $chip0Devs.Count
            $i = 0
            foreach ($dev in $chip0Devs) {
                $i++
                $branch = if ($i -eq $count) { "'-" } else { "|-" }
                Write-Host "    ${Dim}$branch${Reset} ${Mint}$($dev.Name)${Reset}"
            }
            Write-Host ""
        }

        # 1 CHIP - Via chipset
        if ($chip1Devs.Count -gt 0) {
            Write-Host "  ${Orange}1 chip${Reset} ${Dim}- through chipset${Reset}"
            $count = $chip1Devs.Count
            $i = 0
            foreach ($dev in $chip1Devs) {
                $i++
                $branch = if ($i -eq $count) { "'-" } else { "|-" }
                Write-Host "    ${Dim}$branch${Reset} ${Orange}$($dev.Name)${Reset}"
            }
            Write-Host ""
        }

        # 2+ CHIPS - Via hub (slowest)
        if ($chip2Devs.Count -gt 0) {
            Write-Host "  ${Coral}2+ chips${Reset} ${Dim}- through hub${Reset}"
            $count = $chip2Devs.Count
            $i = 0
            foreach ($dev in $chip2Devs) {
                $i++
                $branch = if ($i -eq $count) { "'-" } else { "|-" }
                Write-Host "    ${Dim}$branch${Reset} ${Coral}$($dev.Name)${Reset}"
            }
            Write-Host ""
        }
    }

    Write-Host "  ${Dim}=============================================================${Reset}"
    Write-Host ""
    Write-Host "  ${Dim}Unplug and replug to test different ports${Reset}"
    Write-Host ""
}

function Show-FullAnalysis {
    param($Data)

    $ESC = [char]27
    # TrueColor palette (matching Show-Tree)
    $Mint = "$ESC[38;2;0;255;135m"        # CHIP 0 - minty green
    $Orange = "$ESC[38;2;255;179;71m"     # CHIP 1 - soft orange
    $Coral = "$ESC[38;2;255;107;107m"     # CHIP 2+ - coral red
    $Sky = "$ESC[38;2;135;206;235m"       # Headers - sky blue
    $Dim = "$ESC[38;2;108;108;108m"       # Dim text
    $Border = "$ESC[38;2;74;74;74m"       # Box borders
    $White = "$ESC[97m"
    $Reset = "$ESC[0m"
    $Bold = "$ESC[1m"

    # Controllers
    Write-Host "  ${White}${Bold}CONTROLLERS${Reset}"
    Write-Host "  ${Border}---------------------------------------------------------------------${Reset}"

    # Sort controllers - CHIP 0 first
    $sortedControllers = $Data.Controllers | Sort-Object { [int]$_.Info.ChipCount }

    foreach ($ctrl in $sortedControllers) {
        $info = $ctrl.Info
        $chipColor = switch ($info.ChipCount) {
            0 { $Mint }
            1 { $Orange }
            default { $Coral }
        }

        # Clear label for what each chip level means
        $chipLabel = switch ($info.ChipCount) {
            0 { "CHIP 0 - INSIDE CPU" }
            1 { "CHIP 1 - CHIPSET" }
            default { "CHIP $($info.ChipCount) - HUB" }
        }

        Write-Host ""
        Write-Host "  ${chipColor}$chipLabel${Reset}"
        Write-Host "      $($info.Name)"
        Write-Host "      ${Dim}VID:$($ctrl.Vid) DID:$($ctrl.Did) | $($info.Platform)${Reset}"

        # MSI Status
        if ($ctrl.Msi) {
            Write-Host "      IRQ: " -NoNewline
            if ($ctrl.Msi.Enabled -eq $true) {
                Write-Host "${Mint}MSI${Reset} ${Dim}(low latency interrupts)${Reset}"
            } elseif ($ctrl.Msi.Enabled -eq $false) {
                Write-Host "${Coral}Line-Based${Reset} ${Dim}(higher latency)${Reset}"
            } else {
                Write-Host "${Dim}$($ctrl.Msi.Status)${Reset}"
            }
        }

        # Power Management
        if ($ctrl.Power.SelectiveSuspend -eq $true) {
            Write-Host "      ${Orange}! Selective Suspend ENABLED${Reset} ${Dim}(causes latency spikes)${Reset}"
        }

        # Devices on this controller
        if ($ctrl.Devices.Count -gt 0) {
            Write-Host "      ${Dim}Devices:${Reset}"
            $count = $ctrl.Devices.Count
            $i = 0
            foreach ($dev in $ctrl.Devices) {
                $i++
                $branch = if ($i -eq $count) { "'-" } else { "|-" }
                $hubInfo = if ($dev.Chain.HubCount -gt 0) { " ${Coral}(+hub)${Reset}" } else { "" }
                Write-Host "        ${Dim}$branch${Reset} $($dev.Name)$hubInfo"
            }
        }
    }

    # Input devices detail
    Write-Host ""
    Write-Host "  ${White}${Bold}INPUT DEVICES${Reset}"
    Write-Host "  ${Border}---------------------------------------------------------------------${Reset}"

    # Sort by chip count (closest to CPU first)
    $sortedDevices = $Data.Devices | Sort-Object { [int]$_.ChipCount }

    foreach ($dev in $sortedDevices) {
        $chipColor = switch ($dev.ChipCount) {
            0 { $Mint }
            1 { $Orange }
            default { $Coral }
        }

        # Build chip label with description
        $chipLabel = switch ($dev.ChipCount) {
            0 { "CHIP 0 - CPU" }
            1 { "CHIP 1 - CHIPSET" }
            2 { "CHIP 2 - HUB" }
            default { "CHIP $($dev.ChipCount) - HUB" }
        }

        Write-Host ""
        Write-Host "  ${White}$($dev.Name)${Reset}"
        Write-Host "      ${Dim}VID:$($dev.Vid) PID:$($dev.Pid)${Reset}"
        Write-Host "      ${chipColor}${chipLabel}${Reset}"

        if ($dev.Chain.HubNames.Count -gt 0) {
            Write-Host "      ${Dim}Hubs: $($dev.Chain.HubNames -join " -> ")${Reset}"
        }
    }

    Write-Host ""
    Write-Host "  ${Border}=====================================================================${Reset}"
    Write-Host ""
}

function Show-Optimizations {
    param($Data)

    $ESC = [char]27
    # TrueColor palette (matching other functions)
    $Mint = "$ESC[38;2;0;255;135m"        # Good/success
    $Orange = "$ESC[38;2;255;179;71m"     # Warning
    $Coral = "$ESC[38;2;255;107;107m"     # Error/attention
    $Sky = "$ESC[38;2;135;206;235m"       # Headers
    $Dim = "$ESC[38;2;108;108;108m"       # Dim text
    $Border = "$ESC[38;2;74;74;74m"       # Box borders
    $White = "$ESC[97m"
    $Reset = "$ESC[0m"
    $Bold = "$ESC[1m"

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($Data.Optimizations.Count -eq 0) {
        return
    }

    Write-Host "  ${White}${Bold}OPTIMIZATIONS AVAILABLE${Reset}"
    Write-Host "  ${Border}---------------------------------------------------------------------${Reset}"
    Write-Host ""

    if (-not $isAdmin) {
        Write-Host "  ${Orange}! To apply optimizations: Run as Administrator${Reset}"
        Write-Host ""
        $i = 0
        $count = $Data.Optimizations.Count
        foreach ($opt in $Data.Optimizations) {
            $i++
            $branch = if ($i -eq $count) { "'-" } else { "|-" }
            Write-Host "  ${Dim}$branch${Reset} $($opt.Desc) on ${Dim}$($opt.Name)${Reset}"
        }
        Write-Host ""
        return
    }

    # Show numbered options
    $i = 1
    foreach ($opt in $Data.Optimizations) {
        Write-Host "  ${Sky}[$i]${Reset} $($opt.Desc)"
        Write-Host "      ${Dim}$($opt.Name)${Reset}"
        Write-Host ""
        $i++
    }

    Write-Host "  ${Dim}Enter number to apply, or press Enter to skip:${Reset} " -NoNewline
    $choice = Read-Host

    if ($choice -match '^\d+$') {
        $idx = [int]$choice - 1
        if ($idx -ge 0 -and $idx -lt $Data.Optimizations.Count) {
            $opt = $Data.Optimizations[$idx]
            Apply-Optimization -Opt $opt
        }
    }
}

function Apply-Optimization {
    param($Opt)

    $ESC = [char]27
    # TrueColor palette
    $Mint = "$ESC[38;2;0;255;135m"        # Success
    $Orange = "$ESC[38;2;255;179;71m"     # Warning
    $Coral = "$ESC[38;2;255;107;107m"     # Error
    $Dim = "$ESC[38;2;108;108;108m"       # Dim text
    $Reset = "$ESC[0m"

    Write-Host ""

    switch ($Opt.Type) {
        "MSI" {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($Opt.Controller)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
            try {
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                Set-ItemProperty -Path $regPath -Name "MSISupported" -Value 1 -Type DWord -Force
                Write-Host "  ${Mint}[OK]${Reset} Enabled MSI for $($Opt.Name)"
                Write-Host "  ${Orange}! Restart required to take effect${Reset}"
            } catch {
                Write-Host "  ${Coral}[FAIL]${Reset} Failed to enable MSI: $_"
            }
        }
        "Suspend" {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($Opt.Controller)\Device Parameters"
            try {
                Set-ItemProperty -Path $regPath -Name "SelectiveSuspendEnabled" -Value 0 -Type DWord -Force
                Write-Host "  ${Mint}[OK]${Reset} Disabled Selective Suspend for $($Opt.Name)"
            } catch {
                Write-Host "  ${Coral}[FAIL]${Reset} Failed to disable suspend: $_"
            }
        }
        "SystemSuspend" {
            try {
                # Disable USB selective suspend in current power plan (0 = disabled)
                powercfg /setacvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND 0 | Out-Null
                powercfg /setdcvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND 0 | Out-Null
                powercfg /setactive SCHEME_CURRENT | Out-Null
                Write-Host "  ${Mint}[OK]${Reset} Disabled USB Selective Suspend in power plan"
                Write-Host "  ${Dim}(Both AC and battery power)${Reset}"
            } catch {
                Write-Host "  ${Coral}[FAIL]${Reset} Failed to change power plan: $_"
            }
        }
    }

    Write-Host ""
}

# =============================================================================
# MAIN
# =============================================================================

Clear-Host

$ESC = [char]27

# Show header immediately so user knows app started
Write-Host ""
Write-Host "  $ESC[38;2;135;206;235m$ESC[1mUSB LATENCY ANALYZER V2$ESC[0m"
Write-Host "  $ESC[90m=====================================================================$ESC[0m"
Write-Host ""

# Gather data (status updates shown by Get-UsbData)
$data = Get-UsbData

# Clear the status line and show ready
Write-Host "`r$(' ' * 100)" -NoNewline
Write-Host "`r  $ESC[38;2;0;255;135m[OK]$ESC[0m $ESC[38;2;108;108;108mReady$ESC[0m"
Start-Sleep -Milliseconds 150

# Show tree
Show-Tree -Data $data

# Show full analysis
Show-FullAnalysis -Data $data

# Show optimizations
Show-Optimizations -Data $data
Pause