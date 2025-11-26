#event_simpleName=MotwWritten | lower("FileName", as=FileName) | upper("UserName", as=UserName)
// ------------------------------------------Modify as per the file, user or host you're searching for------------------------------

| (FileName=*anydesk* OR ComputerName=PCTEST

// ------------------------------------------Modify as per the file, user or host you're searching for------------------------------

| case {
        ZoneIdentifier = "0"  | ZoneIdentifierName := "LOCAL MACHINE" ;
        ZoneIdentifier = "1"  | ZoneIdentifierName := "INTRANET" ;
        ZoneIdentifier = "2"  | ZoneIdentifierName := "TRUSTED SITES" ;
        ZoneIdentifier = "3"  | ZoneIdentifierName := "INTERNET" ;
        ZoneIdentifier = "4"  | ZoneIdentifierName := "RESTRICTED SITES" ;
        * }
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, ComputerName, LocalAddressIP4, UserName, ZoneIdentifierName, FileName, TargetFileName, ReferrerUrl, HostUrl, FilePath, aip, ZoneIdentifier, aid], limit=max)
|rename(field="aip", as="Public IP")
