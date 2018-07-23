const fs = require("fs");
const path = require("path");
const SnakeSessionsDataConnection = require("./snakesessionsdataconnection");

const root = "C:\\Projects\\Snake_Sessions\\assets-og";

var numTasks = 0;
var numDone = 0;
var closed = false;


function getTwoDigitDateFormat(monthOrDate) {
  return (monthOrDate < 10) ? '0' + monthOrDate : '' + monthOrDate;
}

let myconnection = new SnakeSessionsDataConnection();
try {
    myconnection.Connect().then(() =>{
        // get an array of all folders
        fs.readdir(root,(err,files) => {
            if(err){
                console.log(err);
            }
            else{
                var query = "";
                numTasks = files.length;
                // get the path of each file
                files.forEach((file) => {
                    let filePath = path.join(root,file);
                    //console.log(filePath);
                    // if the file is a directory, process it
                    fs.stat(filePath,(err, stats) => {
                        if(err){
                            console.log(err);
                        }
                        else{
                            if(stats.isDirectory()){
                                //parse the date from the directory name
                                let matches = filePath.match(/[0-9]*-[0-9]*-[0-9]*/i);
                                if(matches){
                                    let d = new Date(matches[0]);
                                    let datestring = d.getFullYear() + "-" + getTwoDigitDateFormat(d.getMonth() + 1) + "-" + getTwoDigitDateFormat(d.getDate());
                                    console.log("Formatted date: " + datestring);
                                    console.log("dirName: " + file);
                                    //console.log(datestring);
                                    query = "UPDATE SkatePix SET Date='" + datestring + "' WHERE REPLACE(HttpPath,' ','') LIKE REPLACE('%" + file + "%',' ','');";
                                    //console.log(query + "\n");
                                    myconnection.Query(query).then((result)=>{
                                        try{
                                            //console.log("DATE: " + matches[0] + " -- PATH: " + file  + "\n");
                                            
                                            if(numDone == numTasks && !closed){
                                                console.log("Closing connection"  + "\n");
                                                closed=true;
                                                myconnection.Close();
                                            }
                                        }
                                        catch(e){
                                            console.log(e);
                                        }
                                    },(err)=>{
                                        console.log(err);
                                     })
                                }
                                else{
                                    //console.log("No match found for: " + filePath);
                                }
                                
                            }
                            else{
                                //console.log(file + " is not a directory");
                               
                            }


                        }
                            

                    });
                    numDone++;
                    //console.log("TASKS: " + numTasks);
                    //console.log("DONE: " + numDone);

                });
            }
        });
    });
    }
    catch(e)
    {
        console.log(e);
    }
