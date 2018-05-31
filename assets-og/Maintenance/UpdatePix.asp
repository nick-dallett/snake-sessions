<%@ Language=JScript %>
<%Response.Buffer = true;%>
<!--#include file="connstring.js"-->
<%

//Response.Write("Request: " + Request.Form + "<BR>");

//Response.Write("SkaterID: " + Request.Form("skaterid") + "<BR>");


var strSkaters = "" + Request.Form("skaterid");

if(-1 != strSkaters.indexOf(","))
{
	var arrSkaters = strSkaters.split(",");
}


// check if we need to do an update
var nRowID = Math.abs(Request.Form("fileid"));
var strDescription = Request.Form("description").item;

//Response.Write(typeof(strDescription));

if(!isNaN(nRowID))
{

try
{
	strQuery = "SET XACT_ABORT ON;BEGIN TRANSACTION; UPDATE SkatePix"
	//strQuery += " SET skaterid=" + Request.Form("skaterid") + "";
	strQuery += " SET photographer='" + Request.Form("photographer") + "'";
	strQuery += ", trickname='" + Request.Form("trickname") + "'";
	strQuery += ", park='" + Request.Form("park") + "'";
	strQuery += ", mediatype='" + Request.Form("mediatype") + "'";
	strQuery += ", date='" + Request.Form("date") + "'";
	strQuery += ", description='" + SQLEscape(strDescription) + "'";
	strQuery += " WHERE fileid =" + nRowID;
	strQuery += ";DELETE FROM PixToBios WHERE FileID = " + nRowID + ";";
	
	
	if(null != arrSkaters)
	{
		for (var iter = 0; iter < arrSkaters.length; iter++)
		{
			strQuery += "INSERT INTO PixToBios(FileID,SkaterID) VALUES(" + nRowID + "," + arrSkaters[iter] + ");";
		}
	}
	else
	{
		if(null != strSkaters)
		{
			strQuery += "INSERT INTO PixToBios(FileID,SkaterID) VALUES(" + nRowID + "," + strSkaters + ");"; 
		}
	}
	
	strQuery += "COMMIT TRANSACTION;";	
	
	//Response.Write("Query:" + strQuery + "<BR>");
	//Response.End;

	oConn.Execute(strQuery);

	
	Response.Write("Updated row " + nRowID + "<BR>");
	}
	catch(e)
	{
		Response.Write("Error:" + e.description);
	}
}


// skater object
function fnSkater()
{
	this.name = "";
	this.id = 0;
}

//Get the count of files to be updated
strQuery="SELECT COUNT(FileID) as cRemaining FROM SkatePix WHERE Park IS NULL OR TrickName IS NULL OR NOT EXISTS(SELECT * FROM PixToBios WHERE PixToBios.FileID = Skatepix.fileid)";
OpenRS();

var cRemaining = oRS.Fields.Item("cRemaining").Value;
Response.Write("<BR>" + cRemaining + " shots left to update<BR>");

// Get the list of skater names
strQuery = "SELECT * from skaterbios ORDER BY skaterfirstname, skaterlastname";
OpenRS();

var skaterIterator = 0;
var arrSkaters = new Array();
while(!oRS.EOF)
{
	arrSkaters[skaterIterator] = new fnSkater();
	arrSkaters[skaterIterator].name = coalesce(oRS.Fields.Item("skaterFirstName").Value)	 + " " + coalesce(oRS.Fields.Item("skaterLastName").Value) + " (" + coalesce(oRS.Fields.Item("skaterAlias1").Value) + ")";
	arrSkaters[skaterIterator].id = oRS.Fields.Item("skaterID").Value;	
	
	skaterIterator++;
	oRS.MoveNext();
}

// Select next picture
strQuery="SELECT TOP 1 * FROM SkatePix WHERE Park IS NULL OR TrickName IS NULL OR NOT EXISTS(SELECT * FROM PixToBios WHERE PixToBios.FileID = Skatepix.fileid)";
OpenRS();

