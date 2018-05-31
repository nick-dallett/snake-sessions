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
//const aws = require("aws");
//const mysql = require("mysql");


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
  
  let sitestats = new SiteStats();
  // initialize with default data (TODO: connect to the database and retrieve live data)
  sitestats.m_cPictures = 900;
  sitestats.m_cSkaters = 909;
  sitestats.m_cVideos = 90909;

  // add a default list of sessions
  for(var i = 0; i < 5; i++)
  {
    
    let S = new Session();
    S.m_park = "Park from hell: " + i.toString();
    S.m_date = "12/12/1200";
    S.m_cMediaItems = 9999;
    S.m_queryLink = "/search";
    sitestats.addSession(S);
    
  }

  response.writeHead(200,{"Content-Type" : "text/JSON"});
  response.write(JSON.stringify(sitestats));
  response.end();
  
} );

  








