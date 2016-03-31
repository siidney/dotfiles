/*
 * TIME AND DATE
*/
function getTime(){
    var currentTime = new Date();
    var hour    = currentTime.getHours();
    var min     = currentTime.getMinutes();
    var sec     = currentTime.getSeconds();
    var time    = ((hour < 10) ? "0" : "") + hour;
    time += ((min < 10) ? ":0" : ":") + min;
    time += ((sec < 10) ? ":0" : ":") + sec;

    document.getElementById("time").innerHTML = time;
}

/*
 * SEARCH BOX
*/
function searchForm(){
    var res = document.searchForm.q.value.split(":");

    if(res[0] != ""){
        // if no search engine specified search with default
        if(res.length == 1){
            // check if query is valid url
            var domain = /^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]{0,1}\.(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})$/.test(res[0]);

            if(domain){
                window.location="https://www." + res[0];
            }else{
                defaultSearch(res[0]);
            }
        // search array for engine and redirect to url
        }else{
            // iterate through searchEngines and check for correct site tag
            // if none found use first
            for(var i=0; i<Object.keys(searchEngines).length; i++){
                if(res[0] == Object.keys(searchEngines)[i]){
                    window.location=searchEngines[res[0]][0].url + res[1];
                    return;
                }
            };
            // Not in list use default
            defaultSearch(res[1]);
        }
    }
    // search with default engine
    function defaultSearch(query){
        window.location=searchEngines.default[0].url + query;
        return;
    }
}
// create search engine list
function populateSearchList(){
    var list = document.getElementById("searchEngineList");

    // iterate over list and add names to list
    for(var i=1; i<Object.keys(searchEngines).length; i++){
        var linode = document.createElement("LI");
        var anode = document.createElement("A");
        var textnode = document.createTextNode(Object.keys(searchEngines)[i]);
        anode.appendChild(textnode);
        linode.appendChild(anode);
        list.appendChild(linode);
    };
}
/*
 * SEARCH ENGINE LIST
*/
// show or hide search engine list
document.getElementById("list-search").addEventListener("click", function(e){
    var searchEngineList = document.getElementById("searchEngineList");

    if(searchEngineList.classList.contains("hide")){
        showList();
    }else{
        hideList();
    }
});

function showList(){
    var searchEngineList = document.getElementById("searchEngineList");
    searchEngineList.classList.remove("hide");
    searchEngineList.classList.add("show");
}
function hideList(){
    var searchEngineList = document.getElementById("searchEngineList");
    searchEngineList.classList.remove("show");
    searchEngineList.classList.add("hide");
}
/*
 * EVENT LISTENERS
*/
document.getElementById("searchEngineList").addEventListener("click", function(e){
    if(e.target.tagName == "A"){
        document.searchForm.q.value = e.target.innerHTML + ":";
        document.searchForm.q.focus();
        hideList();
    }
});
document.getElementById("searchEngineList").addEventListener("mouseover", function(e){
    if(e.target.tagName == "A"){
        document.searchForm.q.value = e.target.innerHTML + ":";
    }
});
document.getElementById("searchEngineList").addEventListener("mouseleave", function(e){
    if(document.searchForm.q === document.activeElement){
        return;
    }else{
        document.searchForm.q.value = "";
        hideList();
    }
});

/*
 * BOOKMARKS LISTS
*/
// create the lists
function populateBookmarkList(){
    var container = document.getElementById("bookmarks");

    var name = Object.keys(bookmarks);

    // iterate over list and add items as list to container
    for(var i=0; i<name.length; i++){
        var ulnode = document.createElement("UL");
        var linode = document.createElement("LI");
        var textnode = document.createTextNode(name[i]);

        linode.appendChild(textnode);
        ulnode.appendChild(linode);

        for(var j=0; j<bookmarks[name[i]].length; j++){
            linode = document.createElement("LI");
            var anode = document.createElement("A");
            anode.setAttribute("href", bookmarks[name[i]][j].url);
            textnode = document.createTextNode(bookmarks[name[i]][j].sitename);

            anode.appendChild(textnode);
            linode.appendChild(anode);
            ulnode.appendChild(linode);
        }
        container.appendChild(ulnode);
    }
}


getTime();
setInterval(getTime, 1000);
populateSearchList();
populateBookmarkList();
