# Getting API Service set up
- Install python (tested with python 3.9).
- Clone this repo.
- Navigate to this repo in your command line.
- Create a virtual environment for this project (e.g. python3.9 -m venv venv)
- Activate virtual environment (source ./venv/bin/activate or .\venv\bin\activate.exe or something on windows)
- Install requirements (pip install -r requirements.txt)
- Install testing requirements (pip install -r requirements-test.txt)
- Download the test sqlitedb and put it in this folder, with name db.sqlite.  File can be downloaded from here https://drive.google.com/file/d/1HeNODaXBGROObTxqTzrwOEOjBcRVhNXx/view?usp=sharing
- Run the server (python -m uvicorn app:app --reload)
- Run a test script to see whether Fred Astaire is alive (python ./scripts/test_request.py)

# Getting front end set up
You can just open an HTML file in your browser, but when you have HTML that uses javascript to call a backend API you can run into CORS problems.
To work around that for the moment for local development, use the node package http-server (https://www.npmjs.com/package/http-server) to serve the
HTML and javascript files.

- First install node.js and NPM (here is how to do it on windows https://phoenixnap.com/kb/install-node-js-npm-on-windows  Install the latest LTS release of node)
- Once you have that follow the above link to install http-server package. (https://www.npmjs.com/package/http-server) (e.g. npm install --global http-server)
- Navigate to the ./frontend/public path in this repo (e.g. cd ./frontend/public)
- Run the http server (run command http-server)
- Navigate to http://127.0.0.1:8080 in your browser
- If you run this and the API at the same time, you can use the browser to see if someone is alive or not.
