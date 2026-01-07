FROM python:3.11-slim

WORKDIR /app

# Install MySQL client dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Start uvicorn - shell form allows PORT variable expansion
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}
