#event_simpleName=*
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp])]))
| timeDelta:=now()-@timestamp
| lastCheckinHrs:=timeDelta/1000/60/60
| lastCheckinHrs:=round("lastCheckinHrs")
| test(lastCheckinHrs>1)
| lastCheckinAgo:=formatDuration(field=timeDelta, precision=3)
| join(query={#repo=sensor_metadata #data_source_name=aidmaster #data_source_group=aidmaster-api}, field=[aid], include=[ProductType, ComputerName, Version, MachineDomain, OU, SiteName], mode=left)
| in(field="ProductType", values=[2])
| default(value="-", field=[ProductType, ComputerName, Version, MachineDomain, OU, SiteName], replaceEmpty=true)
|formatTime(format="%d %B %Y, %H:%M:%S", as="StatusReportedAt", field="@timestamp", timezone="America/Los_Angeles")
| table([StatusReportedAt, ComputerName, lastCheckinAgo, ComputerName, Version, aid], limit=max)
| $falcon/helper:enrich(field=ProductType)
| rename("ComputerName", as="HostName")
