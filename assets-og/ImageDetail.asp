<%@ Language=JScript %>
<html>
<head>
<meta name="GENERATOR" Content="Microsoft Visual Studio.NET 7.0">
<!--link rel="stylesheet" href="stylesheets\dallett.css"-->
</head>
<body style="border:none;" bgcolor="black">
<%
Response.Write("<A target='_new' href=\"" + Request.QueryString + "\"><IMG style='border:none;' src=\"" + Request.QueryString + "\" width=100% ></A>");
%>
<div style='color:#C00000;font-weight:bold;margin-top:-30px;margin-left:30px;z-index:10;'>Click for full-size image</div>
</body>
</html>
