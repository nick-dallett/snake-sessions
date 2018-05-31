using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;
using System.Web.Services;

namespace SiteMaintenance
{
	/// <summary>
	/// Summary description for Service1.
	/// </summary>
	[WebService(Namespace="http://snake.kittycrack.net/sitemaintenance")]
	public class SiteMaintenance : System.Web.Services.WebService
	{
		public const string  m_strConnString = "Server=SHARPIE\\SQLEXPRESS;initial catalog=WebDB;User ID=sk8r;Password=letssk8;";
		public SqlConnection m_connection = null;

		public SiteMaintenance()
		{
			//CODEGEN: This call is required by the ASP.NET Web Services Designer
			InitializeComponent();
		}

		#region Component Designer generated code
		
		//Required by the Web Services Designer 
		private IContainer components = null;
				
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if(disposing && components != null)
			{
				components.Dispose();
			}
			base.Dispose(disposing);		
		}
		
		#endregion

		public class QueryParams
		{
			public int skaterId;
			public string park;
			public string trickName;
			public string photographer;
			public string mediatype;
			public DateTime	startDate;
			public DateTime endDate;
			public bool unsorted;
		}

		public class SkaterInfo
		{
			public int SkaterID;
			public string SkaterName;
		}

		public class SubmitParams
		{
			public SkaterInfo[] skaters;
			public int skaterId;
			public string park;
			public string trickName;
			public string photographer;
			public string mediatype;
			public string date;
		}

		public class ThumbInfo
		{
			public int nRowID;
			public string strThumbUrl;
			public string strFullUrl;
			public bool	  fUpdate;
		}

		public class ThumbInfoPak
		{
			public SubmitParams m_qp;
			public ThumbInfo[] arrThumbs;
		}

		public string GetRowList(ThumbInfoPak tPk)
		{
			string strRowList = "(";
			bool fListStarted = false;
			long nRowCount = tPk.arrThumbs.GetLength(0);
			for(int iter=0; iter< nRowCount; iter++)
			{
				
				if(true == tPk.arrThumbs[iter].fUpdate)
				{
					if(true == fListStarted)
					{
						strRowList += ",";
					}
					strRowList += tPk.arrThumbs[iter].nRowID.ToString();
					fListStarted = true;
				}
			}

			strRowList += ")";
			return strRowList;
		}

		private void ConnectDB()
		{
			if(null != m_connection)
			{
				if(m_connection.State != ConnectionState.Closed)
				{
					return;
				}
			}
			else
			{
				m_connection = new SqlConnection(m_strConnString);
			}

			m_connection.Open();
		}

		[WebMethod]
		public ThumbInfoPak GetUnsortedThumbnails()
		{
			ThumbInfoPak tPk = null;
			SqlDataAdapter oAdapter = new SqlDataAdapter();
			DataSet	oDS = new DataSet();
			string strQuery = "SELECT FileID, HttpPath, HttpThumbPath FROM Skatepix WHERE HttpPath IS NOT NULL AND [Date] IS NULL";

			try
			{
				ConnectDB();
				oAdapter.SelectCommand = new SqlCommand(strQuery, m_connection);
				oAdapter.Fill(oDS,"SkatePix");
			}
			catch(Exception)
			{
				goto cleanup;
			}

			long nRecords = oDS.Tables["SkatePix"].Rows.Count;
			tPk = new ThumbInfoPak();

			tPk.arrThumbs = new ThumbInfo[nRecords];
			tPk.m_qp = new SubmitParams();
			tPk.m_qp.date = "";
			tPk.m_qp.mediatype = "";
			tPk.m_qp.park = "";
			tPk.m_qp.photographer = "";
			tPk.m_qp.trickName = "";

			DataRow oRow;
			for(int iter=0;iter < nRecords; iter++)
			{
				oRow =  oDS.Tables["SkatePix"].Rows[iter];
				tPk.arrThumbs[iter] = new ThumbInfo();
				tPk.arrThumbs[iter].strThumbUrl = "http://snake.kittycrack.net" + oRow["HttpThumbPath"].ToString();
				tPk.arrThumbs[iter].strFullUrl = "http://snake.kittycrack.net" + oRow["HttpPath"].ToString();
				tPk.arrThumbs[iter].nRowID = Convert.ToInt32(oRow["FileID"]);
			}

		cleanup:
			m_connection.Close();
			return tPk;
		}

