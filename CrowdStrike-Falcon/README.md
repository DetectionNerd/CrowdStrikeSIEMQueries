| Query File/Folder | Category |
|-----------|--------|
| [`1. FalconEDR ListOfUsersOnADevice`](./FalconEDRListOfUsersOnADevice.cql) |Login Events |
| [`2. FalconEDR ListOfDevicesUsedByAUser`](./FalconEDRListOfDevicesUsedByAUser.cql) |Login Events |
| [`3. FalconEDR UserRDPLogonEvents`](./FalconEDRUserRDPLogonEvents.cql) |Login Events |
| [`4. FalconEDR DomainControllerLoginEvents`](./FalconEDRDomainControllerLoginEvents.cql) |Login Events |
| [`5. FalconEDR UserAllLogonEvents`](./FalconEDRUserAllLogonEvents.cql) |Login Events |
| [`6. FalconEDR FindDownloadedFileSourceURL`](./FalconEDRFindDownloadedFileSourceURL.cql) |Internet/Network Activity |
| [`7. FalconEDR FindDownloadedFileSourceUrlWithUserName`](./FalconEDRFindDownloadedFileSourceUrlWithUserName.cql) |Internet/Network Activity |
| [`8. FalconEDR DnsEventsWithUserName`](./FalconEDRDnsEventsWithUserName.cql) |Internet/Network Activity |
| [`9. FalconEDR FirewallLogsWithUserName`](./FalconEDRFirewallLogsWithUserName.cql) |Internet/Network Activity |
| [`10. FalconEDR NetworkConnectionLogs`](./FalconEDRNetworkConnectionLogs.cql) |Internet/Network Activity |
| [`11. FalconEDR DomainControllerPatchStatusReport`](./FalconEDRDomainControllerPatchStatusReport.cql) |Windows Patching |
| [`12. FalconEDR ServerPatchStatusReport`](./FalconEDRServerPatchStatusReport.cql) |Windows Patching |
| [`13. FalconEDR Desktop-LaptopPatchStatusReport`](./FalconEDRDesktop-LaptopPatchStatusReport.cql) |Windows Patching |
| [`14. FalconEDR DevicesOnNon-CompliantOS`](./FalconEDRDevicesOnNon-CompliantOS.cql) |OS |
| [`15. FalconEDR VulnerabilityLogs`](./FalconEDRVulnerabilityLogs.cql) |Vulnerabilities |
| [`16. FalconEDR FalconForITQueryResults`](./FalconEDRFalconForITQueryResults.cql) |Falcon for IT |
| [`17. FalconEDR DCCsRemovalCodeRevealed`](./FalconEDRDCCsRemovalCodeRevealed.cql) |CS Removal Code Revealed |
| [`18. FalconEDR ServerCsRemovalCodeRevealed`](./FalconEDRServerCsRemovalCodeRevealed.cql) |CS Removal Code Revealed |
| [`19. FalconEDR DeviceCsRemovalCodeRevealed`](./FalconEDRDeviceCsRemovalCodeRevealed.cql) |CS Removal Code Revealed |
| [`20. FalconEDR DCNetworkContainRequested`](./FalconEDRDCNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`21. FalconEDR DCNetworkContained`](./FalconEDRDCNetworkContained.cql) |Network Containment (quarantine) |
| [`22. FalconEDR DCLiftNetworkContainRequested`](./FalconEDRDCLiftNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`23. FalconEDR DCNetworkContainLifted`](./FalconEDRDCNetworkContainLifted.cql) |Network Containment (quarantine) |
| [`24. FalconEDR ServerNetworkContainRequested`](./FalconEDRServerNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`25. FalconEDR ServerNetworkContained`](./FalconEDRServerNetworkContained.cql) |Network Containment (quarantine) |
| [`26. FalconEDR ServerLiftNetworkContainRequested`](./FalconEDRServerLiftNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`27. FalconEDR ServerNetworkContainLifted`](./FalconEDRServerNetworkContainLifted.cql) |Network Containment (quarantine) |
| [`28. FalconEDR DeviceNetworkContainRequested`](./FalconEDRDeviceNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`29. FalconEDR DeviceNetworkContained`](./FalconEDRDeviceNetworkContained.cql) |Network Containment (quarantine) |
| [`30. FalconEDR DeviceLiftNetworkContainRequested`](./FalconEDRDeviceLiftNetworkContainRequested.cql) |Network Containment (quarantine) |
| [`31. FalconEDR DeviceNetworkContainLifted`](./FalconEDRDeviceNetworkContainLifted.cql) |Network Containment (quarantine) |
| [`32. FalconEDR DCRtrSessionEnded`](./FalconEDRDCRtrSessionEnded.cql) |Falcon Real Time Response |
| [`33. FalconEDR DCRtrSessionStarted`](./FalconEDRDCRtrSessionStarted.cql) |Falcon Real Time Response |
| [`34. FalconEDR DCCsAccountRoleChanged`](./FalconEDRDCCsAccountRoleChanged.cql) |Falcon Admin |
| [`35. FalconEDR CrowdStrikeLoginSuccess`](./FalconEDRCrowdStrikeLoginSuccess.cql) |Falcon Console |
| [`36. FalconEDR MoreThanFiveCsLoginFails`](./FalconEDRMoreThanFiveCsLoginFails.cql) |Falcon Console |
| [`37. FalconEDR Non-USCrowdStrikeLogin`](./FalconEDRNon-USCrowdStrikeLogin.cql) |Falcon Console |
| [`38. FalconEDR DCOffline`](./FalconEDRDCOffline.cql) |Host Status |
| [`39. FalconEDR ServerOffline`](./FalconEDRServerOffline.cql) |Host Status |
| [`40. FalconEDR DCInRFM`](./FalconEDRDCInRFM.cql) |Host Status |
| [`41. FalconEDR ServerInRFM`](./FalconEDRServerInRFM.cql) |Host Status |
| [`42. FalconEDR DeviceInRFM`](./FalconEDRDeviceInRFM.cql) |Host Status |
| [`43. FalconEDR SensorHeartbeatEvents`](./FalconEDRSensorHeartbeatEvents.cql) |Host Status |
| [`44. FalconEDR DCTorActivity`](./FalconEDRDCTorActivity.cql) |Malicious DNS |
| [`45. FalconEDR EDRFreezeDetect`](./FalconEDREDRFreezeDetect.cql) |EDR Freeze |
| [`46. FalconEDR FailedLoginEvents`](./FalconEDRFailedLoginEvents.cql) |Failed Login Events |
| [`47. FalconEDR HostGeoLocations`](./FalconEDRHostGeoLocations.cql) |Device Geolocations |
| [`48. FalconEDR NonStandardDeviceOnProd`](./FalconEDRNonStandardDeviceOnProd.cql) |Device Location |
