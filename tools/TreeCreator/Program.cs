using System;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace TreeCreator
{
    class Program
    {
        static DateTime GetDateFromDirectory(String s){
            Regex r = new Regex("[0-9]*-[0-9]*-[0-9]*",RegexOptions.IgnoreCase);
            Match m = r.Match(s);
            if(m.Success){
                try{
                    DateTime d = DateTime.Parse( m.Groups[0].ToString());
                    return d;
                }
                catch(Exception e)
                {
                    Console.WriteLine("Invalid date: " + m.Groups[0].ToString());
                }
                
            }
            return DateTime.MinValue;
        }
        const String RootDirectory = "C:\\Projects\\Snake_Sessions\\assets-og";
        static void Main(string[] args)
        {
            List<String> Directories =  new List<String>(Directory.EnumerateDirectories(RootDirectory));
            foreach(var d in Directories){
                Console.WriteLine(d);
                DateTime dt = GetDateFromDirectory(d);
                Console.WriteLine(dt.ToString());
                List<String> Photos = new List<String>(Directory.EnumerateFiles(d));
                foreach(var p in Photos){
                   // Console.WriteLine(p);
                }
            }
        }
    }
}
