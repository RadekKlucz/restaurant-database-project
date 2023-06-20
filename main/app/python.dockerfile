FROM python:3.11

# Change work directory to app
WORKDIR /app

# Install dependencies
RUN pip install --upgrade pip
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the content of the local src directory to the working directory
COPY . .
CMD ["python", "./main.py"]