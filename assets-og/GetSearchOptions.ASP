<%@ Language=JScript%>
<%
Response.Buffer=true;
Response.ContentType="text/xml";
%>
<!--#include file=connstring.js-->
<%

var strSkaterName = Request.QueryString.Item("SkaterName");
var strPark = Request.QueryString.Item("Park");
var strTrickName = Request.QueryString.Item("TrickName");
var strMediaType = Request.QueryString.Item("MediaType");
var strStartDate = Request.QueryString.Item("StartDate");
var strEndDate = Request.QueryString.Item("EndDate");

var strWhereClause = "";

var strQS = "" + Request.QueryString;
var arrItems = strQS.split("&");




if (!strSkaterName && !strPark && !strTrickName && !strMediaType && !strStartDate && !strEndDate)
{
	// leave the where clause empty
}
else
{
	if(strSkaterName)
	{
		strWhereClause += " AND SkaterName = '" + strSkaterName + "'";		
		//Response.Write(strWhereClause);
		//Response.End;
	}
}

Response.Write("<PageData>");
Response.Write("<Skaters>");

	strQuery="SELECT DISTINCT skatername FROM SkatePixView WHERE skatername is not null" + strWhereClause + " ORDER BY skatername";
	
    //Response.Write("<Skater>" + strQuery + "</Skater>");
    //aResponse.Write("<Skater>" + Request.QueryString + "</Skater>");
    for(i=0;i<arrItems.length;i++)
    {
		Response.Write("<Skater>" + arrItems[i] + "</Skater>");
    }
    
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<Skater>" + oRS.Fields.Item("skatername").Value + "</Skater>");
		
		oRS.MoveNext();
	}
	
Response.Write("</Skaters>");
Response.Write("<Parks>");
	strQuery="SELECT DISTINCT park FROM skatepix WHERE park IS NOT NULL ORDER BY park";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<Park>" + oRS.Fields.Item("Park").Value + "</Park>");
		oRS.MoveNext();
	}
Response.Write("</Parks>");	
Response.Write("<Tricks>");	
				
	// by trickname
	strQuery="SELECT DISTINCT Trickname FROM skatepix WHERE Trickname IS NOT NULL ORDER BY Trickname";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<Trick>" + oRS.Fields.Item("Trickname").Value + "</Trick>");
		oRS.MoveNext();
	}
	
Response.Write("</Tricks>");	
	
	strQuery = "SELECT MAX(date) as max, MIN(date) as min FROM SkatePix";
	OpenRS();
	
	var maxDate = oRS.Fields.Item("max").Value;
	var minDate = oRS.Fields.Item("min").Value;
Response.Write("<Dates Min=\"" + minDate + "\" Max=\"" + maxDate + "\"/>");	
Response.Write("<MediaTypes>");
	
	strQuery="SELECT DISTINCT Mediatype FROM skatepix WHERE Mediatype IS NOT NULL ORDER BY Mediatype";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<MediaType>" + oRS.Fields.Item("Mediatype").Value + "</MediaType>");
		oRS.MoveNext();
	}
Response.Write("</MediaTypes>");
Response.Write("<Photographers>");
	
	strQuery="SELECT DISTINCT Photographer FROM skatepix WHERE Photographer IS NOT NULL ORDER BY Photographer";
	OpenRS();
	
	while(!oRS.EOF)
	{
		Response.Write("<Photographer>" + oRS.Fields.Item("Photographer").Value + "</Photographer>");
		oRS.MoveNext();
	}
Response.Write("</Photographers>");
Response.Write("</PageData>");
%>
<!--#include file="dbcleanup.js"-->
