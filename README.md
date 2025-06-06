![banner-preview](https://github.com/user-attachments/assets/f90660f9-75da-428e-9f20-cc402bf5fe98)

# Install

```
opkg update && opkg install coreutils-df procps-ng-free procps-ng-uptime && wget -O /opt/etc/custom-banner.sh https://raw.githubusercontent.com/OMchik33/Keenetic-Entware-banner/main/custom-banner.sh && chmod +x /opt/etc/custom-banner.sh && grep -qxF '/opt/etc/custom-banner.sh' ~/.profile || echo '/opt/etc/custom-banner.sh' >> ~/.profile
```