		[WebMethod]
		public ThumbInfoPak GetThumbnails(QueryParams qp)
		{
			if(qp.unsorted)
			{
				return GetUnsortedThumbnails();
			}

			SqlDataAdapter oAdapter = new SqlDataAdapter();
			DataSet	oDS = new DataSet();
			ThumbInfoPak tPk = null;

			 string strQuery = "SELECT DISTINCT p.FileID, p.HttpPath, p.HttpThumbPath FROM SkatePix p, SkaterBios b, pixtobios t WHERE p.fileid = t.fileid AND httpPath IS NOT NULL";

			if(0 != qp.skaterId)
			{
				strQuery += " AND t.SkaterID=" + qp.skaterId.ToString();
			}

			if("" != qp.park)
			{
				strQuery += " AND p.Park='" + qp.park + "'";
			}

			if("" != qp.mediatype)
			{
				strQuery += " AND p.mediatype='" + qp.mediatype + "'";
			}

			if("" != qp.photographer)
			{
				strQuery += " AND p.photographer='" + qp.photographer + "'";
			}

			if("" != qp.trickName)
			{
				strQuery += " AND p.trickName='" + qp.trickName + "'";
			}

			if("" != qp.startDate.ToString())
			{
				strQuery += " AND Date >= '" + qp.startDate.ToString() + "'";
			}

			if("" != qp.endDate.ToString())
			{
				strQuery += " AND Date <= '" + qp.endDate.ToString() + "'";
			}

			try
			{
				ConnectDB();
				oAdapter.SelectCommand = new SqlCommand(strQuery, m_connection);
				oAdapter.Fill(oDS,"SkatePix");
			}
			catch(Exception)
			{
				goto cleanup;
			}

			long nRecords = oDS.Tables["SkatePix"].Rows.Count;
			tPk = new ThumbInfoPak();

			tPk.arrThumbs = new ThumbInfo[nRecords];
			tPk.m_qp = new SubmitParams();
			tPk.m_qp.date = "";
			tPk.m_qp.mediatype = "";
			tPk.m_qp.park = "";
			tPk.m_qp.photographer = "";
			tPk.m_qp.trickName = "";

			DataRow oRow;
			for(int iter=0;iter < nRecords; iter++)
			{
				oRow =  oDS.Tables["SkatePix"].Rows[iter];
				tPk.arrThumbs[iter] = new ThumbInfo();
				tPk.arrThumbs[iter].strThumbUrl = "http://snake.kittycrack.net" + oRow["HttpThumbPath"].ToString();
				tPk.arrThumbs[iter].strFullUrl = "http://snake.kittycrack.net" + oRow["HttpPath"].ToString();
				tPk.arrThumbs[iter].nRowID = Convert.ToInt32(oRow["FileID"]);
			}

		cleanup:
			m_connection.Close();
			return tPk;
		}


