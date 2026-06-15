# driveSync — Sincronización Automática con Google Drive

Este proyecto consiste en un script en Bash diseñado para sincronizar de manera segura una carpeta local con Google Drive utilizando **rclone**. Admite configuración externa, registro de logs y cifrado opcional de extremo a extremo (client-side encryption).

---

## Requisitos Previos

1. **rclone instalado**: El script busca el ejecutable en `/usr/bin/rclone`.
2. **Remoto de Google Drive configurado**: Debes configurar tu cuenta de Google Drive en `rclone` antes de ejecutar el script.
   ```bash
   rclone config
   ```
   *(Sigue los pasos e identifica el remoto creado, por ejemplo: `gdrive`)*.

---

## Configuración (`.env`)

El script no utiliza valores por defecto incorporados en el código. Requiere obligatoriamente un archivo llamado `.env` en el mismo directorio del script.

Crea un archivo `.env` en la raíz del proyecto y define las siguientes variables:

```env
# Ruta de la carpeta local que deseas respaldar
SOURCE_DIR="/home/usuario/Documentos"

# Nombre del remoto configurado en rclone
REMOTE_NAME="gdrive"

# Carpeta de destino en Google Drive
REMOTE_DIR="Backup_Documentos"

# Archivo donde se guardarán los registros (logs) del script
LOG_FILE="/home/usuario/driveSync/backup.log"

# Bandera para activar cifrado local antes de subir los archivos (true/false)
ENCRYPT=false

# Nombre del remoto 'crypt' configurado en rclone (requerido solo si ENCRYPT=true)
CRYPT_REMOTE_NAME="gdrive_crypt"
```

> [!IMPORTANT]
> Nunca subas el archivo `.env` a repositorios públicos de Git, ya que contiene información sobre las rutas locales de tu sistema. El archivo `.env` ya está añadido al `.gitignore` de este repositorio.

---

## Configuración de Cifrado de Extremo a Extremo (Opcional)

Si deseas cifrar tus archivos antes de que salgan de tu ordenador (de modo que ni Google pueda ver su contenido):

1. Configura un remoto de tipo **crypt** en `rclone`:
   ```bash
   rclone config
   ```
   * Elige la opción para crear un nuevo remoto (`n`).
   * Nómbralo (por ejemplo, `gdrive_crypt`).
   * Elige el tipo `crypt`.
   * Configúralo para que apunte a tu directorio de Drive existente, p. ej., `gdrive:Backup_Documentos`.
   * Elige si cifrar o no los nombres de los archivos.
   * Genera o introduce contraseñas seguras para el cifrado (y guárdalas muy bien).
2. En tu archivo `.env`, cambia las variables:
   ```env
   ENCRYPT=true
   CRYPT_REMOTE_NAME="gdrive_crypt"
   ```

---

## Uso

### Ejecución Manual

Para ejecutar el script manualmente, dale permisos de ejecución y lánzalo:

```bash
chmod +x backup_documentos.sh
./backup_documentos.sh
```

### Automatización con Cron

Puedes programar el script para que se ejecute automáticamente a intervalos regulares. Abre tu panel de crontab:

```bash
crontab -e
```

Añade las variables de entorno correspondientes y la línea del script para que se ejecute a la hora deseada (por ejemplo, todos los días a las 16:30):

```cron
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DRIVESYNC_DIR="/home/usuario/driveSync"

30 16 * * * $DRIVESYNC_DIR/backup_documentos.sh
```
