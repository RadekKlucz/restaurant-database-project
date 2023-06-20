FROM mcr.microsoft.com/mssql/server:2022-CU4-ubuntu-20.04

# Set the working directory 
WORKDIR /usr/src/app

# Copy the current directory contents into the working directory
COPY . /usr/src/app/

# Needed environment variables
ENV SA_PASSWORD=password123!
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express

# Expose application at port 1433
EXPOSE 1433

# Run the entrypoint script
CMD /bin/bash ./entrypoint.sh