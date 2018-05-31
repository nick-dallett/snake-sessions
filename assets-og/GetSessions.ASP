<%@ Language=JScript%>
<%
Response.Buffer=true;
Response.ContentType="text/xml";
%>
<!--#include file=connstring.js-->
<%

Response.Write("<Sessions>");

// arrays for building up the query by type

var arrSkaters = new Array();
var arrParks = new Array();
var arrTricks = new Array();
var arrPhotographers = new Array();

var strQueryStart = "SELECT park, CONVERT(varchar(20),[date],101) AS shootdate, COUNT(park) AS pictures FROM skatepix";
var strQueryEnd = " AND park IS NOT NULL AND date IS NOT NULL GROUP BY park, date ORDER BY date";




// input params, formatted like:
// p:Ballard bowl, WA|p:Aumsville, OR|s:98|t:backside grind|f:dan hughes
// where p=park, s=skaterid, t=trickname, f=photographer
//

var str = "" + Request.QueryString;
str = str.replace(/%20/g," ");
var arrParams = null;
var cParams = 0;

if("" != str)
{
	arrParams = str.split("|");
	cParams = arrParams.length;
	var arrTemp = null; 
	var iter = 0;

	for(var iter=0;iter < cParams; iter++)
	{
		arrTemp = arrParams[iter].split(":");
		switch(arrTemp[0])	
		{
			case 'p':
				arrParks[arrParks.length] = "'" + arrTemp[1] + "'";
				break;
			case 't':
				arrTricks[arrTricks.length] = "'" + arrTemp[1] + "'";
				break;
			case 's':
				arrSkaters[arrSkaters.length] = arrTemp[1];
				break;
			case 'f':
				arrPhotographers[arrPhotographers.length] = "'" + arrTemp[1] + "'";
				break;
		}
		arrTemp = null;
	}
}

//Response.Write(arrParams);


if(cParams > 0)
{
	//start the WHERE clause
	var strWhereClause = " WHERE ";
	
	// count how many "IN" clauses we'll build
	var cParks = arrParks.length;
	var cTricks = arrTricks.length;
	var cSkaters = arrSkaters.length;
	var cPhotographers = arrPhotographers.length;

	var cInClauses = (cParks == 0) ? 0:1;
	cInClauses += (cSkaters == 0) ? 0:1;
	cInClauses += (cTricks == 0) ? 0:1;
	cInClauses += (cPhotographers == 0) ? 0:1;

	if(cParks > 0)
	{
		cInClauses--;
		strWhereClause += "Park IN (";
		for(iter=0; iter < cParks; iter++)
		{
			strWhereClause += arrParks[iter];
			if(iter < cParks - 1)
			{
				strWhereClause += ",";
			}
		}
		strWhereClause += ") ";
		if(cInClauses > 0)
		{
			strWhereClause += "AND ";
		}
	}
	
	if(cTricks > 0)
	{
		cInClauses--;
		strWhereClause += "TrickName IN (";
		for(iter=0; iter < cTricks; iter++)
		{
			strWhereClause += arrTricks[iter];
			if(iter < cTricks - 1)
			{
				strWhereClause += ",";
			}
		}
		strWhereClause += ") ";
		if(cInClauses > 0)
		{
			strWhereClause += "AND ";
		}
	}
	
	if(cPhotographers > 0)
	{
		cInClauses--;
		strWhereClause += "Photographer IN (";
		for(iter=0; iter < cPhotographers; iter++)
		{
			strWhereClause += arrPhotographers[iter];
			if(iter < cPhotographers - 1)
			{
				strWhereClause += ",";
			}
		}
		strWhereClause += ") ";
		if(cInClauses > 0)
		{
			strWhereClause += "AND ";
		}
	}
	
	if(cSkaters > 0)
	{
		cInClauses--;
		strWhereClause += "SkaterID IN (";
		for(iter=0; iter < cSkaters; iter++)
		{
			strWhereClause += arrSkaters[iter];
			if(iter < cSkaters - 1)
			{
				strWhereClause += ",";
			}
		}
		strWhereClause += ") ";
		if(cInClauses > 0)
		{
			strWhereClause += "AND ";
		}
	}
}

var strQuery = strQueryStart + strWhereClause + strQueryEnd;

//Response.Write("<Session>" + strQuery + "</Session>");
OpenRS();

if(oRS.State == 1)
{
	while(!oRS.EOF)
	{
		Response.Write("<Session Park='" + oRS.Fields.Item("Park").Value + "' Date='" + oRS.Fields.Item("Shootdate").Value + "' Count='" + oRS.Fields.Item("Pictures").Value + "'/>");
		oRS.MoveNext();
	}
}


Response.Write("</Sessions>");

%>
<!--#include file="dbcleanup.js"-->
