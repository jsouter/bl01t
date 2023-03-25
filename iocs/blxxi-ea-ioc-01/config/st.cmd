cd "$(TOP)"

dbLoadDatabase "dbd/ioc.dbd"
ioc_registerRecordDeviceDriver(pdbbase)

# simDetectorConfig(portName, maxSizeX, maxSizeY, dataType, maxBuffers, maxMemory)
simDetectorConfig("BLXXI.CAM", 2560, 2160, 1, 50, 0)

# NDPvaConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, pvName, maxMemory, priority, stackSize)
NDPvaConfigure("BLXXI.PVA", 2, 0, "BLXXI.CAM", 0, "BLXXI-EA-TST-01:IMAGE", 0, 0, 0)
startPVAServer

# instantiate Database records for Sim Detector
dbLoadRecords (simDetector.template, "P=BLXXI-EA-TST-01, R=:CAM:, PORT=BLXXI.CAM, TIMEOUT=1, ADDR=0")
dbLoadRecords (NDPva.template, "P=BLXXI-EA-TST-01, R=:PVA:, PORT=BLXXI.PVA, ADDR=0, TIMEOUT=1, NDARRAY_PORT=BLXXI.CAM, NDARRAY_ADR=0, ENABLED=1")
# also make Database records for DEVIOCSTATS
dbLoadRecords(iocAdminSoft.db, "IOC=BLXXI-EA-IOC-01")
dbLoadRecords(iocAdminScanMon.db, "IOC=BLXXI-EA-IOC-01")

# start IOC shell
iocInit

# poke some records
dbpf "BLXXI-EA-TST-01:CAM:AcquirePeriod", "0.1"
