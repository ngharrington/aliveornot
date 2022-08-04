var a = document.getElementById('search-bar');
var result = document.getElementById('result');
var b = document.getElementById("submitbutton");

function buildMessage(apiResponse) {
    let message = null;
    if (apiResponse == null) {
        apiResponse = []
    }
    let apiResponseLength = Object.keys(apiResponse).length;
    console.log(apiResponse);
    if (apiResponseLength == 0) {
        message = "NOT (Unknown Person)"
    }
    else {
        message = apiResponse[0].is_alive ? 'ALIVE' : 'NOT'
    }
    return message
  }

function runRequest(e) {
    var inputName = document.getElementById('search-bar').value;
    fetch("/api/people?" + new URLSearchParams({"search": inputName}))
        .then(response => response.json())
        .then(data => {
            message = buildMessage(data)
            result.innerHTML = `<h1>${message}</h1>`;
        });
}

function runOnEnter(e) {
    if (e.keyCode == 13) {
        runRequest(e);
    }
}
  

// b.addEventListener('click', function(e) {
//     e.preventDefault();
//     runRequest();
// });
