var a = document.getElementById('aon-searchbar');
var result = document.getElementById('aon-result');
a.addEventListener('submit',function(e) {
    e.preventDefault();
    var inputName = document.getElementById('aon-textfield').value;
    fetch("/api/people?" + new URLSearchParams({"name": inputName}))
        .then(response => response.json())
        .then(data => {
            is_alive = data.is_alive ? 'ALIVE' : 'NOT'
            result.innerHTML = `<h1>${is_alive}</h1>`;
        });
});
