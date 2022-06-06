# Getting API Service set up
- Install python (tested with python 3.9).
- Clone this repo.
- Navigate to this repo in your command line.
- Create a virtual environment for this project (e.g. python3.9 -m venv venv)
- Activate virtual environment (source ./venv/bin/activate or .\venv\bin\activate.exe or something on windows)
- Install requirements (pip install -r requirements.txt)
- Install testing requirements (pip install -r requirements-test.txt)
- Run the server (python -m uvicorn app:app --reload)
- Run a test script to see whether Fred Astaire is alive (python ./scripts/test_request.py)