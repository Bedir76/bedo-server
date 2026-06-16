FROM ubuntu:22.04

# Gerekli araçları kur
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini sabit tutuyoruz
WORKDIR /minecraft

# Playit.gg kurulumu
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# Geyser kurulumu
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone
RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > config.yml

# Playit'in config dosyasını /minecraft içine yazıyoruz (Artık orada bizi bekleyecek)
RUN echo "secret_key = \"$SECRET_KEY\"" > playit.toml

EXPOSE 10000

# Playit servis hatası vermesin diye onu direkt komut satırından çağırıyoruz
CMD playit --config playit.toml > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
