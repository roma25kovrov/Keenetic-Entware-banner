![banner-preview](https://github.com/user-attachments/assets/f90660f9-75da-428e-9f20-cc402bf5fe98)

# Install

```
opkg update && opkg install coreutils-df procps-ng-free procps-ng-uptime && wget -O /opt/etc/custom-banner.sh https://raw.githubusercontent.com/OMchik33/Keenetic-Entware-banner/main/custom-banner.sh && chmod +x /opt/etc/custom-banner.sh && grep -qxF '/opt/etc/custom-banner.sh' ~/.profile || echo '/opt/etc/custom-banner.sh' >> ~/.profile
```


* Materials from the article were used:
  
`https://forum.keenetic.ru/topic/16444-bash-%D0%BD%D0%B5%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE-%D0%BA%D1%80%B0%D1%81%D0%BE%D0%BA/`
