FROM ubuntu:22.04

# Gerekli sistem araçlarını ve Java 21'i kuruyoruz
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# Playit.gg resmi Ubuntu deposunu ekliyoruz
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# Geyser Bedrock paketini indiriyoruz
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# Geyser ayar dosyasını manuel oluşturup portu 10000 yapıyoruz (Hata vermeyen güvenli yol)
RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > config.yml

# Render için portu aç
EXPOSE 10000

# Yeni sürüm playit komutu ve Geyser'ı çakışmasız başlatıyoruz
CMD playit > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
