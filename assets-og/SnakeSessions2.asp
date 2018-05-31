<%@Language=JScript%>
<!--#include file=connstring.js-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Snake Sessions</title>
<!--link rel="stylesheet" href="stylesheets\dallett.css"-->
</head>
<body>
<!-- Searchframe -->
<form action="snakesessions2.asp" ztarget="resultsframe" ID="Form1">
	<table border="1" style='margin-top:0;' ID="Table1">
	<tr>
	<td colspan=2 style='background-color:#008000;padding:5px;border:2px solid #C00000;'><span style="font-size:18pt;font-weight:bold;color:#0000C0;display:block">Snake Sessions</span>Skate media database search</td>
		<td align="right"><b>Skater:</b></TD>
		<td><select name="oSkaterID" ID="Select1">
			<option value=0>All</option>
			<%
	// by name
	strQuery="SELECT DISTINCT skaterid, COALESCE(skaterfirstname,'') + ' ' + COALESCE(skaterlastname,'') + ' (' + COALESCE(SkaterAlias1,'') + ')' AS skatername FROM skaterbios WHERE (skaterfirstname IS NOT NULL) OR (skaterlastname IS NOT NULL) OR (skateralias1 IS NOT NULL) ORDER BY skatername";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<OPTION Value='" + oRS.Fields.Item("skaterid").Value + "'>" + oRS.Fields.Item("skatername").Value + "</OPTION>");
		oRS.MoveNext();
	}
	%>
		</select></td>
		<td align="right"><b>Park:</b></TD>
		<td colspan="3"><select name="oPark" ID="Select2">
			<option>All</option>
			<%
	strQuery="SELECT DISTINCT park FROM skatepix WHERE park IS NOT NULL ORDER BY park";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<OPTION>" + oRS.Fields.Item("Park").Value + "</OPTION>");
		oRS.MoveNext();
	}
%>
		</select></td>
</tr>
		
<tr>
	<td align="right"><B>Date Range:   FROM</b></TD> 
	<td><input type="text" name="oStartDate" ID="Text1"><B>TO</b> <input type="text" name="oEndDate" ID="Text2"></TD>

	<td align="right"><b>Trick:</b></TD>
			<td><select name="oTrickName" ID="Select3">
				<option>All</option>
				<%
	// by trickname
	strQuery="SELECT DISTINCT Trickname FROM skatepix WHERE Trickname IS NOT NULL ORDER BY Trickname";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<OPTION>" + oRS.Fields.Item("Trickname").Value + "</OPTION>");
		oRS.MoveNext();
	}
	
	strQuery = "SELECT MAX(date) as max, MIN(date) as min FROM SkatePix";
	OpenRS();
	
	var maxDate = oRS.Fields.Item("max").Value;
	var minDate = oRS.Fields.Item("min").Value;
%>
			</select></TD>
						
			<td align="right"><b>Media Type:</b></td>
		<td><select name="oMediaType" ID="Select4">
			<option>All</option>
			<%
	
	strQuery="SELECT DISTINCT Mediatype FROM skatepix WHERE Mediatype IS NOT NULL ORDER BY Mediatype";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<OPTION>" + oRS.Fields.Item("Mediatype").Value + "</OPTION>");
		oRS.MoveNext();
	}
%>
		</select> </TD><td><Input type=submit value="SEARCH" style="background-color:green;font-weight:bold;color:Ivory" ID="Submit1" NAME="Submit1"></td>
			</tr>
			</table>
			</form>
			<span zstyle='position:absolute;top:100;left:10;'><a target='_top' style='text-decoration:underline;color:#8080FF;' href="http://snake.kittycrack.net">BACK to snake.kittycrack.net</a></span>
			<!-- end searchframe -->
			
			<!-- results pane -->
			<%
