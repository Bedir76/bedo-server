FROM ubuntu:22.04

# Gerekli sistem araçlarını ve Java 21'i kuruyoruz
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# Playit.gg resmi Ubuntu deposunu ekliyoruz (404 vermesi imkansız resmi yol)
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# Bedrock destekli standalone Geyser paketini indiriyoruz
RUN wget -O Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# Geyser ayarını yapıp portu Render için 10000 yapıyoruz
RUN java -jar Geyser.jar --noop && \
    if [ -f config.yml ]; then sed -i 's/port: 19132/port: 10000/g' config.yml; fi

# Render için portu aç
EXPOSE 10000

# Hem yüklenecek olan playit programını hem de Geyser'ı tetikliyoruz
CMD playit --secret "$SECRET_KEY" > playit.log & java -Xmx400M -Xms400M -jar Geyser.jar
