const filesystem = require("fs");
const path = require("path");

/****************************************/
/*********  UTILITY FUNCTIONS   *********/
/****************************************/


module.exports.getFileInclude = function (include)
{
    if (!filesystem){
      console.log("filesystem object not available.");
    }

    if (!include || include === "")
    {
      console.log("no valid include passed to getFileInclude.");
    }

    const filepath = path.join("./includes/", include + ".txt");

    return new Promise( (resolve, reject) => {
        filesystem.readFile(filepath, (err,data) => { (err) ? reject(err) : resolve(data);})});
    
}