if(Request.QueryString != "")
{
	var strSkaterID = Request.QueryString.Item("oSkaterID");
	var strPark = Request.QueryString.Item("oPark");
	var strNickName = Request.QueryString.Item("oNickName");
	var strTrickName = Request.QueryString.Item("oTrickName");
	var strMediaType = Request.QueryString.Item("oMediaType");
	var strStartDate = Request.QueryString.Item("oStartDate");
	var strEndDate = Request.QueryString.Item("oEndDate");



	var strQuery = "SELECT p.*, b.skaterfirstname as firstname, b.skaterlastname as lastname, b.skateralias1 as nickname FROM skatepix p, pixtobios s, skaterbios b WHERE p.httpPath IS NOT NULL and b.skaterid = s.skaterid and s.fileid = p.fileid"

	if(strPark != "All")
	{
		strQuery += " and park ='" + strPark + "'";
	}

	if(strMediaType != "All")
	{
		strQuery += " and mediatype='" + strMediaType + "'"; 
	}

	if(strSkaterID != "0")
	{
		strQuery += " and b.skaterID = " + strSkaterID ;
	}

	if(strTrickName != "All")
	{
		strQuery += " and TrickName = '" + strTrickName + "'";
	}

	if(strStartDate != "")
	{
		strQuery += " and Date >= '" + strStartDate + "'";
	}

	if(strEndDate != "")
	{
		strQuery += " and Date <= '" + strEndDate + "'";
	}



	strQuery += " ORDER BY mediatype, date, httppath DESC";

	//Response.Write("<div>" + strQuery + "</div>");
	//Response.End();
		
	OpenRS();

	var nRecords = 0;
	var nIterator = 0;
	var strThumbURL = "";
	var strURL = "";
	var strLastURL = "";
	var g_nColumns = 3;
	var nBytes = 0;
	var nRowID = 0;



	%>
	<html>
	<head>
	<script language="jscript">

	function showStats(imgTag)
	{
		document.all.iFrmStats.src = "ImageInfo.asp?RowId=" + imgTag.RowId;
	}
	</script>
	<!--title>Search Results</title-->
	<!--link rel="stylesheet" href="stylesheets\dallett.css">
	<Style type="text/css">
	A
	{
		color:#129AEE;
	}

	</Style>
	</head>
	<body style='background-color:black;border:none;'-->
	<!--IFrame src="blankblackpage.htm" name="oImg" id="oImg" style="position:absolute;top:35;left:470;height:600px;width:500px;border:none;"></IFrame-->
	<%
	while(!oRS.EOF)
	{
		// Get an accurate count of records (duplicates removed)
		strURL = oRS.Fields.Item("HttpPath").Value;
		if(strURL == strLastURL)
		{
			// skip duplicates
			oRS.MoveNext();
			continue;
		}
		strLastURL = strURL;
		nRecords++;
	}

	strURL = "";
	strLastURL = "";


	Response.Write("<H3 style='color:#008000;'>" + nRecords + " items found.</H3>");
	Response.Write("<Div style='background-color:black;border:#505050 solid 2px;border-right:#CCCCCC solid 2px;border-bottom:#CCCCCC solid 2px;padding:5px;width:450px;height:300px;overflow-y:auto;overflow-x:hidden;'>");

	Response.Write("<Table><TR>");

	oRS.MoveFirst();
	while(!oRS.EOF)
	{
		// items are sorted by httpPath - this should prevent showing duplicates
		strThumbURL = oRS.Fields.Item("HttpThumbPath").Value;
		strURL = oRS.Fields.Item("HttpPath").Value;
		if(strURL == strLastURL)
		{
			// skip duplicates
			oRS.MoveNext();
			continue;
		}
		strLastURL = strURL;
		
		
		nColumnWidth = oRS.Fields.Item("layoutWidth").Value;
		strMediaType = oRS.Fields.Item("mediatype").Value;
		nBytes = oRS.Fields.Item("MediaSizeInBytes").Value;
		strSize = GetBestSizeString(nBytes);
		nRowID = oRS.Fields.Item("FileID").Value;
		
		if(0 == (nIterator % g_nColumns))
		{
			Response.Write("</TR><TR>")
		}
		
		if("sequence" == strMediaType.toLowerCase())
		{
			Response.Write("</TR></Table><Table><TR>")
			Response.Write("<TD colspan=" + nColumnWidth + "><A target=\"oImg\" href=\"ImageDetail.asp?" + strURL + "\"><IMG onclick='showStats(this)' RowId='" + nRowID + "' style='border:none;' src=\"" + strThumbURL + "\"></A></TD>");
			Response.Write("</TR></Table><Table><TR>")
		}
		else if("video" == strMediaType.toLowerCase())
		{
			arrParts = strURL.split("/");
			strFileName = arrParts[arrParts.length - 1];
			Response.Write("</TR></Table><Table><TR>")
			Response.Write("<TD><A target=\"oImg\" href=\"VideoDetail.asp?RowID=" + nRowID + "\">" + strFileName +  "</A> <span style=\"color:ivory;\">" + strSize + "</span></TD>");
			Response.Write("</TR></Table><Table><TR>")
			
		}
		else
		{
			Response.Write("<TD><A target=\"oImg\" href=\"ImageDetail.asp?" + strURL+"\"><IMG onclick='showStats(this)' RowId = '" + nRowID + "' style='border:none;' src=\"" + strThumbURL + "\"></A></TD>");
		}

		nIterator++;//= nColumns;
		oRS.MoveNext();
	}

	Response.Write("</TR></Table></div>");

	function GetBestSizeString(nBytes)
	{
		var strReturn = "(";
		var nUnits = 0;
		var strUnit = "";
		var nMegabyte = 1048576;
		var nKiloByte = 1024;
		
		if (nBytes >= nMegabyte)
		{
			strUnit = "MB";
			nUnits = Math.round(nBytes/nMegabyte);
		}
		else if(nBytes >= nKiloByte)
		{
			strUnit = "KB";	
			nUnits = Math.round(nBytes/nKiloByte);				
		}
		else
		{
			strUnit = "Bytes";
			nUnit = nBytes;
		}
		
		strReturn += nUnits;
		strReturn += " " + strUnit + ")";
		return strReturn;

	}
} // END if querystring is not blank
%>
<!--IFrame src="ImageInfo.asp" id=iFrmStats style="width:400;height:400;"></IFrame-->
			
			<!-- end results pane-->
	<!--#include file="dbcleanup.js"-->
</body>

</html>
