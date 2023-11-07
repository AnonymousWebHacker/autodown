<p align="center">
    <b>AutoDown - Servicio de descarga automatica de Antivirus</b><br>
<a href="https://github.com/AnonymousWebHacker/autodown/wiki">View Wiki</a> | <a href="https://github.com/AnonymousWebHacker">Mi Perfil</a> 
</p>


<p align="center">
| <a
  <img src="https://img.shields.io/github/commit-activity/m/AnonymousWebHacker/autodown" alt="Commits-per-month">
</a>
<a href="https://www.gnu.org/licenses/gpl-3.0" alt="License: GPLv3"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg">
</a>
</p>

# AutoDown
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