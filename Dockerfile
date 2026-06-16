# 1. Aşama: Temel Ubuntu ve Java Kurulumu
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# 2. Aşama: Playit.gg Resmi Kurulumu
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# 3. Aşama: Geyser Bedrock Kurulumu
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# 4. Aşama: Yapılandırma (Port 10000)
RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > config.yml

# 5. Aşama: Başlatma Komutu
# playit run --secret kullanımı, doğrudan kimlik doğrulamayı tetikler
EXPOSE 10000
CMD playit run --secret "$SECRET_KEY" > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
