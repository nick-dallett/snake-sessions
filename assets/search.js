
const xhr = new XMLHttpRequest();

function initSearchPage(){
    xhr.addEventListener("load", processSearchTerms);
    xhr.open("GET","/search-terms");
    xhr.send();
}

function processSearchTerms(){
   
   let terms = JSON.parse(xhr.responseText);
   for(var i=0; i < terms.length; i++){
    switch(terms[i].ColType){
        case "MaxDate":
        //alert("max date is " + terms[i].ColValue);
        document.getElementById("inputEndDate").value = terms[i].ColValue;
        continue;
        case "MinDate":
        document.getElementById("inputStartDate").value = terms[i].ColValue;
        continue;
        case "Skater":
        if(terms[i].ColValue && "NULL" != terms[i].ColValue){
            document.getElementById("selSkater").innerHTML += "<option value='" + terms[i].ColID + "'>" + terms[i].ColValue + "</option>";
        }
        continue;
        case "Park":
        if(terms[i].ColValue && "NULL" != terms[i].ColValue){
            document.getElementById("selPark").innerHTML += "<option>" + terms[i].ColValue + "</option>";
        }
        continue;
        case "Trick":
        if(terms[i].ColValue && "NULL" != terms[i].ColValue){
            document.getElementById("selTrick").innerHTML += "<option>" + terms[i].ColValue + "</option>";
        }
        continue;
        case "MediaType":
        if(terms[i].ColValue && "NULL" != terms[i].ColValue){
            document.getElementById("selMediaType").innerHTML += "<option>" + terms[i].ColValue + "</option>";
        }
        continue;
    }
  }
}

function processSearchResults(){
    alert("processing search results");
    alert(xhr.responseText);
}

function processSearchError(){
    alert("error");
    alert(xhr.responseText);
}

/*
function processChanges(){
    alert(xhr.readyState);
}
*/

function PerformSearch(){
    
    var searchPayload = new function(){
        this.minDate = document.getElementById("inputStartDate").value;
        this.maxDate = document.getElementById("inputEndDate").value;

        let selection = document.getElementById("selSkater");
        this.skaterID = selection.options[selection.selectedIndex].value;

        selection = document.getElementById("selPark");
        this.park = selection.options[selection.selectedIndex].text;

        selection = document.getElementById("selTrick");
        this.trick = selection.options[selection.selectedIndex].text;

        selection = document.getElementById("selMediaType");
        this.mediaType = selection.options[selection.selectedIndex].text;

        this.unsorted = document.getElementById("chkUnsorted").checked;
    }
    
    let payload = JSON.stringify(searchPayload);

   //alert(payload);
   //alert(payload.length);

    xhr.addEventListener("load", processSearchResults);
    xhr.addEventListener("error",processSearchError);
   // xhr.addEventListener("readystatechange",processChanges);
    xhr.open("POST","/execute-search");
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Content-Length", payload.length );
    xhr.send(payload);

}
