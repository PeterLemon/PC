;----------------
; N64 Memory Map
;----------------

; MEM_MAP dq ? ; $00000000..$1FFFFFFF MEM_MAP

RDRAM              = $00000000 ; $00000000..$003FFFFF RDRAM Memory

RDRAM_BASE         = $03F00000 ; $03F00000..$03F00027 RDRAM Base Register
RDRAM_DEVICE_TYPE  = $03F00000 ; $03F00000..$03F00003 RDRAM: Device Type Register
RDRAM_DEVICE_ID    = $03F00004 ; $03F00004..$03F00007 RDRAM: Device ID Register
RDRAM_DELAY        = $03F00008 ; $03F00008..$03F0000B RDRAM: Delay Register
RDRAM_MODE         = $03F0000C ; $03F0000C..$03F0000F RDRAM: Mode Register
RDRAM_REF_INTERVAL = $03F00010 ; $03F00010..$03F00013 RDRAM: Ref Interval Register
RDRAM_REF_ROW      = $03F00014 ; $03F00014..$03F00017 RDRAM: Ref Row Register
RDRAM_RAS_INTERVAL = $03F00018 ; $03F00018..$03F0001B RDRAM: RAS Interval Register
RDRAM_MIN_INTERVAL = $03F0001C ; $03F0001C..$03F0001F RDRAM: Minimum Interval Register
RDRAM_ADDR_SELECT  = $03F00020 ; $03F00020..$03F00023 RDRAM: Address Select Register
RDRAM_DEVICE_MANUF = $03F00024 ; $03F00024..$03F00027 RDRAM: Device Manufacturer Register

SP_MEM_BASE = $04000000 ; $04000000..$04000FFF SP MEM Base Register
SP_DMEM     = $04000000 ; $04000000..$04000FFF SP: RSP DMEM (4096 Bytes)
SP_IMEM     = $04001000 ; $04001000..$04001FFF SP: RSP IMEM (4096 Bytes)

SP_BASE      = $04040000 ; $04040000..$0404001F SP Base Register
SP_MEM_ADDR  = $04040000 ; $04040000..$04040003 SP: Master, SP Memory Address Register
SP_DRAM_ADDR = $04040004 ; $04040004..$04040007 SP: Slave, SP DRAM DMA Address Register
SP_RD_LEN    = $04040008 ; $04040008..$0404000B SP: Read DMA Length Register
SP_WR_LEN    = $0404000C ; $0404000C..$0404000F SP: Write DMA Length Register
SP_STATUS    = $04040010 ; $04040010..$04040013 SP: Status Register
SP_DMA_FULL  = $04040014 ; $04040014..$04040017 SP: DMA Full Register
SP_DMA_BUSY  = $04040018 ; $04040018..$0404001B SP: DMA Busy Register
SP_SEMAPHORE = $0404001C ; $0404001C..$0404001F SP: Semaphore Register

SP_PC_BASE = $04080000 ; $04080000..$04080007 SP PC Base Register
SP_PC      = $04080000 ; $04080000..$04080003 SP: PC Register
SP_IBIST   = $04080004 ; $04080004..$04080007 SP: IMEM BIST Register

DPC_BASE     = $04100000 ; $04100000..$0410001F DP Command (DPC) Base Register
DPC_START    = $04100000 ; $04100000..$04100003 DPC: CMD DMA Start Register
DPC_END      = $04100004 ; $04100004..$04100007 DPC: CMD DMA End Register
DPC_CURRENT  = $04100008 ; $04100008..$0410000B DPC: CMD DMA Current Register
DPC_STATUS   = $0410000C ; $0410000C..$0410000F DPC: CMD Status Register
DPC_CLOCK    = $04100010 ; $04100010..$04100013 DPC: Clock Counter Register
DPC_BUFBUSY  = $04100014 ; $04100014..$04100017 DPC: Buffer Busy Counter Register
DPC_PIPEBUSY = $04100018 ; $04100018..$0410001B DPC: Pipe Busy Counter Register
DPC_TMEM     = $0410001C ; $0410001C..$0410001F DPC: TMEM Load Counter Register

