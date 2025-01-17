FROM python:3.8.12-alpine

WORKDIR /usr/local/app/main/

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development

COPY requirements.txt /usr/local/app/main/
RUN pip install -r /usr/local/app/main/requirements.txt

COPY requirements.txt /usr/local/app/main/
COPY *.py /usr/local/app/main/

# Run flask on port 8080
CMD ["flask", "run", "-p", "8080"]