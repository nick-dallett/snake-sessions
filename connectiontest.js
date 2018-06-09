var SnakeSessionsDataConnection = require("./snakesessionsdataconnection");

const qstring = "CALL sp_sitestats";

let myconnection = new SnakeSessionsDataConnection();

myconnection.Connect().then(() =>{
    myconnection.Query(qstring).then((result) => {
        console.log(result);
        myconnection.Close();
    });
});