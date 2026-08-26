import urllib.request
import json
import zipfile
import os

RESOURCE_ID = "22660766-be75-4b78-a255-5666dfa06764"
ZIP_DEST = "ven_buildings.gdb.zip"

print("1. Consultando la API oficial de HDX para obtener el enlace de descarga actualizado...")
api_url = f"https://data.humdata.org/api/3/action/resource_show?id={RESOURCE_ID}"

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

try:
    req = urllib.request.Request(api_url, headers=headers)
    with urllib.request.urlopen(req) as response:
        res_data = json.loads(response.read().decode('utf-8'))
        download_url = res_data['result']['url']
        print(f"¡Enlace de descarga obtenido exitosamente!")
except Exception as e:
    print(f"Error al consultar la API: {e}")
    exit()

print("\n2. Descargando la base de datos de edificaciones de Venezuela (808 MB)...")
print("Por favor espera, este proceso puede tardar un par de minutos según tu velocidad de internet.\n")

try:
    req_dl = urllib.request.Request(download_url, headers=headers)
    with urllib.request.urlopen(req_dl) as response, open(ZIP_DEST, 'wb') as out_file:
        meta = response.info()
        file_size = int(meta.get("Content-Length", 0))
        downloaded = 0
        block_size = 8192 * 16

        while True:
            buffer = response.read(block_size)
            if not buffer:
                break
            downloaded += len(buffer)
            out_file.write(buffer)
            if file_size > 0:
                percent = downloaded * 100 / file_size
                print(f"\rProgreso: {percent:.1f}% ({downloaded / (1024*1024):.1f} MB / {file_size / (1024*1024):.1f} MB)", end="")

    print("\n\n¡Descarga finalizada con éxito!")
except Exception as e:
    print(f"\nError durante la descarga: {e}")
    exit()

if os.path.exists(ZIP_DEST):
    print("\n3. Descomprimiendo el archivo Geodatabase (.gdb)...")
    with zipfile.ZipFile(ZIP_DEST, 'r') as zip_ref:
        zip_ref.extractall(".")
    print("¡Descompresión completada!")
    print("\n--- ¡PROCESO FINALIZADO! ---")
    print("La carpeta .gdb se encuentra lista en el directorio actual.")

