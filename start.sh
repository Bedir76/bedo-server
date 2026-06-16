#!/bin/bash

# Geyser'ın ilk ayar dosyasını (config.yml) oluşturması için boşta bir kere tetikliyoruz
if [ ! -f config.yml ]; then
    java -jar Geyser.jar --noop
    # Geyser'ın iç portunu Render uyumlu olması için 10000 yapıyoruz
    if [ -f config.yml ]; then
        sed -i 's/port: 19132/port: 10000/g' config.yml
    fi
fi

# Playit gizli anahtar kontrolü
if [ -z "$SECRET_KEY" ]; then
    echo "HATA: SECRET_KEY ortam degiskeni Render panelinde girilmemis!"
    exit 1
fi

# Yeni playit sürümüne uygun komut yapısı ile arka planda UDP tünelini başlatıyoruz
playit run --secret-key "$SECRET_KEY" > playit.log &

echo "========================================="
echo "=== BEDROCK SUNUCUSU ACILIYOR ==="
echo "Playit panelinden baglanti durumunu izleyin."
echo "========================================="

# 512MB RAM sınırını aşmamak için sunucuyu 400MB ile sınırlıyoruz
java -Xmx400M -Xms400M -jar Geyser.jar
