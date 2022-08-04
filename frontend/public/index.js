var a = document.getElementById('search-bar');
var result = document.getElementById('result');
var b = document.getElementById("submitbutton");

function buildMessage(apiResponse) {
    let message = null;
    console.log(apiResponse)
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
  

b.addEventListener('click', function(e) {
    e.preventDefault();
    var inputName = document.getElementById('search-bar').value;
    fetch("/api/people?" + new URLSearchParams({"search": inputName}))
        .then(response => response.json())
        .then(data => {
            message = buildMessage(data)
            result.innerHTML = `<h1>${message}</h1>`;
        });
});
