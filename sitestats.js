/***************************************/
/*********** SiteStats Class ***********/
/***************************************/
const Session = require("./session.js");

module.exports = class SiteStats{ 
    constructor(){
        this.m_cPictures = 0;
        this.m_cVideos = 0;
        this.m_cSkaters = 0;
        this.m_sessions = new Array();
    }

    addSession(S){
        this.m_sessions.push(S);
        return this.m_sessions.length;
    }
}

