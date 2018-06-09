/*********************************/
/******** HOMEPAGE SCRIPT ********/
/*********************************/
const xhr = new XMLHttpRequest();
var   g_SiteStats = null;

function processSiteStats(){
    //alert(xhr.responseText);
    g_SiteStats = JSON.parse(xhr.responseText);

    // set the number of various items in the page
    document.getElementById("spnPictures").innerText = g_SiteStats.m_cPictures;
    document.getElementById("spnVideos").innerText = g_SiteStats.m_cVideos;
    document.getElementById("spnSkaters").innerText = g_SiteStats.m_cSkaters;

   // enumerate the latest sessions
   var a = document.getElementById("dvSessions");
   a.innerHTML = "<ul>";
    g_SiteStats.m_sessions.forEach(
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

