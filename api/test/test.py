import requests

def test_home():
    url = "https://localhost:8080/api"
    response = requests.get(url, verify=False)
    assert response.json() == {"message":"Hello World"}

def show_search():
    url = "https://localhost:8080/api/people"
    params = {"search": "har"}
    response = requests.get(url, verify=False, params=params)
    print(response.json())

if __name__ == "__main__":
    show_search()