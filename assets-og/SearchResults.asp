<%@ Language=JScript %>
<%Response.Buffer = true%>
<!--#include file=connstring.js-->
<%

//Response.Write(Request.QueryString + "<BR>");

var strSkaterID = Request.QueryString.Item("oSkaterID");
var strPark = Request.QueryString.Item("oPark");
var strNickName = Request.QueryString.Item("oNickName");
var strTrickName = Request.QueryString.Item("oTrickName");
var strMediaType = Request.QueryString.Item("oMediaType");
var strStartDate = Request.QueryString.Item("oStartDate");
var strEndDate = Request.QueryString.Item("oEndDate");
var strUnsorted = Request.QueryString.Item("unsorted");

if(strUnsorted == "on")
{
	var strQuery = "SELECT p.*, 'Untagged' as firstname, 'Skater' as lastname, '' as nickname FROM skatepix p WHERE p.httpPath IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PixToBios WHERE PixToBios.FileId = p.FileID)";
}
else
{
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
}


strQuery += " ORDER BY mediatype, date, httppath DESC";


//Response.Write("<div style='font-weight:bold;'>" + strQuery + "</div>");
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
<title>Search Results</title>
<link rel="stylesheet" href="stylesheets\dallett.css">
<Style type="text/css">
A
{
	color:#129AEE;
}

</Style>
</head>
<body style='background-color:black;border:none;'>
<IFrame src="blankblackpage.htm" name="oImg" id="oImg" style="position:absolute;top:35;left:470;height:600px;width:500px;border:none;"></IFrame>
<%

if(oRS.EOF)
{
  Response.Write("<H3 style='color:#008000;'>No records found.</H3>");
  Response.End();
}

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
if(strUnsorted == "on")
{
	Response.Write("<div style='color:#FF0000;font-weight:bold;'>Showing only untagged photos<BR>query parameters are ignored</div>");
}
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

%>
<IFrame src="ImageInfo.asp" id=iFrmStats style="width:400;height:400;"></IFrame>
<!--#include file="dbcleanup.js"-->
</body>
</html>