FROM python:3.12.12-slim AS builder

#docker build . -t orders-api --build-arg ARG_PYTHONUNBUFFERED=1
#ARG ARG_PYTHONUNBUFFERED
#ENV PYTHONUNBUFFERED=${ARG_PYTHONUNBUFFERED}

WORKDIR /opt/api

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12.12-slim AS runner

COPY --from=builder /opt/api /opt/api

COPY app/main.py /opt/api/main.py

EXPOSE 8000

CMD ["python", "/opt/api/main.py"]