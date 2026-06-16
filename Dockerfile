FROM ubuntu:22.04

# Gerekli sistem araçlarını ve Java 17'yi kur
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    curl \
    wget \
    unzip \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# Playit.gg resmi reposunu ekle ve playit aracını kur
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# Bedrock destekli standalone Geyser paketini indir
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# Başlatma scriptini içeri aktar ve çalıştırma izni ver
COPY start.sh /minecraft/start.sh
RUN chmod +x /minecraft/start.sh

# Render'ın sistemi kapatmaması için port açıyoruz
EXPOSE 10000

CMD ["./start.sh"]
