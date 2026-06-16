# 1. Aşama: Temel Ubuntu 22.04
FROM ubuntu:22.04

# 2. Aşama: Gerekli sistem paketlerini kur
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# 3. Aşama: Çalışma dizinini ayarla
WORKDIR /minecraft

# 4. Aşama: Playit.gg kurulumu
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# 5. Aşama: Geyser kurulumu
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone
RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > config.yml

# 6. Aşama: Playit yapılandırması (Anahtarı dosya içine yazıyoruz)
RUN echo "secret_key = \"$SECRET_KEY\"" > playit.toml

# 7. Aşama: Render portunu aç
EXPOSE 10000

# 8. Aşama: Başlatma (Parametre vermeden, sadece dosya okumasına bırakıyoruz)
CMD playit > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
