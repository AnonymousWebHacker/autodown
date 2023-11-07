# autodown
Servicio de  automatizacion para autodescargar actualizaciones de antivirus Segurmatica y Nod32 en Cuba.


## Como instalar
`wget https://raw.githubusercontent.com/AnonymousWebHacker/autodown/main/autodown_installer -O /tmp/autodown_installer.sh && sudo sh autodown_installer.sh`

Simplemente modifique su configuracion y corra el servicio.

## Como funciona de forma manual?
Descargue los fichero a la ruta `/opt/autodown`
Copie el autdown.service para `/etc/systemd/system/autodown.service`

## Ayuda en Configuracion
`autodown.conf`
Puede notificar por Telegram sus actualizacione.

Modifica el token para Telegram y URLs de descargas
```
# Telegram KEY API Config
telegram_api_token="token_here"
telegram_chat_id="@channel"
```
Modifica las URL de descargas
```
# Lista de URLS a decargar
# d -- diariamentes
# s -- semanal
#d http://antivirus.uij.edu.cu/nod32/nod32.zip
d https://url/segurmatica/update.zip
d http://url/nod32/update.zip
```

## Habilitar/Correr/Parar el servicio primera vez
```
systemctl enable autodown
systemctl start autodown
systemctl stop autodown
```