DPS_BASE         = $04200000 ; $04200000..$0420000F DP Span (DPS) Base Register
DPS_TBIST        = $04200000 ; $04200000..$04200003 DPS: TMEM Bist Register
DPS_TEST_MODE    = $04200004 ; $04200004..$04200007 DPS: Span Test Mode Register
DPS_BUFTEST_ADDR = $04200008 ; $04200008..$0420000B DPS: Span Buffer Test Address Register
DPS_BUFTEST_DATA = $0420000C ; $0420000C..$0420000F DPS: Span Buffer Test Data Register

MI_BASE      = $04300000 ; $04300000..$0430000F MIPS Interface (MI) Base Register
MI_INIT_MODE = $04300000 ; $04300000..$04300003 MI: Init Mode Register
MI_VERSION   = $04300004 ; $04300004..$04300007 MI: Version Register
MI_INTR      = $04300008 ; $04300008..$0430000B MI: Interrupt Register
MI_INTR_MASK = $0430000C ; $0430000C..$0430000F MI: Interrupt Mask Register

VI_BASE           = $04400000 ; $04400000..$04400037 Video Interface (VI) Base Register
VI_STATUS         = $04400000 ; $04400000..$04400003 VI: Status/Control Register
VI_ORIGIN         = $04400004 ; $04400004..$04400007 VI: Origin Register
VI_WIDTH          = $04400008 ; $04400008..$0440000B VI: Width Register
VI_V_INTR         = $0440000C ; $0440000C..$0440000F VI: Vertical Interrupt Register
VI_V_CURRENT_LINE = $04400010 ; $04400010..$04400013 VI: Current Vertical Line Register
VI_TIMING         = $04400014 ; $04400014..$04400017 VI: Video Timing Register
VI_V_SYNC         = $04400018 ; $04400018..$0440001B VI: Vertical Sync Register
VI_H_SYNC         = $0440001C ; $0440001C..$0440001F VI: Horizontal Sync Register
VI_H_SYNC_LEAP    = $04400020 ; $04400020..$04400023 VI: Horizontal Sync Leap Register
VI_H_VIDEO        = $04400024 ; $04400024..$04400027 VI: Horizontal Video Register
VI_V_VIDEO        = $04400028 ; $04400028..$0440002B VI: Vertical Video Register
VI_V_BURST        = $0440002C ; $0440002C..$0440002F VI: Vertical Burst Register
VI_X_SCALE        = $04400030 ; $04400030..$04400033 VI: X-Scale Register
VI_Y_SCALE        = $04400034 ; $04400034..$04400037 VI: Y-Scale Register

AI_BASE      = $04500000 ; $04500000..$04500017 Audio Interface (AI) Base Register
AI_DRAM_ADDR = $04500000 ; $04500000..$04500003 AI: DRAM Address Register
AI_LEN       = $04500004 ; $04500004..$04500007 AI: Length Register
AI_CONTROL   = $04500008 ; $04500008..$0450000B AI: Control Register
AI_STATUS    = $0450000C ; $0450000C..$0450000F AI: Status Register
AI_DACRATE   = $04500010 ; $04500010..$04500013 AI: DAC Sample Period Register
AI_BITRATE   = $04500014 ; $04500014..$04500017 AI: Bit Rate Register

