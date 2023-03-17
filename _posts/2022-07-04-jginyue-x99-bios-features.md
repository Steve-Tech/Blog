---
layout: post
title:  "JGINYUE X99-D8 Dual CPU Motherboard BIOS Features"
---
I recently bought a [JGINYUE X99-D8](https://www.aliexpress.com/item/1005003601899252.html) to use with my home lab. However before I bought it I couldn't find much info about it, such as if it it supported SR-IOV or even virtualisation at all. Here's all the BIOS options that shipped with my motherboard.<!--more-->

The Motherboard Drivers and BIOS are [available on jginyue.com.cn](http://jginyue.com.cn/index.php?a=show&catid=6&id=146).

I've also made a custom [lm-sensors config file](https://gist.github.com/Steve-Tech/d81921919654c1fef246d65ca86df418) for this motherboard.

All of this article is my own findings but [Miyconst's video](https://youtu.be/9v5s42DEC3I) is worth checking out.

#### Important Features & Notes
##### AER Errors
If you experience AER errors in Linux, they can be avoided by disabling PCI-E ASPM, you will need to disable it globally and then go through each IIO Socket setting PCI-E ASPM to Disabled. This is common with other X99 motherboards.
##### Virtualisation
- SR-IOV
- VT-x
- VT-d
- ACS
- ARI Forwarding

##### Networking
- 2 &times; RTL8111/8168/8411 PCI Express Gigabit Ethernet Controllers
- Capabilities: pm msi pciexpress msix bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
- Supports Wake-on: pumbg (PHY, Unicast, Multicast, Broadcast, Magic Packet)

##### PCIe Slots
- PCIe 2.0 x1 - Chipset
- PCIe 3.0 x4 (M.2 M Key) - CPU0
- PCIe 3.0 x16 - CPU0
- PCIe 2.0 x1 - Chipset
- PCIe 3.0 x4 (M.2 M Key) - CPU1
- PCIe 3.0 x16 - CPU1
- PCIe 3.0 x8 (Physically x16) - CPU0

The PCIe x1 slots can easily be cut open using small side cutters to fit a card bigger than x1, but using a bigger card will obstruct an M.2 SSD.

##### Miscellaneous
- SATA 3.0, using SATA & sSATA Controllers
- 8 Channel RAM (2 CPUs &times; 4 Channels)
- PCIe Bifurcation Settings
- ECC & Non-ECC RAM Supported

#### `dmidecode` BIOS Information
```
Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: American Megatrends Inc.
        Version: 5.11
        Release Date: 05/14/2021
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 8 MB
        Characteristics:
                PCI is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                BIOS ROM is socketed
                EDD is supported
                5.25"/1.2 MB floppy services are supported (int 13h)
                3.5"/720 kB floppy services are supported (int 13h)
                3.5"/2.88 MB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                ACPI is supported
                USB legacy is supported
                BIOS boot specification is supported
                Targeted content distribution is supported
                UEFI is supported
        BIOS Revision: 5.11
```

#### (Almost) All BIOS Options
##### Main
- BIOS Vendor
- Core Version
- Compliancy
- Project Version
- Build Date and Time
- Access Level
- Total Memory
- System Language
- System Date
- System Time

##### Advanced
- ACPI Settings
    - Enable ACPI Auto Configuration
    - Enable Hibernation
    - Lock Legacy Resources
- NCT5532D Super IO Configuration
    - Super IO Chip
    - Serial Port 1 Configuration
        - Serial Port
        - Device Settings
        - Change Settings
- Hardware Monitor
    - Smart Fan Function
    - Smart Fan Mode Configuration
        - Cpu Fan Mode
        - Cpu Smart FanIV T1 Temp
        - Cpu Smart FanIV T2 Temp
        - Cpu Smart FanIV T3 Temp
        - Cpu Smart FanIV T4 Temp
    - CPU Temperature
    - System Temperature
    - CPU Fan2 Speed
    - CPU Fan1 Speed
    - VDIMM
    - +12V
    - VCC3V
    - VSB3V
    - VBAT
    - VTT
    - AVCC
- iSCSI Configuration
    - iSCSI Initiator Name
    - Add an Attempt
    - Delete Attempts
    - Change Attempt Order
- PCI Subsystem Settings
    - PCI Latency Timer
    - PCI-X Latency Timer
    - VGA Pallet Snoop
    - PERR# Generation
    - SERR# Generation
    - Above 4G Decoding
    - SR-IOV Support
    - BME DMA Mitigation
    - PCI Express Settings
        - Relaxed Ordering
        - Extended Tag
        - No Snoop
        - Maximum Payload
        - Extended Synch
        - Link Training Retry
        - Like Training Timeout (uS)
        - Restore PCIE Registers
    - PCI Express GEN 2 Settings
        - Completion Timeout
        - ARI Forwarding
        - AtomicOp Register Enable
        - AtomicOp Egress Blocking
        - ID0 Request Enable
        - ID0 Completion Enable
        - LTR Mechanism Enable
        - End-End TLP Prefix Blocking
        - Clock Power Management
        - Compliance SOS
        - Hardware Autonomous Width
        - Hardware Autonomous Speed
- Network Stack Configuration
    - Network Stack
    - Ipv4 PXE Support
    - Ipv6 PXE Support
    - PXE boot wait time
    - Media detect count
- CSM Configuration
    - CSM Support
    - GateA20 Active
    - Option ROM Messages
    - Boot option filter
    - Network
    - Storage
    - Video
    - Other PCI devices
- NVMe Configuration
- USB Configuration
    - Legacy USB Support
    - XHCI Hand-off
    - EHCI Hand-off
    - USB Mass Storage Driver Support
    - USB transfer time-out
    - Device reset time-out
    - Device power-up delay

##### IntelRCSetup
- Processor Configuration
    - Per-Socket Configuration
    - Hyper-Threading [ALL]
    - Check CPU BIST Result
    - Monitor/Mwait
    - Execute Disable Bit
    - Enable Intel TXT Support
    - VMX
    - Enable SMX
    - Lock Chipset
    - MSR Lock Control
    - PPIN Control
    - DEBUG INTERFACE
    - Hardware Prefetcher
    - Adjacent Cache Prefetch
    - DCU Stream Prefetcher
    - DCU IP Prefetcher
    - DCU Mode
    - Direct Cache Access (DCA)
    - DCA Prefetch Delay
    - X2APIC
    - AES-NI
    - Down Stream PECI
    - IIO LLC Ways \[19:0\]\(Hex\)
    - QLRU Config \[63:32\]\(Hex\)
    - QLRU Config \[31:0\]\(Hex\)
    - SMM Save State
    - Targeted Smi
- Advanced Power Management Configuration
    - Power Technology
    - Config TDP
    - IOTG Setting
    - Uncore CLR Freq OVRD
    - CPU P State Control
        - EIST (P-states)
        - Turbo Mode
        - P-state coordination
        - SPD
        - PL2_SAFETY_NET_ENABLE
        - Boot performance mode
    - CPU C State Control
        - C2C3TT
        - Package C State limit
        - CPU C3 report
        - CPU C6 report
    - CPU T State Control
        - ACPI T-States
    - CPU - Advanced PM Tuning
        - Energy Perf BIAS
            - Energy Performance Tuning
            - Energy Performance BIAS setting.
            - Power/Performance Switch
            - Workload Configuration
            - Averaging Time Window
            - P0 TotalTimeThreshold Low
            - P0 TotalTimeThreshold High
    - Socket RAPL Config
        - FAST_RAPL_NSTRIKE_PL2_DUTY_CYCLE
        - Turbo Pwr Limit Lock
        - Long Pwr Limit Ovrd
        - Long Dur Pwr Limit
        - Long Dur Time Window
        - Pkg Clmp Lim1
        - Short Dur Pwr Limit En
        - Short Dur Pwr Limit
        - Pkg Clmp Lim2
    - DRAM RAPL Configuration
        - DRAM RAPL Baseline
        - Overrife BW_LIMIT_TF
        - DRAM RAPL Extended Range
- Common RefCode Configuration
    - MMIOHBase
    - MMIO High Size
    - Isoc Mode
    - MeSeg Mode
    - Numa
- QPI Configuration
    - QPI General Configuration
        - QPI Status
        - Degrade Precedence
        - Link Frequency Select
        - Link L0p Enable
        - Link L1 Enable
        - Legacy VGA Socket
        - MMIO P2P Disable
        - E2E Parity Enable
        - COD Enable
        - Early Snoop
        - Home Dir Snoop with IVT- Style OSB
        - QPI Debug Print Level
    - QPI Per Socket Configuration
        - CPU 0, CPU 1, CPU 2, CPU 3
            - Bus Resources Allocation Ratio
            - IO Resources Allocation Ratio
            - MMIOL Resources Allocation Ratio
            - IIO Disable
- Memory Configuration
    - Enforce POR
    - PPR Type
    - Memory Frequency
    - MRC Promote Warnings
    - Promote Warnings
    - Halt on mem Training Error
    - Multi-Threaded MRC
    - Enforce Timeout
    - Enhanced Log Parsing
    - BSSA Module Loading
    - Backside RMT
    - Rank Multiplication
    - LRDIMM Module Delay
    - MemTest
    - MemTestLoops
    - Dram Maintenance Test
    - Dram Maintenance Test Direction
    - Dram Maintenance Test Invertion
    - Dram Maintenance Test Repetitions
    - Dram Maintenance Test Interation o
    - Dram Maintenance Test Swizzle enabling
    - Dram Maintenance Test Refresh enabling
    - Memory Type
    - CECC WA CH mask
    - Rank Margin Tool
    - RMT Pattern Length
    - CMD Pattern Length
    - Per Bit Margin
    - Training Result Offset Config
    - Attempt Fast Boot
    - Attempt Fast Cold Boot
    - BDAT
    - Data Scrambling
    - Allow SBE during training
    - Platform type input for SPD page s
    - CAP ERR FLOW feature Control
    - Scrambling Seed Low
    - Scrambling Seed High
    - Enable ADR
    - MC BGF threshold
    - DLL Reset Test
    - MC ODT Mode
    - Opp read during WMM
    - Normal Operation Duration
    - Number of Sparing Transaction
    - PSMI Support
    - C/A Parity Enable
    - SMB Clock Frequency
    - Memory Topology
    - Memory Thermal
        - Set Throttling Mode
        - OLTT Peak BW %
        - Phase Shedding
        - Memory Power Savings Mode
        - Memory Power Savings Advanced Options
            - CK in SR
        - MDLL Off
        - MEMHOT Throttling Mode
        - Mem Electrical Throttling
    - Memory Timings & Voltage Override
        - DIMM profile
        - Memory Frequency
    - Memory Map
        - Socket Interleaving Below 4GB
        - Channel Interleaving
        - Rank Interleaving
        - IOT Memory Buffer Reservation
        - A7 Mode
    - Memory RAS Configuration
        - RAS Mode
        - Lockstep x4 DIMMs
        - Memory Rank Sparing
        - Correctable Error Threshold
        - Leaky bucket low bit
        - Leaky bucket hight bit
        - DRAM Maintenance
        - Patrol Scrub
        - Patrol Scrub Interval
        - Demand Scrub
        - Device Tagging
        - Memory Power Management
    - DIMM Rank Enable Mask
- IIO Configuration, IIO1 Configuration
    - PCIe Train by BIOS
    - PCIe Hot Plug
    - PCIe ACPI Hot Plug
    - EV DFX Features
    - IIO0 Configuration
        - IOU2 (IIO PCIe Port 1)
        - IOU0 (IIO PCIe Port 2)
        - IOU1 (IIO PCIe Port 3)
        - No PCIe port active EC0
        - Socket 0 PcieD00F0 - Port 0/DMI
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
        - Socket 0 PcieD01F0 - Port 1A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - Socket 0 PcieD02F0 - Port 2A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - Socket 0 PcieD03F0 - Port 3A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - IOU0 Non-Posted Prefetch
        - IOU1 Non-Posted Prefetch
        - IOU2 Non-Posted Prefetch
    - IIO1 Configuration
        - IOU2 (IIO PCIe Port 1)
        - IOU0 (IIO PCIe Port 2)
        - IOU1 (IIO PCIe Port 3)
        - No PCIe port active EC0
        - Socket 0 PcieD00F0 - Port 0/DMI
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - Socket 0 PcieD01F0 - Port 1A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - Socket 0 PcieD02F0 - Port 2A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Hide Port?
        - Socket 0 PcieD03F0 - Port 3A
            - PCI-E Port
            - Hot Plug Capable
            - Extra Bus Reserved
            - Reserved Memory
            - Reseved Memory Alignment
            - Prefetchable Memory
            - Prefetchable Memory Alignment
            - Reserved I/O
            - PCI-E Port Link
            - Link Speed
            - Override Max Link Width
            - PCI-E Port DeEmphasis
            - PCI-E Port Link Status
            - PCI-E Port Link Max
            - PCI-E Port Link Speed
            - PCI-E Port L0s Exit Latency
            - PCI-E Port L1 Exit Latency
            - Fatal Err Over
            - Non-Fatal Err Over
            - Corr Err Over
            - L0s Support
            - PM ACPI Mode
            - Gen3 Eq Mode
            - Gen3 Spec Mode
            - Gen3 Phase2 Mode
            - Gen3 DN Tx Preset
            - Gen3 DN Rx Preset
            - Gen3 UP Tx Preset
            - Non-Transparent Bridge PCIe Port D
            - Enable NTB BARs
            - Enable SPLIT BARs
            - Primary BAR 23 Size
            - Primary BAR 4 Size
            - Primary BAR 5 Size
            - Secondary BAR 23 Size
            - Secondary BAR 4 Size
            - Secondary BAR 5 Size
            - Crosslink control Override
            - Hide Port?
        - IOU0 Non-Posted Prefetch
        - IOU1 Non-Posted Prefetch
        - IOU2 Non-Posted Prefetch
    - IOAT Configuration
        - Enable IOAT
        - No Snoop
        - Disable TPH
        - Relaxed Ordering
        - Apply BDX CBDMA ECO
    - IIO General Configuration
        - IIOAPIC
    - Intel VT for Directed I/O (VT-d)
        - VTd Azalea VCp Optimizations
        - Intel VT for Directed I/O (VT-d)
        - ACS Control
        - Interrupt Remapping
        - Coherency Support (Non-Isoch)
        - Coherency Support (Isoch)
    - TX EQ WA
    - DMI Vc1 Control
    - DMI Vcp Control
    - DMI Vcm Control
    - VC0 No-Snoop Configuration
    - Gen3 Phase3 Loop Count
    - Skip Halt On SMI Degradation
    - Power down unused ports
    - SLD WA Revision
    - Rx Clock WA
    - PCI-E ASPM (Global)
    - PCIE Stop & Scream Support
    - Snoop Response Hold Off
- PCH Configuration
    - PCH Devices
        - Board Capability
        - DeepSx Power Policies
        - GP27 Wake From DeepSx
        - SMBUS Device
        - PCH Server Error Reporting Mode (S
        - PCH Display
        - Serial IRQ Mode
        - External SSC Enable - CK420
        - PCH state after G3
        - PCH CRID
    - PCH sSATA Configuration
        - sSATA Controller
        - Configure sSATA as
        - SATA test mode
        - SATA Mode options
            - SATA HDD Unlock
            - SATA Led locate
        - sSATA AHCI LPM
        - sSATA AHCI ALPM
        - sSATA Port 0, sSATA Port 1, sSATA Port 2, sSATA Port 3
            - Port 0
            - Hot Plug
            - Configure as eSATA
            - Mechanical Presence Switch
            - Spin Up Device
            - sSATA Device Type
    - PCH SATA Configuration
        - SATA Controller
        - Configure SATA as
        - SATA test mode
        - SATA Mode options
            - SATA HDD Unlock
            - SATA Led locate
        - SATA AHCI LPM
        - SATA AHCI ALPM
        - SATA Port 0, sSATA Port 1, sSATA Port 2, sSATA Port 3
            - Port 0
            - Hot Plug
            - Configure as eSATA
            - Mechanical Presence Switch
            - Spin Up Device
            - SATA Device Type
    - USB Configuration
        - USB Precondition
        - xHCI Mode
        - Trunk Clock Gating (BTCG)
        - USB Ports Per-Port Disable Control
        - XHCI Idle L1
        - USB XHCI s755 WA
        - USB XHCI Interrupt Remap WA
    - Security Configuration
        - GPIO Lockdown
        - RTC Lock
        - BIOS Lock
        - Host Flash Lock-Down
        - Gbe Flash Lock-Down

##### Security
- Administrator Password
- User Password

##### Boot
- Setup Prompt Timeout
- Bootup NumLock State
- Quiet Boot
- Boot Option Priorities

##### Save & Exit
- Save Changes and Exit
- Discard Changes and Exit
- Save Changes and Reset
- Discard Changes and Reset
- Save Changes
- Discard Changes
- Restore Defaults
- Save as User Defaults
- Restore User Defaults
- Boot Override

#### Additional Notes
If you're wondering what some of those options even do, looking though the manual of a similar X99 or C600 motherboard can help.
<br>
For example here's the [manual for a X10DRi-T4+](https://www.supermicro.com/manuals/motherboard/C600/MNL-1560.pdf#p73).