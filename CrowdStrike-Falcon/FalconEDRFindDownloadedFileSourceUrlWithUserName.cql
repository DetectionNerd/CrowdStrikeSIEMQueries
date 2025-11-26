defineTable(query={#event_simpleName=MotwWritten (ReferrerUrl!="" OR HostUrl!="")}, include=[aid, ContextProcessId, ZoneIdentifierName, FileName, TargetFileName, ReferrerUrl, HostUrl, FilePath, aip, ZoneIdentifier], name="downloaded_files") | #event_simpleName=ProcessRollup2 | match(file="downloaded_files", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[ZoneIdentifierName, FileName, TargetFileName, ReferrerUrl, HostUrl, FilePath, aip, ZoneIdentifier]) | lower("FileName", as=FileName) | upper("UserName", as=UserName)
// -------------------------------------------Modify as per the file, user or host you're searching for-------------------------------------------

| (FileName=*anydesk*

// -------------------------------------------Modify as per the file, user or host you're searching for-------------------------------------------
| case {
        ZoneIdentifier = "0"  | ZoneIdentifierName := "LOCAL MACHINE" ;
        ZoneIdentifier = "1"  | ZoneIdentifierName := "INTRANET" ;
        ZoneIdentifier = "2"  | ZoneIdentifierName := "TRUSTED SITES" ;
        ZoneIdentifier = "3"  | ZoneIdentifierName := "INTERNET" ;
        ZoneIdentifier = "4"  | ZoneIdentifierName := "RESTRICTED SITES" ;
        * }
| groupBy([aid, ComputerName, TargetProcessId], function=([collect([timestamp, UserName, ComputerName, LocalAddressIP4, ZoneIdentifierName, FileName, TargetFileName, ReferrerUrl, HostUrl, FilePath, CommandLine, aip, ZoneIdentifier, aid])]), limit=max)
| sort(field=timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| table([PacificTime, UserName, ComputerName, LocalAddressIP4, ZoneIdentifierName, FileName, ReferrerUrl, HostUrl, TargetFileName, FilePath, CommandLine, aip, ZoneIdentifier, aid], limit=max)
