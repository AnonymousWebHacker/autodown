# autodown
Proceso automatizacion de  actualizaciones de antivirus Segurmatica y Nod32

## Como funciona
Descargue los fichero a la ruta `/opt/autodown`
Copie el autdown.service para `/etc/systemd/system/autodown.service`

## Configuracion
`autodown.conf` -> Modifica el tokern para Telegram y URLs de descargas

## Habilitar/Correr/Parar el servicio primera vez
```
systemctl enable autodown
systemctl start autodown
systemctl stop autodown
``