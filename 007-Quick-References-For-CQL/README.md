<h1><b>✨ Quick References for CrowdStrike Query Language</b></h1>
<hr>

<h2><b>1. Time </b></h2>
<h3><b>Convert Epoch Time to DD Month YYYY, HH:MM:SS</b></h3>
<span style="color:#00aa00;"><!-- //"America/Los_Angeles" ≅ PST; "America/Los_Angeles" ≅ EST (https://library.humio.com/data-analysis/syntax-time-timezones.html) --></span>
<pre><code>|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")</code></pre>

<h3><b>Convert MM/DD/YYYY, HH:MM:SS timestamp to Epoch Time, sort it and convert it back to DD Month YYYY, HH:MM:SS</b></h3>
<pre><code>| findTimestamp(field=VendorTimestamp, as=VendorEpochTime, timezone="America/Los_Angeles")
| sort(field=VendorEpochTime, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="VendorPacificTime", field="VendorEpochTime", timezone="America/Los_Angeles")</code></pre>

<h3><b>Convert any timestamp format to Epoch Time and then convert it back to DD Month YYYY, HH:MM:SS</b></h3>
<pre><code>| parseTimestamp(field="result.datetime")
|formatTime(format="%d %B %Y, %H:%M:%S", as="ScriptExecutionTime", timezone="America/Los_Angeles")</code></pre>
<hr>

<h3><b>Define search time window in the query</b></h3>
<pre><code>| setTimeInterval(start=7d, end=now)</code></pre>
<hr>

<h3><b>Sliding Time Window</b></h3>
<pre><code>slidingTimeWindow()</code></pre>
<hr>

<h2><b>2. IP Address </b></h2>
<h3><b>Geolocation</b></h3>
<span style="color:#00aa00;"><!-- //Use the fields - IP.country, IP.state, IP.city, IP.lat, IP.lon in  your table --></span>
<pre><code>| ipLocation(field=Vendor.ClientIP, as=IP)
| table([IP.Country, IP.State, IP.City])</code></pre>

<h3><b>Lookup the associated Autonomous System Number (ASN) and the Organization</b></h3>
<h5>The autonomous system number will be written as ip.asn, and organization name as ip.org.</h5>

