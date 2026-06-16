FROM ubuntu:22.04

# Sistem bileşenlerini ve Java 21'i kuruyoruz
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# Playit.gg'nin o Docker'da kullandığı 0.17 sürüm dosyasını doğrudan indiriyoruz
RUN wget -O playit https://github.com/playit-cloud/playit-agent/releases/download/v0.1.7/playit-linux-amd64 && \
    chmod +x playit

# Geyser Bedrock paketini indiriyoruz
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# Geyser ilk ayarını yapıp iç portu Render için 10000'e çekiyoruz
RUN java -jar Geyser.jar --noop && \
    if [ -f config.yml ]; then sed -i 's/port: 19132/port: 10000/g' config.yml; fi

# Render'ın zorunlu HTTP port taraması için 10000'i açıyoruz
EXPOSE 10000

# Playit 0.17 sürümünün orijinal komut yapısıyla tüneli ve sunucuyu aynı anda tetikliyoruz
CMD ./playit --secret "$SECRET_KEY" > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
