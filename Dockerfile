FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > config.yml

# BURAYA DİKKAT: Anahtarı bir dosyaya yazıp playit'e okutuyoruz
RUN echo "secret_key = \"$SECRET_KEY\"" > playit.toml

EXPOSE 10000

# Komutsuz (sadece playit yazarak) başlatıyoruz, o zaten playit.toml'u okuyacak
CMD playit --config playit.toml > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
