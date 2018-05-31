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


var strQuery = "SELECT p.*, b.skaterfirstname as firstname, b.skaterlastname as lastname, b.skateralias1 as nickname FROM skatepix p, skaterbios b WHERE httpPath IS NOT NULL and p.skaterid = b.skaterid"

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



strQuery += " ORDER BY mediatype, date DESC";

//Response.Write("<div style=color:white;>" + strQuery + "</div>");
//Response.End();
	
OpenRS();

var nRecords = oRS.RecordCount;
var nIterator = 0;
var strThumbURL = "";
var strURL = "";
var g_nColumns = 3;
var nBytes = 0;

%>
<html>
<head>
<script language="jscript">
function coalesce(str)
{
	if (str == null || str == "null" || str == "null null")
	{
		return "";
	}
	
	return str;
}
function showStats(oImg)
{
	var oDate = new Date(coalesce(oImg.date))
	oStats.innerHTML = coalesce(oImg.description);
	oStats.innerHTML += "<BR><BR><B>Skater:</B> " + coalesce(oImg.skater) + " (" + coalesce(oImg.nickname) + ")";
	oStats.innerHTML += "<BR><B>Park:</B> " + coalesce(oImg.park);
	oStats.innerHTML += "<BR><B>Photographer:</B> " + coalesce(oImg.photographer);
	oStats.innerHTML += "<BR><B>Date:</B> " + (oDate.getMonth() + 1) + "/" + oDate.getDate() + "/" + oDate.getFullYear();
	oStats.innerHTML += "<BR><B>Trick:</B> " + coalesce(oImg.trick);
	
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
<body style='background-color:black;'>
<IFrame src="blankblackpage.htm" name="oImg" id="oImg" style="position:absolute;top:35;left:470;height:600px;width:500px;"></IFrame>
<%
Response.Write("<H3 style='color:ivory;'>" + nRecords + " items found.</H3>");
Response.Write("<Div style='background-color:black;border:#505050 solid 2px;border-right:#CCCCCC solid 2px;border-bottom:#CCCCCC solid 2px;padding:5px;width:450px;height:300px;overflow-y:auto;overflow-x:hidden;'>");

Response.Write("<Table><TR>");
while(!oRS.EOF)
{
	strThumbURL = oRS.Fields.Item("HttpThumbPath").Value;
	strURL = oRS.Fields.Item("HttpPath").Value;
	nColumnWidth = oRS.Fields.Item("layoutWidth").Value;
	strMediaType = oRS.Fields.Item("mediatype").Value;
	nBytes = oRS.Fields.Item("MediaSizeInBytes").Value;
	strSize = GetBestSizeString(nBytes);
	if(0 == (nIterator % g_nColumns))
	{
		Response.Write("</TR><TR>")
	}
	
	if("sequence" == strMediaType.toLowerCase())
	{
		Response.Write("</TR></Table><Table><TR>")
		Response.Write("<TD colspan=" + nColumnWidth + "><A target=\"oImg\" href=\"ImageDetail.asp?" + strURL+"\"><IMG onclick='showStats(this)' skater='" + oRS.Fields.Item("FirstName").Value + " " + oRS.Fields.Item("LastName").Value + "' nickname='" + oRS.Fields.Item("nickname").Value + "' park='" + oRS.Fields.Item("Park").Value + "' date='" + oRS.Fields.Item("Date").Value + "' trick='" + oRS.Fields.Item("TrickName").Value + "' photographer='" + oRS.Fields.Item("Photographer").Value + "' description=\"" + oRS.Fields.Item("description").Value + "\" style='border:none;' src=\"" + strThumbURL + "\"></A></TD>");
		Response.Write("</TR></Table><Table><TR>")
	}
	else if("video" == strMediaType.toLowerCase())
	{
		arrParts = strURL.split("/");
		strFileName = arrParts[arrParts.length - 1];
		Response.Write("</TR></Table><Table><TR>")
		Response.Write("<TD><A target=\"_new\" href=\"" + strURL + "\">" + strFileName + "</A> <span style='color:ivory;font-size:10pt;'> " + strSize + "</span></TD>");
		Response.Write("</TR></Table><Table><TR>")
		
	}
	else
	{
		Response.Write("<TD><A target=\"oImg\" href=\"ImageDetail.asp?" + strURL+"\"><IMG onclick='showStats(this)' skater='" + oRS.Fields.Item("FirstName").Value + " " + oRS.Fields.Item("LastName").Value + "' nickname='" + oRS.Fields.Item("nickname").Value + "' park='" + oRS.Fields.Item("Park").Value + "' date='" + oRS.Fields.Item("Date").Value + "' trick='" + oRS.Fields.Item("TrickName").Value + "' photographer='" + oRS.Fields.Item("Photographer").Value + "' description=\"" + oRS.Fields.Item("description").Value + "\" style='border:none;' src=\"" + strThumbURL + "\"></A></TD>");
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
<div id=oStats style="width:400;padding:20px;color:ivory;"></div>
<!--#include file="dbcleanup.js"-->
</body>
</html>