		[WebMethod]
		public void UpdateSkatePix(ThumbInfoPak tPk)
		{
			SqlConnection oConn = new SqlConnection(m_strConnString);
			SqlDataAdapter oAdapter = new SqlDataAdapter();

			try
			{
				oConn.Open();
			}
			catch(Exception ex)
			{
				throw ex;
			}
			string strQuery = "UPDATE SkatePix SET";
			bool fSetStatementStarted = false;

			if(null != tPk.m_qp.date && "" != tPk.m_qp.date)
			{
				strQuery += " Date='" + tPk.m_qp.date.ToString() + "'";
				fSetStatementStarted = true;
			}

			if(null != tPk.m_qp.mediatype && "" != tPk.m_qp.mediatype )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}
				strQuery += " MediaType='" + tPk.m_qp.mediatype + "'";
				fSetStatementStarted = true;
			}

			if(null != tPk.m_qp.park && "" != tPk.m_qp.park )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " Park='" + tPk.m_qp.park + "'";
				fSetStatementStarted = true;
			}

			if(0 != tPk.m_qp.skaterId)
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " SkaterID=" + tPk.m_qp.skaterId.ToString();
				fSetStatementStarted = true;

			}

			if(null != tPk.m_qp.trickName && "" != tPk.m_qp.trickName )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " TrickName='" + tPk.m_qp.trickName + "'";
				fSetStatementStarted = true;
			}

			
			if(null != tPk.m_qp.photographer && "" != tPk.m_qp.photographer)
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " Photographer='" + tPk.m_qp.photographer + "'";
				fSetStatementStarted = true;
			}

			strQuery += " WHERE FileID in " + GetRowList(tPk);
			SqlCommand oCommand = new SqlCommand(strQuery,oConn);

			try
			{
				oCommand.ExecuteNonQuery();
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		[WebMethod]
		public string TestUpdateSkatePix(ThumbInfoPak tPk)
		{
			SqlConnection oConn = new SqlConnection(m_strConnString);
			SqlDataAdapter oAdapter = new SqlDataAdapter();

			try
			{
				oConn.Open();
			}
			catch(Exception ex)
			{
				throw ex;
			}
			string strQuery = "UPDATE SkatePix SET";
			bool fSetStatementStarted = false;

			if(null != tPk.m_qp.date && "" != tPk.m_qp.date)
			{
				strQuery += " Date='" + tPk.m_qp.date.ToString() + "'";
				fSetStatementStarted = true;
			}

			if(null != tPk.m_qp.mediatype && "" != tPk.m_qp.mediatype )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}
				strQuery += " MediaType='" + tPk.m_qp.mediatype + "'";
				fSetStatementStarted = true;
			}

			if(null != tPk.m_qp.park && "" != tPk.m_qp.park )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " Park='" + tPk.m_qp.park + "'";
				fSetStatementStarted = true;
			}

			if(0 != tPk.m_qp.skaterId)
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " SkaterID=" + tPk.m_qp.skaterId.ToString();
				fSetStatementStarted = true;

			}

			if(null != tPk.m_qp.trickName && "" != tPk.m_qp.trickName )
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " TrickName='" + tPk.m_qp.trickName + "'";
				fSetStatementStarted = true;
			}

			
			if(null != tPk.m_qp.photographer && "" != tPk.m_qp.photographer)
			{
				if(true == fSetStatementStarted)
				{
					strQuery += ",";
				}

				strQuery += " Photographer='" + tPk.m_qp.photographer + "'";
				fSetStatementStarted = true;
			}

			strQuery += " WHERE FileID in " + GetRowList(tPk);

			//SqlCommand oCommand = new SqlCommand(strQuery,oConn);

			System.IO.FileStream file = new System.IO.FileStream("g:\\" + DateTime.Now.Ticks.ToString() + ".txt",System.IO.FileMode.OpenOrCreate);
			
			System.IO.BinaryWriter bw = new System.IO.BinaryWriter(file);
			bw.Write(strQuery);

			file.Flush();
			file.Close();

			

			

			return strQuery;

		}


		[WebMethod]
		public SkaterInfo[] GetSkaterNames()
		{
			SqlConnection oConn = new SqlConnection(m_strConnString);
			SqlDataAdapter oAdapter = new SqlDataAdapter();
			DataSet	oDS = new DataSet();

			try
			{
				oConn.Open();
			}
			catch(Exception)
			{
				return null;
			}
			string strQuery = "SELECT SkaterID, SkaterName=COALESCE(SkaterFirstName,'') + ' ' + COALESCE(SkaterLastName, '') + ' (' + COALESCE(SkaterAlias1,'') + ')' From SkaterBios ORDER BY SkaterName";
			oAdapter.SelectCommand = new SqlCommand(strQuery,oConn);

			try
			{
				oAdapter.Fill(oDS,"SkaterBios");
			}
			catch(Exception)
			{
				return null;
			}

			long nRecords = oDS.Tables["SkaterBios"].Rows.Count;
			SkaterInfo[]	si = new SkaterInfo[nRecords];
			DataRow oRow;
			for(int iter=0;iter<nRecords;iter++)
			{
				oRow = oDS.Tables["SkaterBios"].Rows[iter];
				si[iter] = new SkaterInfo();
				si[iter].SkaterID = Convert.ToInt32(oRow["SkaterID"]);
				si[iter].SkaterName = oRow["SkaterName"].ToString();

			}

			oConn.Close();

			return si;
		}

	}
}
