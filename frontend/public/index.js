var a = document.getElementById('aon-searchbar');
var result = document.getElementById('aon-result');

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
  

a.addEventListener('submit',function(e) {
    e.preventDefault();
    var inputName = document.getElementById('aon-textfield').value;
    fetch("/api/people?" + new URLSearchParams({"search": inputName}))
        .then(response => response.json())
        .then(data => {
            message = buildMessage(data)
            result.innerHTML = `<h1>${message}</h1>`;
        });
});
