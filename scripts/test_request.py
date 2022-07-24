import requests

if __name__ == "__main__":
    name = "Fred Astaire"
    response = requests.get("http://localhost:8000/people", params={"name": name})
    is_alive = response.json()["is_alive"]
    message = None
    if is_alive:
        print(f"{name} is alive.")
    else:
        print(f"{name} is NOT alive.")
