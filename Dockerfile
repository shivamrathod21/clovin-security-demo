FROM python:3.9-slim

WORKDIR /app

# Install system dependencies for MySQL
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Environment variables
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
