/* ********************************* */
/*      SNAKE SESSIONS - SERVER      */
/* ********************************* */

// import needed packages
const express = require("express");
const http = require("http"); 
const filesystem = require("fs");
const utility = require("./utility.js");
const path = require("path");
const Session = require("./session.js");
const SiteStats = require("./sitestats.js");
const SnakeSessionsDataConnection = require("./snakesessionsdataconnection");


// main server object
const snake_sessions_server = express();
const router = express.Router();
 
snake_sessions_server.listen(80, () => {
  console.log(`Server running at port 80`);
})

snake_sessions_server.use("/",router);
snake_sessions_server.use('/stylesheets', express.static(path.join(__dirname, 'assets-og/stylesheets')));
snake_sessions_server.use('/assets', express.static(path.join(__dirname, 'assets-og')));


/*********************************/
/***********  ROUTES   ***********/
/*********************************/

//Homepage

/*
TODO: this is cute and all, but really I should be just returning a single static page, and fetching sitestats using xmlhttp...
This is based on my original site that used server-side-includes, but this structure isn't necessary (and it's clunky when implemented as 3 separate reads wrapped in Promises)
 */

router.get("/", (request, response) =>{
  response.writeHead(200, {"Content-Type" : "text/html"});

  // add page header
   utility.getFileInclude("site-header").then( x => { 
     response.write(x);
     // add page body
     utility.getFileInclude("homepage-body").then(y => {
       response.write(y);
       // add page footer
       utility.getFileInclude("site-footer").then(z => {
         response.write(z);
         response.end();});
        } );
      } );
    } );

// Search
router.get("/search", (request, response) => {
  response.writeHead(200, {"Content-Type" : "text/html"});
  response.write("<html><head><link rel=\"stylesheet\" href=\"stylesheets/dallett.css\"/><title>Skate Photo / Video search</title></head><body><h1>Search coming soon</h1></body></html>");
  response.end();
} );

// Site Stats

router.get("/site-stats", (request, response) => {

  let qstring = "CALL sp_sitestats";
  let myconnection = new SnakeSessionsDataConnection();
  
  myconnection.Connect().then(() =>{
      myconnection.Query(qstring).then((result) => {
        
          let sitestats = new SiteStats();
          let rowset = result[0];
          rowset.forEach(element => {
            if('STATS' == element.STATS) // TODO: Change to use a switch
            {
              console.log("this is STATS: " + JSON.stringify(element));
              sitestats.m_cPictures = element.cPictures;
              sitestats.m_cSkaters = element.cSkaters;
              sitestats.m_cVideos = element.cVideos;
            }
            else if ('SESSION' == element.STATS)
            {
              console.log("this is SESSION: " + JSON.stringify(element));
              let S = new Session();
              S.m_park = element.PARK;
              S.m_date = element.DATE;
              S.m_cMediaItems = element.MEDIA;
              sitestats.addSession(S);
            }
            else{
              console.log("dunno what this is: " + JSON.stringify(element));
            }
          });
          
         response.writeHead(200,{"Content-Type" : "text/JSON"});
         response.write(JSON.stringify(sitestats));
         response.end();
         myconnection.Close();
      });
  });
} );

  








