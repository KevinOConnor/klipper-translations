# OctoPrint para Klipper

Klipper tiene algunas opciones para sus interfaces, Octoprint fue la primera y original interfaz para Klipper. Este documento dará una breve visión general de la instalación con esta opción.

## Instalar con OctoPi

Comienza instalando [OctoPi](https://github.com/guysoft/OctoPi) en el ordenador Raspberry Pi. Utiliza OctoPi v0.17.0 o posterior - consulta las [versiones de OctoPi](https://github.com/guysoft/OctoPi/releases) para obtener información sobre la versión.

Debes comprobar que OctoPi se inicia y que el servidor web OctoPrint funciona. Tras conectarse a la página web de OctoPrint, sigue las instrucciones para actualizar OctoPrint si es necesario.

Después de instalar OctoPi y actualizar OctoPrint, será necesario hacer ssh en la máquina de destino para ejecutar un puñado de comandos del sistema.

Start by running these commands on your host device:

**Si no tienes git instalado, por favor hazlo con:**

```
sudo apt install git
```

y luego prosigue:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Lo anterior descargará Klipper, instalará las dependencias del sistema necesarias, configurará Klipper para que se ejecute al iniciar el sistema e iniciará el software anfitrión de Klipper. Requiere una conexión a Internet y puede tardar unos minutos en completarse.

## Instalando con KIAUH

KIAUH puede usarse para instalar OctoPrint en una variedad de sistemas basados en Linux que ejecuten una forma de Debian. Encontrarás más información en https://github.com/dw-0/kiauh

## Configurando OctoPrint para utilizar Klipper

Es necesario configurar el servidor web OctoPrint para que se comunique con el software anfitrión Klipper. Mediante un navegador web, inicia sesión en la página web de OctoPrint y, a continuación, configura los siguientes elementos:

Vete a la pestaña Configuración (el icono de llave inglesa en la parte superior de la página). En "Conexión serie" en "Puertos serie adicionales" añadir:

```
~/printer_data/comms/klippy.sock
```

A continuación, haz clic en "Guardar".

*En algunas configuraciones antiguas esta dirección puede ser `/tmp/printer`*

Vuelve a entrar en la pestaña Configuración y en "Conexión serie" cambia la configuración de "Puerto serie" por la añadida anteriormente.

En la pestaña "Configuración", vete a la subpestaña "Comportamiento" y selecciona la opción "Cancelar cualquier impresión en curso pero permanecer conectado a la impresora". Haz clic en "Guardar".

Desde la página principal, en la sección "Conexión" (en la parte superior izquierda de la página) asegúrate de que el "Puerto serie" está ajustado al nuevo añadido y haz clic en "Conectar". (Si no estás en la selección disponible, intenta recargar la página).

Una vez conectado, vete a la pestaña "Terminal" y escribe "status" (sin las comillas) en el cuadro de entrada de comandos y haz clic en "Enviar". La ventana del terminal probablemente informará de que hay un error al abrir el archivo de configuración, lo que significa que OctoPrint se está comunicando correctamente con Klipper.

Consulta <Installation.md> y la sección *Construcción y flasheo del microcontrolador*
