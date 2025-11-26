#event_simpleName=Event_RemoteResponseSessionEndEvent
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="UTCTimestamp", timezone="America/Los_Angeles")
| rename("AgentIdString", as="aid")
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| table([PacificTime, #event_simpleName, UserName, HostnameField, LocalAddressIP4, MAC, aip, Version, aid, Commands[0],
Commands[1],
Commands[2],
Commands[3],
Commands[4],
Commands[5],
Commands[6],
Commands[7],
Commands[8],
Commands[9],
Commands[10]
], limit=max)
| rename("#event_simpleName", as="EventType")
| rename("HostnameField", as="HostName")
| rename("aip", as="HostPublicIP")
| rename("aid", as="AgentID")
