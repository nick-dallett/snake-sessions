
const xhr = new XMLHttpRequest();

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

function initSearchPage(){
    xhr.addEventListener("load", processSearchTerms);
    xhr.open("GET","/search-terms");
    xhr.send();
}