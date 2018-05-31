<%@ Page language="c#"%>
<%@Import namespace="Thumbnails"%>
<%
	Response.Buffer = true;
	Response.ContentType = "image/jpeg";
	ThumbnailManager tm = new ThumbnailManager();
	Response.BinaryWrite(tm.MakeThumbnail(Server.MapPath(Request.QueryString["file"])));
%>
