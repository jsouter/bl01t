cd "$(TOP)"

dbLoadDatabase "dbd/ioc.dbd"
ioc_registerRecordDeviceDriver(pdbbase)

# simDetectorConfig(portName, maxSizeX, maxSizeY, dataType, maxBuffers, maxMemory)
simDetectorConfig("hqv85942.CAM", 2560, 2160, 1, 50, 0)

# NDPvaConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, pvName, maxMemory, priority, stackSize)
NDPvaConfigure("hqv85942.PVA", 2, 0, "hqv85942.CAM", 0, "hqv85942-EA-TST-01:IMAGE", 0, 0, 0)
startPVAServer

# instantiate Database records for Sim Detector
dbLoadRecords (simDetector.template, "P=hqv85942-EA-TST-01, R=:CAM:, PORT=hqv85942.CAM, TIMEOUT=1, ADDR=0")
dbLoadRecords (NDPva.template, "P=hqv85942-EA-TST-01, R=:PVA:, PORT=hqv85942.PVA, ADDR=0, TIMEOUT=1, NDARRAY_PORT=hqv85942.CAM, NDARRAY_ADR=0, ENABLED=1")
# also make Database records for DEVIOCSTATS
dbLoadRecords(iocAdminSoft.db, "IOC=hqv85942-EA-IOC-01")
dbLoadRecords(iocAdminScanMon.db, "IOC=hqv85942-EA-IOC-01")

# start IOC shell
iocInit

# poke some records
dbpf "hqv85942-EA-TST-01:CAM:AcquirePeriod", "0.1"
