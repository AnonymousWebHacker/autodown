# autodown
Servicio de  automatizacion para autodescargar actualizaciones de antivirus Segurmatica y Nod32 en Cuba.

# Wiki
Visite  nuestra Wiki para mas ajuste
https://github.com/AnonymousWebHacker/autodown/wiki


## Como instalar el servicio
```
wget https://raw.githubusercontent.com/AnonymousWebHacker/autodown/main/autodown_installer -O /tmp/autodown_installer.sh && sudo sh /tmp/autodown_installer.sh
```

## Ayuda en Configuracion
https://github.com/AnonymousWebHacker/autodown/wiki

## Habilitar/Correr/Parar el servicio primera vez
```
systemctl enable autodown
systemctl start autodown
systemctl stop autodown
```