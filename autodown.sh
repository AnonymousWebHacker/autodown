#!/bin/bash

# Función para descargar y descomprimir el archivo
start_script() {
    url=$1
    filename=$(basename $url)
    tmp_dir="/opt/autodown/tmp" #Descarga temp
    target_dir="/var/www/html/ftp/Actualizacion_Antivirus" #root folder web
    config_file="/opt/autodown/autodown.conf" #Ruta de config
    logs_path="/opt/autodown/autodown.log" #Ruta de logs

    # Telegram KEY API Config
    telegram_api_token=$(grep "telegram_api_token" "$config_file" | cut -d'"' -f2)
    telegram_chat_id=$(grep "telegram_chat_id" "$config_file" | cut -d'"' -f2)

    # Obtener el $target_subdir para la URL actual
    if echo "$url" | grep -q "Nod32"; then
        target_subdir="nod32"
    elif echo "$url" | grep -q "antivirus.uclv.edu.cu"; then
        target_subdir="segurmatica"
    else
        echo "URL inválida"
        return
    fi
    check_updates
}

check_updates() {
    # Leer el archivo autodown.log y buscar la línea correspondiente a $target_subdir
    line=$(grep "$target_subdir" $logs_path)
    
    # Obtener la fecha de la update local en logs
    #remote_file=$(echo "$line" | awk -F'|' '{print $2}' | xargs)
    local_file=$(echo "$line" | awk -F'|' '{print $2}' | xargs)

    # Verificar si el archivo remoto se ha actualizado
    #local_file=$(echo "$line" | awk -F'|' '{print $2}' | xargs)
    remote_file=$(curl -sI $url | grep -i 'last-modified' | awk -F': ' '{print $2}')


    #if [[ "$local_file" == "$remote_file" ]]; then
    if [[ "$local_file" == "$remote_file" ]]; then
        echo "No se requiere descargar el archivo. El archivo remoto no se ha actualizado."
    #elif [[ "$local_file" != "$remote_file" && -n "$remote_file" ]]; then
    elif [[ "$local_file" != "$remote_file" && -n "$remote_file" ]] || [[ -z "$local_file" ]]; then
        # Eliminar la actualización vieja local
        rm -rf $tmp_dir/$filename
        #rm -rf $target_dir/$target_subdir/*
        #descargar_urls

       #descargar_url() {
        # Descargar el archivo
            wget --unlink #Limpiar cache
            wget  -P $tmp_dir $url
            #wget  --limit-rate=100k -T 50 -t 50 -P $tmp_dir $url

            unzip -tq "$tmp_dir/$filename" >/dev/null;
            if [ $? -eq 0 ]; then
                echo "El archivo $archivo está integro y sin errores."
            else
                echo "El archivo $archivo está dañado o corrupto."
                #descargar_url
            fi

        #}

        # Verificar si la descarga fue exitosa
        #if [ $? -eq 0 ]; then
            # Seleccionar el directorio de destino según la URL descargada
            #if [[ $url == *"uzsmart.ru"* ]]; then
            #    target_subdir="nod32"
            #elif [[ $url == *"antivirus.uclv.edu.cu"* ]]; then
            #    target_subdir="segurmatica"
            #else
            #    echo "URL inválida"
            #    return
            #fi
            #target_dir="$target_dir/$target_subdir"

            # Borrar archivos viejos en FTP
            rm -rf $target_dir/$target_subdir/*

            # Descomprimir el archivo
            case $filename in
            *.zip)
                unzip $tmp_dir/$filename -d $target_dir/$target_subdir/
                #Copiar Segurmatica.zip para ftp
                if [ $target_subdir = "segurmatica" ]; then
                    update_name=$(unzip -l $tmp_dir/$filename | awk '{ print $4 }' | head -n 4  | tail -n 1 | cut -d'/' -f1)
                    cp $tmp_dir/$filename $target_dir/$target_subdir/$update_name.zip
                fi
                ;;
            #*.rar)
            #    copy $tmp_dir/$filename -d $target_dir/$target_subdir/
            #    unrar x $tmp_dir/$filename -d $target_dir/$target_subdir/
            #    ;;
            *)
                echo "Formato de archivo no compatible"
                ;;
            esac

            echo "Archivo descargado y descomprimido correctamente"
            message="Nueva actualizacion $target_subdir disponible"

            # Envío del mensaje por Telegram
            #send_telegram_message "$message"

            # Actualizar el archivo autodown.log con los datos del archivo remoto
            #sed -i "/^${target_subdir} |/ s/\(.* | \).*/\1${remote_file}/" "/opt/autodown/autodown.log"
            if grep -q "^${target_subdir} |" "$logs_path"; then
                sed -i "s/^${target_subdir} |.*/${target_subdir} | ${remote_file}/" "$logs_path"
            else
                echo "${target_subdir} | ${remote_file}" >> "$logs_path"
            fi

        #else
        #    echo "Error al descargar el archivo"
        #fi
            # Envío del mensaje por Telegram
            send_telegram_message "$message"
    fi
}

# Función para enviar mensajes por Telegram
send_telegram_message() {
    message=$1
    curl -s -X POST "https://api.telegram.org/bot$telegram_api_token/sendMessage" -d "chat_id=$telegram_chat_id&text=$message"
}


# Leer el archivo autodown.conf en busca de URLs para descargar
urls=()
while IFS= read -r line; do
    # Verificar si la línea comienza con "d" (diariamente)
    if [[ $line == d* ]]; then
        # Obtener la URL de descarga eliminando el primer carácter ("d") y los espacios en blanco al inicio y al final
        url=$(echo $line | cut -c2- | xargs)
        urls+=("$url")
    fi
done < /opt/autodown/autodown.conf

# Iterar sobre las URLs y descargar/descomprimir los archivos
for url in "${urls[@]}"; do
    start_script "$url"
done

# Esperar 24 horas antes de intentar descargar nuevamente
sleep 24h