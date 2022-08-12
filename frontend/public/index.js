var a = document.getElementById('search-bar');
var answer = document.getElementById('answer');
var b = document.getElementById("submitbutton");

var searchResults = []

function buildMessage(apiResponse) {
    let message = null;
    if (apiResponse == null) {
        apiResponse = []
    }
    let apiResponseLength = Object.keys(apiResponse).length;
    if (apiResponseLength == 0) {
        message = "NOT (Unknown Person)"
    }
    else {
        message = apiResponse[0].is_alive ? 'ALIVE' : 'NOT'
    }
    return message
  }

async function runRequest(e) {
    var inputName = document.getElementById('search-bar').value;
    let response = await fetch("/api/people?" + new URLSearchParams({"search": inputName})).then();
    let data = response.json();
    return data
}

function runOnEnter(e) {
    if (e.keyCode == 13) {
        console.log("here");
        runRequest(e);
    }
}

async function autocompleteMatch(input) {
  if (input == '') {
    return [];
  }

  return await runRequest(input)
}

async function showResults(val) {
    answer = document.getElementById("answer");
    answer.innerHTML = "";
    res = document.getElementById("results-list");
    res.innerHTML = '';
    let list = '';
    let terms = await autocompleteMatch(val);
    searchResults = terms
    for (i=0; i<terms.length; i++) {
        list += '<li data-id="' + terms[i]["id"] +'">' + terms[i]["name"] + '</li>';
    }
    res.innerHTML = list;
}

async function getAliveStatus(id) {
    let response = await fetch("/api/people/" + id);
    let data = response.json();
    return data
}


var ul = document.getElementById('results-list');
ul.onclick = function(event) {
    var target = event.target;
    if (target.nodeName == "LI") {
      getAliveStatus(target.dataset.id).then(
        (data) => {
            box = document.getElementById("search-bar");
            console.log(target);
            box.value = target.innerText
            res = document.getElementById("results-list");
            res.innerHTML = "";
            answer = document.getElementById("answer");
            if (data.is_alive) {
                answer.innerHTML = "<H2>ALIVE</H2>";
            } else {
                answer.innerHTML = "<H@>NOT</H2>";
            }
        }
      )
    }
};

