<%@Language=JScript%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Snake Sessions</title>
<meta name="GENERATOR" content="Microsoft Visual Studio.NET 7.0">
<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
</head>
<frameset rows="140,*">
<frame noresize frameborder="0" name="searchbar" src="searchframe.asp">
<%if(Request.QueryString != "")
{%>
<frame noresize frameborder="0" name="resultsframe" src="searchresults.asp?<%=Request.QueryString%>">
<%
}
else
{%>
<frame noresize frameborder="0" name="resultsframe" src="black.htm">
<%
}
%>
</frameset>
</html>
