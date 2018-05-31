<%@ Language=JScript%>
<%
Response.Buffer=true;
Response.ContentType="application/json";
%>
<!--#include file=connstring.js-->
<%
var str = "" + Request.QueryString;
Response.Write("\{matches:[");

var arrKeywords = str.split("%20");

var strQuery = "SELECT Keyword, [Column], DisplayName, SkaterId FROM SkateKeywords";
var cKeywords = arrKeywords.length;

var iter;
if(cKeywords > 0)
{
	strQuery += " WHERE Keyword LIKE '%" + SQLEscape(arrKeywords[0]) + "%'";
	for(iter = 1; iter < cKeywords; iter++)
	{
		strQuery += " OR Keyword LIKE '%" + SQLEscape(arrKeywords[iter]) + "%'";	    						
	}
	
	strQuery += " ORDER BY Keyword";
	
	OpenRS();
	
	var strDisplayName;
	var strColumn;
	
	while(!oRS.EOF)
	{
		switch(oRS.Fields.Item("Column").Value)
		{
			case "Park":
				strColumn = "p";
				break;
			case "TrickName":
				strColumn = "t";
				break;
			case "SkaterFirstName":
				strColumn = "s";
				break;
			case "SkaterLastName":
				strColumn = "s";
				break;
			case "SkaterAlias1":
				strColumn = "s";
				break;
			case "Photographer":
				strColumn = "f";
				break;
		}
		Response.Write("{'SkaterID':'" + oRS.Fields.Item("SkaterID").Value + "', 'Type':'Keyword', 'Column':'" + strColumn + "','DisplayName':'");	
		strDisplayName = oRS.Fields.Item("DisplayName").Value;
		
		if(" " != strDisplayName)
		{
			Response.Write(strDisplayName);
		}
		else
		{
			Response.Write(oRS.Fields.Item("Keyword").Value);
		}
		
		Response.Write("'\} ,");
		oRS.MoveNext();
	}	
}

Response.Write("{'SkaterID':null, 'Type':null,'Column':null,'DisplayName':null}\}");

%>
<!--#include file="dbcleanup.js"-->
