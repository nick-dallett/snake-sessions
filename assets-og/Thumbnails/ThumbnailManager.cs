using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

namespace Thumbnails
{
	/// <summary>
	/// Summary description for ThumbnailManager.
	/// </summary>
	public class ThumbnailManager
	{
		public ThumbnailManager()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		public byte[] MakeThumbnail(string file)
		{
					
			// create an image object, using the filename we just retrieved
			System.Drawing.Image image = System.Drawing.Image.FromFile(file);

			// create the actual thumbnail image
			System.Drawing.Image thumbnailImage = image.GetThumbnailImage(64, 64, new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback), IntPtr.Zero);

			// make a memory stream to work with the image bytes
			MemoryStream imageStream = new MemoryStream();

			// put the image into the memory stream
			thumbnailImage.Save(imageStream,ImageFormat.Jpeg);

			// make byte array the same size as the image
			byte[] imageContent = new Byte[imageStream.Length];

			// rewind the memory stream
			imageStream.Position = 0;

			// load the byte array with the image
			imageStream.Read(imageContent, 0, (int)imageStream.Length);

			// return byte array to caller with image type
			return imageContent;

		}
		/// <summary>
		/// Required, but not used
		/// </summary>
		/// <returns>true</returns>
		public bool ThumbnailCallback()
		{
			return true;
		}
	}
}
