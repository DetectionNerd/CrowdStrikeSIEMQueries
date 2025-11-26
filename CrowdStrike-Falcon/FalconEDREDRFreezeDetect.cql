// Look for process handles opening Falcon
#event_simpleName=FalconProcessHandleOpDetectInfo FileName="WerFaultSecure.exe"
// Check for command line switching signal
| GrandparentCommandLine=/\.exe"?\s+\d+\s+\d+$/ OR ParentCommandLine=/\.exe"?\s+\d+\s+\d+$/ OR CommandLine=/\.exe"?\s+\d+\s+\d+$/
// Create process lineage tree for easier reading
| ProcessLineage:=format(format="%s (%s)\n\t└ %s (%s)\n\t\t└ %s (%s)", field=[GrandparentImageFileName, GrandparentCommandLine, ParentImageFileName, ParentCommandLine, ImageFileName, CommandLine])
// Output deatils to table
| table([@timestamp, aid, ComputerName, ContextProcessId, ProcessLineage])


// Create direct link to Process Explorer - Uncomment the rootURL value that matches your cloud
| rootURL  := "https://falcon.us-2.crowdstrike.com//" /* US-2 */
| format("[Responsible Process](%sgraphs/process-explorer/tree?id=pid:%s:%s)", field=["rootURL", "aid", "ContextProcessId"], as="Process Explorer")
// Remove unnecessary fields
| drop([rootURL, ContextProcessId])
