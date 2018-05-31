<%@ Language=JScript %>
<%Response.Buffer = true%>
<!--#include file=connstring.js-->
<HTML>
	<HEAD>
		<link rel="stylesheet" href="stylesheets\dallett.css">
	</HEAD>
	<BODY>
		<h1>Snake Sessions</h1>
		<ul>
			<div style="FONT-SIZE:9pt;FONT-FAMILY:courier">
				<p>Photo-documenting my return to skateboarding since 2001.
					<Table>
						<TR>
							<TD>
								<div style="PADDING-RIGHT:20px;PADDING-LEFT:20px;FONT-SIZE:9pt;PADDING-BOTTOM:5px;PADDING-TOP:20px;FONT-FAMILY:arial"><UL>
										<I>I've skated off and on since 1975.
											<p>I grew up 5 blocks from Brentwood school in West L.A., <A href="vids/oldies/Brentwood_340.wmv">
													learned to skate on the asphalt banks there</A>, and the world you see 
												documented in <I>Dogtown and Z-Boys</I> pretty much describes the world I grew 
												up in (except that we lived on the "right" side of Wilshire Blvd, which meant 
												that I grew up better educated but never developed the skate skills of the guys 
												we idolized - Tony Alva and Jay Adams and their posse.</p>
											<p>In 1978, <A href="1978Contest">I placed 5th</A> in the Bay Street freestyle 
												competition in Santa Monica, California. That was the peak of my skating 
												career. Today, I'm a parks-n-pools skater, and I'm better than I ever was in 
												the 70's, 80's (most of which I sat out in a small town with little to skate 
												on), or 90's</p>
											<P>
											Lately, I've become involved in skatepark advocacy - trying to help public 
											organizations create quality, cost-effective skateparks that will meet the 
											needs of all levels of skateboarders for years to come.&nbsp;
											<P>-Nick ("Snake") Dallett<BR>
												nickdal (at) speakeasy.net</P>
									</UL>
								</div>
								<DIV></DIV>
								<UL>
								</UL>
								</I>
								<UL>
								</UL>
							</TD>
							<TD>
								<img src="Chino_Frontpage.jpg" style="BORDER-RIGHT: black 2px solid; BORDER-TOP: black 2px solid; BORDER-LEFT: black 2px solid; BORDER-BOTTOM: black 2px solid"
									width="237" height="229">
								<BR>
								<span style="FONT-WEIGHT:bold;FONT-SIZE:9px;FONT-FAMILY:arial">Throwing down a frontside grind Chino, Ca. in May of 2004 <I>
										(photo by 10 year old Kyle)</I></span>
							</TD>
						</TR>
					</Table>
					
					<%
						var cPix;
						var cVids;
						var cSkaters;
						
						strQuery = "select count(httppath) as pix from skatepix where mediatype <> 'video'";
						OpenRS();
						if(!oRS.EOF)
						{
							cPix = oRS.Fields.Item("pix").Value;
						}
						
						strQuery = "select count(httppath) as vids from skatepix where mediatype = 'video'";
						OpenRS();
						if(!oRS.EOF)
						{
							cVids = oRS.Fields.Item("vids").Value;
						}
						
						strQuery = "select count(*) as skaters from skaterbios";
						OpenRS();
						if(!oRS.EOF)
						{
							cSkaters = oRS.Fields.Item("skaters").Value;
						}
					%>
					
					<h3 style="font-size:14pt;">--><A href="snakesessions.asp">Search Videos and Pictures</A></h3>
					<div style="background-color:#FEDC9A; margin:30px;padding:6px;border:2px solid #999999;" align=center>
					<P>There are <%=cPix%> pictures and <%=cVids%> videos in the database, featuring <%=cSkaters%> skateboarders from the Pacific Northwest and elsewhere.</P>
						
						<P>Latest sessions:<br>
						
						<%
						
						strQuery = "select distinct park, convert(varchar(20),[date],101) as [date] from skatepix where date in (SELECT distinct top 5 date from skatepix order by date desc) order by date desc";
						OpenRS();
						while(!oRS.EOF)
						{
						var strDate = oRS.Fields.Item("date").Value;
						var strPark = oRS.Fields.Item("park").Value;
						
						var strUrl = "http://snake.kittycrack.net/snakesessions.asp?oSkaterID=0&oPark=" + strPark + "&oStartDate=" + strDate + "&oEndDate=" + strDate + "&oTrickName=All&oMediaType=All"
						Response.Write("<BR><A href=\"" + strUrl + "\" target=\"_blank\"><B>" + strPark + " " + strDate + "</B></A>");
							
							oRS.MoveNext();
						}

						%>
						
						
						
						</div>
						
					<hr noshade>
					<h3>Skatepark advocacy links</h3>
					<UL>
							<li><A href="http://www.skatersforpublicskateparks.org">Skaters for Public Skateparks</A>  </li>					
						<li><A href="http://www.frappr.com/skatersforpublicskateparks">SPS members by state</A></LI>
						<LI>
							<A href="http://www.marginalwayskatepark.org">Marginal Way Skatepark</A></LI>
							<LI>
							<A href="http://www.parents4sk8parks.org">Parents for skateparks</A></LI>
							
					</UL>
			</div>
		</ul>
	</BODY>
</HTML>

<!--#include file=dbcleanup.js-->
