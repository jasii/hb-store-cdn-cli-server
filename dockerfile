# Use a base image
FROM ubuntu:latest

# Set environment variables
ENV HOST=192.168.1.20
ENV PORT=6449
ENV BASE_PATH=/pkg

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip

# Create a working directory
WORKDIR /app

# Download the repository
RUN wget https://github.com/Gkiokan/hb-store-cdn-cli-server/archive/refs/heads/master.zip && \
    unzip master.zip && \
    rm master.zip && \
    mv hb-store-cdn-cli-server-master/* . && \
    rm -r hb-store-cdn-cli-server-master

# Download the binary
RUN wget https://github.com/Gkiokan/hb-store-cdn-cli-server/releases/download/v1.4.1/hb-store-cdn-cli-server-linux
RUN mv hb-store-cdn-cli-server-linux ./hb-store-cli-server-linux
RUN chmod +x ./hb-store-cli-server-linux

# Create a config.ini file
RUN echo "host=$HOST" > config.ini && \
    echo "port=$PORT" >> config.ini && \
    echo "basePath=/pkg" >> config.ini && \
    echo "binVersion=4.5" >> config.ini

# Expose the /assets folder as a volume
VOLUME ["/assets"]

# Run the script
CMD ["./hb-store-cli-server-linux", "start"]