PI_BASE         = $04600000 ; $04600000..$04600033 Peripheral Interface (PI) Base Register
PI_DRAM_ADDR    = $04600000 ; $04600000..$04600003 PI: DRAM Address Register
PI_CART_ADDR    = $04600004 ; $04600004..$04600007 PI: PBUS (Cartridge) Address Register
PI_RD_LEN       = $04600008 ; $04600008..$0460000B PI: Read Length Register
PI_WR_LEN       = $0460000C ; $0460000C..$0460000F PI: Write Length Register
PI_STATUS       = $04600010 ; $04600010..$04600013 PI: Status Register
PI_BSD_DOM1_LAT = $04600014 ; $04600014..$04600017 PI: Domain 1 Latency Register
PI_BSD_DOM1_PWD = $04600018 ; $04600018..$0460001B PI: Domain 1 Pulse Width Register
PI_BSD_DOM1_PGS = $0460001C ; $0460001C..$0460001F PI: Domain 1 Page Size Register
PI_BSD_DOM1_RLS = $04600020 ; $04600020..$04600023 PI: Domain 1 Release Register
PI_BSD_DOM2_LAT = $04600024 ; $04600024..$04600027 PI: Domain 2 Latency Register
PI_BSD_DOM2_PWD = $04600028 ; $04600028..$0460002B PI: Domain 2 Pulse Width Register
PI_BSD_DOM2_PGS = $0460002C ; $0460002C..$0460002F PI: Domain 2 Page Size Register
PI_BSD_DOM2_RLS = $04600030 ; $04600030..$04600033 PI: Domain 2 Release Register

RI_BASE         = $04700000 ; $04700000..$0470001F RDRAM Interface (RI) Base Register
RI_MODE         = $04700000 ; $04700000..$04700003 RI: Mode Register
RI_CONFIG       = $04700004 ; $04700004..$04700007 RI: Config Register
RI_CURRENT_LOAD = $04700008 ; $04700008..$0470000B RI: Current Load Register
RI_SELECT       = $0470000C ; $0470000C..$0470000F RI: Select Register
RI_REFRESH      = $04700010 ; $04700010..$04700013 RI: Refresh Register
RI_LATENCY      = $04700014 ; $04700014..$04700017 RI: Latency Register
RI_RERROR       = $04700018 ; $04700018..$0470001B RI: Read Error Register
RI_WERROR       = $0470001C ; $0470001C..$0470001F RI: Write Error Register

SI_BASE           = $04800000 ; $04800000..$0480001B Serial Interface (SI) Base Register
SI_DRAM_ADDR      = $04800000 ; $04800000..$04800003 SI: DRAM Address Register
SI_PIF_ADDR_RD64B = $04800004 ; $04800004..$04800007 SI: Address Read 64B Register
;*RESERVED*       = $04800008 ; $04800008..$0480000B SI: Reserved Register
;*RESERVED*       = $0480000C ; $0480000C..$0480000F SI: Reserved Register
SI_PIF_ADDR_WR64B = $04800010 ; $04800010..$04800013 SI: Address Write 64B Register
;*RESERVED*       = $04800014 ; $04800014..$04800017 SI: Reserved Register
SI_STATUS         = $04800018 ; $04800018..$0480001B SI: Status Register

CART_DOM2_ADDR1 = $05000000 ; $05000000..$0507FFFF Cartridge Domain 2(Address 1) SRAM
CART_DOM1_ADDR1 = $06000000 ; $06000000..$07FFFFFF Cartridge Domain 1(Address 1) 64DD
CART_DOM2_ADDR2 = $08000000 ; $08000000..$0FFFFFFF Cartridge Domain 2(Address 2) SRAM
CART_DOM1_ADDR2 = $10000000 ; $10000000..$18000803 Cartridge Domain 1(Address 2) ROM
N64_ROM         = $10000000 ; $10000000..$18000803 N64 ROM

PIF_BASE  = $1FC00000 ; $1FC00000..$1FC007BF PIF Base Register
PIF_ROM   = $1FC00000 ; $1FC00000..$1FC007BF PIF: Boot ROM
PIF_RAM   = $1FC007C0 ; $1FC007C0..$1FC007FF PIF: RAM (JoyChannel)
PIF_HWORD = $1FC007C4 ; $1FC007C4..$1FC007C5 PIF: HWORD
PIF_XBYTE = $1FC007C6 ; $1FC007C6 PIF: Analog X Byte
PIF_YBYTE = $1FC007C7 ; $1FC007C7 PIF: Analog Y Byte

CART_DOM1_ADDR3 = $1FD00000 ; $1FD00000..$7FFFFFFF Cartridge Domain 1 (Address 3)

EXT_SYS_AD = $80000000 ; $80000000..$FFFFFFFF External SysAD Device