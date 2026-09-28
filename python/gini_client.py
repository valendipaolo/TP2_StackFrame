"""
Capa superior: consulta la API del Banco Mundial y delega el calculo a C.

Uso:
    python3 gini_client.py                 # Argentina, 2011-2020
    python3 gini_client.py BRA             # otro pais (codigo ISO3)
    python3 gini_client.py --file x.json   # usa un JSON guardado (sin red)
"""
import argparse
import ctypes
import json
import pathlib
import sys

import requests

API_URL = "https://api.worldbank.org/v2/country/{pais}/indicator/SI.POV.GINI"
LIB_PATH = pathlib.Path(__file__).resolve().parent.parent / "build" / "libgini.so"


def cargar_lib():
    lib = ctypes.CDLL(str(LIB_PATH))
    lib.gini_to_int_plus1.argtypes = (ctypes.c_double,)
    lib.gini_to_int_plus1.restype = ctypes.c_long
    return lib


def obtener_json(pais, desde, hasta):
    params = {"format": "json", "date": f"{desde}:{hasta}", "per_page": 100}
    resp = requests.get(API_URL.format(pais=pais), params=params, timeout=15)
    resp.raise_for_status()
    return resp.json()


def extraer_datos(payload):
    """La API devuelve [metadata, registros]. Descarta anios sin dato."""
    if not isinstance(payload, list) or len(payload) < 2 or payload[1] is None:
        raise ValueError(f"Respuesta inesperada de la API: {payload}")
    datos = [
        (int(r["date"]), float(r["value"]), r["country"]["value"])
        for r in payload[1]
        if r.get("value") is not None
    ]
    return sorted(datos)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("pais", nargs="?", default="ARG")
    ap.add_argument("--desde", type=int, default=2011)
    ap.add_argument("--hasta", type=int, default=2020)
    ap.add_argument("--file", help="JSON local en vez de consultar la API")
    args = ap.parse_args()

    payload = (json.loads(pathlib.Path(args.file).read_text())
               if args.file else obtener_json(args.pais, args.desde, args.hasta))
    datos = extraer_datos(payload)
    if not datos:
        print("Sin datos de GINI para ese rango.")
        return 1

    lib = cargar_lib()
    print(f"Pais: {datos[0][2]}")
    print(f"{'Anio':>6} | {'GINI':>6} | {'int+1 (C)':>9}")
    print("-" * 28)
    for anio, gini, _ in datos:
        print(f"{anio:>6} | {gini:>6.1f} | {lib.gini_to_int_plus1(gini):>9}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
