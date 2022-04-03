FROM python:3.10.4-slim-bullseye

COPY . .

RUN ./scripts/install.sh

CMD [ "python", "./examples/transactions.py" ]
