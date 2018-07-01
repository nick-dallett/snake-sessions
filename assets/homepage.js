/*********************************/
/******** HOMEPAGE SCRIPT ********/
/*********************************/
const xhr = new XMLHttpRequest();
//var   g_SiteStats = null;

function processSiteStats(){
    let siteStats = JSON.parse(xhr.responseText);

    // set the number of various items in the page
    document.getElementById("spnPictures").innerText = siteStats.m_cPictures;
    document.getElementById("spnVideos").innerText = siteStats.m_cVideos;
    document.getElementById("spnSkaters").innerText = siteStats.m_cSkaters;

   // enumerate the latest sessions
   var a = document.getElementById("dvSessions");
   a.innerHTML = "<ul>";
    siteStats.m_sessions.forEach(
        (item, index) => {
            
            a.innerHTML += "<li><a href='" + item.m_queryLink +  "'>" + item.m_park + " : " + item.m_date + " (" + item.m_cMediaItems + " items)</li>";    
        }
    )
    
    a.innerHTML += "</ul>"
}

function onload(){
    xhr.addEventListener("load", processSiteStats);
    xhr.open("GET","/site-stats");
    xhr.send();
}

