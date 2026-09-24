#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ref = json.loads((ROOT / "levels/reference/level_01_original.json").read_text())
web = json.loads((ROOT / "levels/web/level_01_web_16_9.json").read_text())
legend = (ROOT / "docs/levels/LEGEND.md").read_text()

def fail(msg):
    raise SystemExit(f"FAIL: {msg}")

ref_objects = {o["id"]: o for o in ref["objects"]}
web_objects = {o["id"]: o for o in web["objects"]}
if len(ref_objects) != len(ref["objects"]): fail("IDs duplicados en original")
if len(web_objects) != len(web["objects"]): fail("IDs duplicados en web")
for obj in ref["objects"]:
    if obj["symbol"] not in legend: fail(f"símbolo sin leyenda: {obj['symbol']}")
    if obj["id"] not in web_objects: fail(f"objeto no rastreable: {obj['id']}")
for obj in web["objects"]:
    if obj["symbol"] not in legend: fail(f"símbolo web sin leyenda: {obj['symbol']}")
    if obj.get("source_id") not in ref_objects: fail(f"source_id inexistente: {obj.get('source_id')}")
if ref["dimensions"] != {"width": 256, "height": 240, "unit": "logical_pixel", "status": "VERIFICADO"}:
    fail("dimensiones originales inesperadas")
if web["metadata"]["source_level"] != ref["metadata"]["id"]: fail("fuente web incorrecta")
if web["metadata"]["status"] != "proposal": fail("web no marcada como propuesta")
if len(ref.get("screen_signatures", [])) != 19: fail("faltan firmas visuales del ROM")
for signature in ref["screen_signatures"]:
    if len(signature["signature"]) != signature["columns"]: fail("firma visual con columnas incorrectas")
    if signature["tile_size"] != 8: fail("grid visual inesperado")
if ref["evidence"]["screen_band_spacing"] != 48: fail("separación visual no coincide")
print(f"OK: {len(ref_objects)} objetos originales, {len(web_objects)} rastreables, leyenda e incertidumbres comprobadas")