if (oRS.RecordCount < 1)
{
	Response.Write("No records to update");
	Response.End();
}

// cache picture attributes
var strPhotographer = oRS.Fields.Item("Photographer").Value;
var strTrickName = oRS.Fields.Item("TrickName").Value;
var strPark = oRS.Fields.Item("Park").Value;
var strDate = oRS.Fields.Item("Date").Value;
var strMediaType = oRS.Fields.Item("MediaType").Value;
var strDescription = oRS.Fields.Item("Description").Value;
var nFileID = oRS.Fields.Item("FileID").Value;
var strHttpPath = oRS.Fields.Item("httpPath").Value;
var strHttpThumbPath = oRS.Fields.Item("HttpThumbPath").Value;

//Get the list of skaters associated with the current picture
strQuery = "SELECT DISTINCT SkaterID FROM PixToBios WHERE FileID=" + nFileID;
OpenRS();


function coalesce(str)
{
	if(null == str || "null" == str)
	{
		return "";
	}
	
	return str;
}

function isInSkaterList(nID)
{
	//assumes that oRS contains the list of skaters associated with the current picture
	if(!oRS.BOF)
	{
		oRS.MoveFirst();
	}
	
	if(oRS.EOF)
	{
		return false;
	}
	
	while(!oRS.EOF)
	{
		//Response.Write("Comparing " + nID + " to " + oRS.Fields.Item("SkaterID").Value + "<BR>" );
		if(nID == oRS.Fields.Item("SkaterID").Value)	
		{
			return true;
		}
		oRS.MoveNext();
	}
	return false;
}
%>
<html>
<head>
</head>
<body>
<%
Response.Write("<A target=\"_new\" href=\"" + strHttpPath + "\"><IMG style='border:none;' src=\"" + strHttpThumbPath + "\"><BR>" + strHttpPath + "</A>");
%>
<form method=post action=updatepix.asp>
<table>
<tr>
<td>
<table>
<TR><TD><B>Photographer:</B></TD><TD><input type=text value="<%=strPhotographer%>" ID="Text3" NAME="photographer"></TD></tr>
<TR><TD><B>Park:</B></TD><TD><input type=text value="<%=strPark%>" ID="Text4" NAME="park"></TD></tr>
<TR><TD><B>Date:</B></TD><TD><input type=text value="<%=strDate%>" ID="Text5" NAME="date"></TD></tr>
<TR><TD><B>Trick:</B></TD><TD><input type=text value="<%=strTrickName%>" ID="Text6" NAME="trickname"></TD></tr>
<TR><TD><B>Media Type:</B></TD><TD><input type=text value="<%=strMediaType%>" ID="Text7" NAME="mediatype"></TD></tr>
<TR><TD><B>Description:</B></TD><TD><input type=text value="<%=strDescription%>" name="description"></TD></tr>
<TR><TD><B>RowID:<%=nFileID%></TD><TD><input name=fileid type=hidden value="<%=nFileID%>"></B></TD></TR>
<TD colspan=2 align=right><input type=submit value="Submit Changes"></TD></tr>
</table>
</TD>
<TD valign=top>
<table>
<tr>
<td valign=top><b>Skater(s):</b></td><td valign=top><SELECT style="height:200px;" name="skaterid" multiple=true ID="Select1">
<%
for(var arrIterator = 0;arrIterator < arrSkaters.length;arrIterator++)
{
	Response.Write("<Option ");
	if(isInSkaterList(arrSkaters[arrIterator].id))
	{
		Response.Write("Selected='true'");
	}
	Response.Write(" Value='" + arrSkaters[arrIterator].id + "'>" + arrSkaters[arrIterator].name + "</option>\n");
}
%>
</SELECT></td>
</tr>
</table>
</TD>
</form>

</body>
</html>
<!--#include file="dbcleanup.js"-->