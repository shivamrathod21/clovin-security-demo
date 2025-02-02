FROM python:3.9-slim

WORKDIR /app

# Install system dependencies including MySQL client
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev gcc pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
