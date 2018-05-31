<%

var g_strDbError = "";

var oConn = Server.CreateObject("ADODB.Connection");
oConn.ConnectionString = "Provider=SQLOLEDB.1;User ID=sk8r;Password=letssk8;Initial Catalog=WebDB;Data Source=sharpie\\sqlexpress";
oConn.CommandTimeout = 0;
oConn.Open();

var oRS = Server.CreateObject("ADODB.Recordset");
oRS.CursorType = 3; //adOpenStatic
var strQuery = "";

function SQLEscape(strInput)
{
	//replace each single quote with two single quotes
	strInput = strInput.replace(/\'/g,"''");
	return strInput;
}

function HTMLEscape(strInput)
{
    //replace all angle brackets with their textual equivalents
    strInput = strInput.replace(/</g,"&lt;");
    strInput = strInput.replace(/>/g,"&gt;");
    
    return strInput;
}

function ValidateForm()
{
}

function GetCookie(strKey)
{
	var strCookies = Request.Cookies.Item;
	var arrCookies = strCookies.split(";");
	var arrSingleCookie = null;
	for(var CookieIter = 0; CookieIter < arrCookies.length; CookieIter++)
	{
		try
		{
			arrSingleCookie = arrCookies[CookieIter].split("=");
			if(arrSingleCookie[0] == strKey)
			{
				return arrSingleCookie[1];		
			}
		}
		catch(e)
		{
			return "";
		}
	}
}

function SetCookie(strIndex, strValue)
{
	Response.Cookies(strIndex) = strValue;
}

function GetRandomPassword()
{
	var strPwd = String.fromCharCode(Math.ceil(Math.random() * 255), 	Math.ceil(Math.random() * 255), Math.ceil(Math.random() * 255), Math.ceil(Math.random() * 255)) + Math.random().toString() + String.fromCharCode(Math.ceil(Math.random() * 255), 	Math.ceil(Math.random() * 255), Math.ceil(Math.random() * 255), Math.ceil(Math.random() * 255))
	strPwd = Server.URLEncode(strPwd);
	strPwd = strPwd.replace(/\%/g,"x");
	strPwd = strPwd.replace(/\./g,"z");
	Response.Write("Password:" + strPwd + "<BR>");
	return strPwd;
}

function OpenRS()
{
	if(oRS.State == 1 /*adStateOpen*/)
	{
		oRS.Close();
	}
	
	try
	{
		oRS.Open(strQuery, oConn,3,1);
	}
	catch(e)
	{
		g_strDbError = e.description;		
		return false;
	}
	
	return true;
	
}

%>
