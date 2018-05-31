<%@ Language=JScript %>
<!--#include file=connstring.js-->
<html>
	<head>
		<link rel="stylesheet" href="stylesheets\dallett.css">
			<style type="text/css">
BODY 
{
	background-color:black;
	border:none;
	font-size:10;
	color:ivory;
	padding:0;
	margin:0;
}

TABLE
{
	position:absolute;
	top:5;
	left:5;
	border:white solid 2px;
	margin:0;
	font-size:10;
	width:100%;
}

INPUT {font-size:10;}
SELECT {font-size:10;}
</style>
	</head>
	<body>
		<form action="searchresults.asp" target="resultsframe">
			<table style='margin-top:0;'>
				<tr>
					<td colspan="2" style='background-color:#008000;padding:5px;border:2px solid #C00000;'><span style="font-size:18pt;font-weight:bold;color:#0000C0;display:block">Snake Sessions</span>Skate 
						media database search</td>
					<td align="right"><b>Skater:</b></td>
					<td><select name="oSkaterID">
							<option value="0">All</option>
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
					<td align="right"><b>Park:</b></td>
					<td colspan="3"><select name="oPark">
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
					<td align="right"><B>Date Range: FROM</B></td>
					<td><input type="text" name="oStartDate"><B>TO</B> <input type="text" name="oEndDate"></td>
					<td align="right"><b>Trick:</b></td>
					<td><select name="oTrickName">
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
						</select></td>
					<td align="right"><b>Media Type:</b></td>
					<td><select name="oMediaType">
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
						</select>
					</td>
					<td><Input type="submit" value="SEARCH" style="padding:2px;background-color:green;font-weight:bold;color:Ivory;border:none;"><br>
					</td>
				</tr>
				<tr>
				<td></td>
				<td></td>
				<td></td>
				<td colspan=3 align=right><input type=checkbox name="unsorted"> Show only untagged photos</td>
				
				</tr>
			</table>
		</form>
		<span style='position:absolute;top:100;left:10;'>
			<a target='_top' style='text-decoration:underline;color:#8080FF;' href="http://snake.kittycrack.net">
				BACK to snake.kittycrack.net</a></span>
		<!--#include file="dbcleanup.js"-->
	</body>
</html>
