FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    curl \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini /etc/playit yapıyoruz çünkü playit burada config arar
WORKDIR /etc/playit

# Playit kurulumu
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list \
    && apt-get update && apt-get install -y playit

# Geyser kurulumu
RUN wget -O /minecraft/Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone
RUN echo "bedrock:\n  port: 10000\nremote:\n  address: auto" > /minecraft/config.yml

# Anahtarı playit'in beklediği yere yazıyoruz
RUN echo "secret_key = \"$SECRET_KEY\"" > playit.toml

EXPOSE 10000

# Sadece 'playit' komutunu çalıştırıyoruz, o kendi toml dosyasını görecek
CMD playit > playit.log & java -Xmx400M -Xms400M -jar /minecraft/Geyser.jar
