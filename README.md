![banner-preview](https://drm-play.kovrov.crazedns.ru:8443/Entware.jpg)


# Install

```
opkg update && \
opkg install curl wget wget-ssl bc coreutils-df procps-ng-free procps-ng-uptime && \
curl -fsSL -o /opt/etc/custom-banner.sh https://raw.githubusercontent.com/roma25kovrov/Keenetic-Entware-banner/refs/heads/main/custom-banner.sh && \
chmod +x /opt/etc/custom-banner.sh && \
grep -qxF '/opt/etc/custom-banner.sh' ~/.profile || echo '/opt/etc/custom-banner.sh' >> ~/.profile

```
# Unistall

```
rm -f /opt/etc/custom-banner.sh
sed -i '\/opt\/etc\/custom-banner\.sh/d' ~/.profile

```
---

* Materials from the article were used:
  
```
https://forum.keenetic.ru/topic/16444-bash-%D0%BD%D0%B5%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE-%D0%BA%D1%80%B0%D1%81%D0%BE%D0%BA/
```
