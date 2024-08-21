https://www.cloudskillsboost.google/games/5395/labs/35014




Sample Python
-------------

Setup Local Python Environment:

(If the Python install fails, see: https://github.com/pyenv/pyenv/wiki/Common-build-problems)

```
git clone https://github.com/pyenv/pyenv.git .pyenv
export PYENV_ROOT=.pyenv
.pyenv/bin/pyenv install
eval "$(.pyenv/bin/pyenv init --path)"
python -m venv venv
source venv/bin/activate
pip install -U pip
pip install -r requirements.txt
```

Run the server locally:
```
python main.py
```

Check it out: http://localhost:8080

Run Locally with Buildpacks & Docker:
```
pack build --builder=gcr.io/buildpacks/builder sample-python
docker run -it -ePORT=8080 -p8080:8080 sample-python
```

Run on Cloud Run:

[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run)



curl $SERVICE_URL -H 'Content-Type: application/json' -d '{"text" : "Welcome to this sample app, built with Google Cloud buildpacks."}'