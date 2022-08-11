var a = document.getElementById('search-bar');
var answer = document.getElementById('answer');
var b = document.getElementById("submitbutton");

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
    console.log(response)
    let data = response.json();
    return data
}

function runOnEnter(e) {
    if (e.keyCode == 13) {
        console.log("here");
        runRequest(e);
    }
}



var search_terms = ['apple', 'apple watch', 'apple macbook', 'apple macbook pro', 'iphone', 'iphone 12'];

async function autocompleteMatch(input) {
  if (input == '') {
    return [];
  }

  return await runRequest(input)
}

async function showResults(val) {
    res = document.getElementById("results-list");
    res.innerHTML = '';
    let list = '';
    let terms = await autocompleteMatch(val);
    console.log(terms.length)
    for (i=0; i<terms.length; i++) {
        list += '<li>' + terms[i]["name"] + '</li>';
    }
    res.innerHTML = list;
}


var ul = document.getElementById('results-list');
ul.onclick = function(event) {
    var target = event.target;
    alert(event.target.innerHTML);
};  