<%@ Language=JScript %>
<%Response.Buffer = true%>
<!--#include file=connstring.js-->
<%

function coalesce(str)
{
	if (str == null)
	{
		return "";
	}
	
	return str;
}

var strRowID = parseInt(Request.QueryString.Item("RowId"));

if(isNaN(strRowID))
{
	Response.Write("<body bgcolor='black' style='background-color:black;border:none;'>");
	Response.End();
}

strQuery = "SELECT * FROM SkatePix p, SkaterBios b, PixToBios s WHERE p.fileID = " + strRowID + " AND p.FileID = s.FileID and s.SkaterID = b.SkaterID";
OpenRS();

if (oRS.RecordCount < 1)
{
	Response.Write("<body bgcolor='black' style='background-color:black;border:none;'>");
	Response.End();
}



var strPark = oRS.Fields.Item("Park").Value;
var strTrickName = oRS.Fields.Item("TrickName").Value;
var strPhotographer = oRS.Fields.Item("Photographer").Value;
var strDate = oRS.Fields.Item("Date").Value;
var strDescription = oRS.Fields.Item("Description").Value;

var arrSkaters = new Array();
var nSkaterIterator = 0;
var strSkaterFirstName = "";
var strSkaterLastName = "";
var strSkaterAlias = "";

while (!oRS.EOF)
{
	strSkaterFirstName = oRS.Fields.Item("SkaterFirstName").Value;
	strSkaterLastName = oRS.Fields.Item("SkaterLastName").Value;
	strSkaterAlias = oRS.Fields.Item("SkaterAlias1").Value;
	strSkaterName = (null == strSkaterFirstName || "" == strSkaterFirstName) ? "" : strSkaterFirstName; 
	strSkaterName += (null == strSkaterLastName || "" == strSkaterLastName) ? "" : " " + strSkaterLastName; 
	strSkaterName += (null == strSkaterAlias || "" == strSkaterAlias) ? "" : " (" + strSkaterAlias + ")";
	
	arrSkaters[nSkaterIterator++] = strSkaterName;
	
	oRS.MoveNext();
}

%>
<html>
<head>
<link rel="stylesheet" href="stylesheets\dallett.css">
</head>
<body bgcolor="black" style="background-color:black;color:ivory;border:none;">
<p><%=strDescription%></p>
<B>Location:</b> <%=strPark%><br>
<B>Date:</b> <%=strDate%><br>
<B>Trick:</b> <%=strTrickName%><br>
<B>Photographer:</b> <%=strPhotographer%><br>
<B>Skater(s):</b> 
<UL>
<%
for(var arrIter = 0; arrIter < arrSkaters.length; arrIter++)
{
	Response.Write(arrSkaters[arrIter] + "<BR>");
}
%>
</UL>

</body>
</html>
