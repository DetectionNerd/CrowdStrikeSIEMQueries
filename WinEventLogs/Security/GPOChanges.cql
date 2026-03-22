#repo = "3pi_windows_ad" (windows.EventID=5136 OR windows.EventID=5137 OR windows.EventID=5141)
| case {
        windows.EventID = 5136 | GPOAction := "Modified";
        windows.EventID = 5137 | GPOAction := "Created";
        windows.EventID = 5141 | GPOAction := "Deleted";
        * | Action := "--UndefinedAction--";
        }
| case {
windows.Keywords = 0x8020000000000000 | Result := "Success";
windows.Keywords = 0x8010000000000000 | Result := "Failure";
* | Result := "--Undefined Result--";
}
| upper("windows.Computer", as=windows.Computer)
| upper("windows.EventData.ObjectGUID", as=windows.EventData.ObjectGUID)
| replace("\{", with="", field=windows.EventData.ObjectGUID, as="windows.EventData.ObjectGUID")
| replace("\}", with="", field=windows.EventData.ObjectGUID, as="windows.EventData.ObjectGUID")
| upper("windows.EventData.SubjectUserName", as=windows.EventData.SubjectUserName)
| replace(".IKIGAI.COM", with="", field=windows.Computer, as="windows.Computer")
| parseTimestamp(field="windows.TimeCreated")
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", timezone="America/Los_Angeles")
| table([PacificTime, windows.EventData.TargetUserName, GPOAction, windows.EventData.SubjectUserName, Result, windows.EventData.ObjectGUID, windows.Computer, windows.EventID, windows.EventData.SubjectUserSid, windows.EventData.AttributeLDAPDisplayName, windows.EventData.OpCorrelationID, windows.EventData.ObjectDN, windows.EventData.ObjectClass], limit=max)
| rename(field="windows.EventData.SubjectUserName", as="ActionBy")
| rename(field="windows.EventData.ObjectGUID", as="GPO ID")
| rename(field="windows.EventData.SubjectUserSid", as="SourceAccountSID")
| rename(field="windows.EventID", as="EventID")
| rename(field="windows.Computer", as="LogSource")
| rename(field="windows.EventData.AttributeLDAPDisplayName", as="AttributeLDAPDisplayName")
| rename(field="windows.EventData.OpCorrelationID", as="CorrelationID")
| rename(field="windows.EventData.ObjectDN", as="ObjectDN")
| rename(field="windows.EventData.ObjectClass", as="ObjectClass")
