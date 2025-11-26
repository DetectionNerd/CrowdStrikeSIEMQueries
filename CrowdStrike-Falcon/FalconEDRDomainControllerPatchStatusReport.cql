#event_simpleName=InstalledUpdates
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| ProductType=2
| LastUpdateInstalledTime:=LastUpdateInstalledTime*1000 | LastUpdateInstalledTime:=formatTime(format="%Y-%m-%d, %H:%M:%S", field="LastUpdateInstalledTime", timezone="America/Los_Angeles")
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[LastUpdateInstalledTime, ComputerName, LocalAddressIP4, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds, aid, MAC])]))
| table([LastUpdateInstalledTime, ComputerName, LocalAddressIP4, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds, MAC, aid])
| sort(ComputerName, order=asc, limit=max)
