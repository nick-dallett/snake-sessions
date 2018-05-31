<%
	if(oConn)
	{
		try
		{
			oConn.Close();
		}
		catch(e)
		{
		}
	}
	
	if(oRS)
	{
		try
		{
			oRS.Close();
		}
		catch(e)
		{
		}
	}
		




%>