<pre><code>| asn(field=ip, as=ip
| table([ip.org, ip.asn])</code></pre>
<hr>

<h2><b>3. Rename</b></h2>
<pre><code>| rename("Vendor.response_code", as="ResponseCode")</code></pre>
<hr>

<h2><b>4. Change Text Case</b></h2>
<h3><b>Uppercase</b></h3>
<pre><code>| upper("Vendor.SHA256Hash", as=SHA256Hash)</code></pre>

<h3><b>Lowercase</b></h3>
<pre><code>| lower("Vendor.SHA256Hash", as=SHA256Hash)</code></pre>
<hr>

<h2><b>5. CIDR</b></h2>
<h3><b>Match CIDR</b></h3>
<pre><code>| cidr(aip, subnet=["120.120.120.120/24"])</code></pre>

<h3><b>Exclude CIDR</b></h3>
<pre><code>| !cidr(aip, subnet=["120.120.120.120/24"])</code></pre>

<h3><b>Add Network Type column using CIDR match inside case</b></h3>
<pre><code>| case {
	cidr(field=aip, subnet=["120.120.120.120/24", "120.120.120.120/24"]) | NetworkType := "VPN";
	cidr(field=aip, subnet=["120.120.120.120/23"]) | NetworkType := "Prod";
	* | NetworkType := "External";
    }
</code></pre>

<h3><b>Compare event IP fields with CIDR ranges in lookup table using the match() function with mode parameter</b></h3>
<pre><code>| case {
	cidr(field=aip, subnet=["120.120.120.120/24", "120.120.120.120/24"]) | NetworkType := "VPN";
	cidr(field=aip, subnet=["120.120.120.120/23"]) | NetworkType := "Prod";
	* | NetworkType := "External";
    }
</code></pre>
<hr>

<h2><b>6. Replace</b></h2>
<pre><code>| replace("_", with="@", field=Vendor.UserId, as="UserId")</code></pre>
<hr>

<h2><b>7. RegEx </b></h2>
<h3><b>Captures the username portion of an email address by matching alphanumeric characters and hyphens preceding an @ symbol</b></h3>
<pre><code>| regex("(?<Vendor./UserName>[a-zA-Z0-9.-]+)\s*@", field=Vendor.UserId, strict=false)</code></pre>

<h3><b>Extract string between first = (equal sign) and first , (comma)</b></h3>
<pre><code>| regex("^[^=]+=(?<TargetAccount>[^,]+)", field=windows.EventData.MemberName, strict=false)</code></pre>
<hr>

<h2><b>8. Case (convert specific field value to a custom string)</b></h2>
<pre><code>| case {
        LogonType = "2"  | LoginType := "Interactive" ;
        LogonType = "3"  | LoginType := "Network" ;
        * }</code></pre>
<hr>

<h2><b>9. Add a new field/column with an embedded link</b></h2>
<pre><code>| rootURL := "https://security.microsoft.com/quarantine?viewid=Files"<br><br>
| format("[Link To View Or Release File](%s)", field=[rootURL], as="M365Defender")</code></pre>
<hr>

<h2><b>10. Combine values from two fields into one</b></h2>
<pre><code>| format(format="%s, %s", field=[Vendor.EventLog.Date, Vendor.EventLog.Time], as="VendorTimestamp")</code></pre>
<hr>

<h2><b>11. Dashboard </b></h2>
<h3><b>Ignore case for dashboard input</b></h3>
<pre><code>| Vendor.user.name =~wildcard(?UserName, ignoreCase=true)</code></pre>

<h3><b>Sub-string search</b></h3>
<pre><code>| text:contains(string=@rawstring, substring=?UserName)</code></pre>

<h3><b>Plot IP locations on a world map widget</b></h3>
<pre><code>| worldMap(lat=source.ip.lat, lon=source.ip.lon)</code></pre>
<hr>

<h2><b>12. IOC Lookup </b></h2>
<h3><b>Enrich events with IP, Domain or URL lookup info from CrowdStrike's curated database of IOCs </b></h3>
<h5><b>IP</b></h5>
<pre><code>| ioc:lookup(field=Vendor.access_device.ip, type=ip_address, confidenceThreshold=unverified, strict=false, prefix=ip1ioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this IP", field="ip1ioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedIP1", field="ip1ioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedIP1", field="ip1ioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="ip1.asn", as="AsnIP1") | rename(field="ip1ioc.detected", as="IOCDetectedIP1") | rename(field="ip1ioc[0].indicator", as="IocIP1") | rename(field="ip1ioc[0].malicious_confidence", as="IOCConfidenceIP1") | rename(field="ip1ioc[0].labels", as="IOCLabelsIP1")
| table([IOCDetectedIP1, IocIP1, IOCLastUpdatedIP1, IOCConfidenceIP1, IOCLabelsIP1, IOCPublishedIP1])</code></pre>

<h5><b>Domain</b></h5>
<pre><code>| ioc:lookup(field=user.domain, type=domain, confidenceThreshold=unverified, strict=false, prefix=domainioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this Domain", field="domainioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedDomain", field="domainioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedDomain", field="domainioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="domainioc.detected", as="IOCDetectedDomain") | rename(field="domainioc[0].indicator", as="IOCDomain") | rename(field="domainioc[0].malicious_confidence", as="IOCConfidenceDomain") | rename(field="domainioc[0].labels", as="IOCLabelsDomain")
| table([IOCDetectedDomain, IOCDomain, IOCLastUpdatedDomain, IOCConfidenceDomain, IOCLabelsDomain, IOCPublishedDomain])</code></pre>

<h5><b>URL</b></h5>
<pre><code>| ioc:lookup(field=url, type=url, confidenceThreshold=unverified, strict=false, prefix=URLioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this URL", field="URLioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedURL", field="URLioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedURL", field="URLioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="URLioc.detected", as="IOCDetectedURL") | rename(field="URLioc[0].indicator", as="IocURL") | rename(field="URLioc[0].malicious_confidence", as="IOCConfidenceURL") | rename(field="URLioc[0].labels", as="IOCLabelsURL")
| table([IOCDetectedURL, IocURL, IOCLastUpdatedURL, IOCConfidenceURL, IOCLabelsURL, IOCPublishedURL])</code></pre>
<hr>
