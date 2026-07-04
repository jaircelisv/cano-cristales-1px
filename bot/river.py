#!/usr/bin/env python3
"""Genera el trazado de Caño Cristales para el canvas: un río serpenteante
de 5 colores que fluye en diagonal pasando junto al pixel (295,487).
Excluye pixeles ya comprados (solo vírgenes a $0.005) y respeta el tope de $1."""
import json, math, urllib.request

X0, Y0, X1, Y1 = 272, 462, 322, 512   # nace arriba-izquierda, muere abajo-derecha
STEPS = 90
AMP, WAVES = 6.0, 2.5                  # meandro
WIDTH = 2                              # ancho del río en px
PIXEL_RETO2 = (295, 487)               # intocable: es la entrega del reto 2
COLORS = ["#C1121F", "#E9C46A", "#2A9D8F", "#219EBC", "#22223B"]

grid = json.load(urllib.request.urlopen("https://www.frontpage.sh/api/million/grid"))
items = grid if isinstance(grid, list) else grid.get("pixels", grid.get("items", []))
owned = {(p["x"], p["y"]) for p in items}

dx, dy = X1 - X0, Y1 - Y0
L = math.hypot(dx, dy)
ux, uy = dx / L, dy / L          # dirección del río
px_, py_ = -uy, ux               # perpendicular (para el meandro y el ancho)

seen, path = set(), []
for i in range(STEPS + 1):
    t = i / STEPS
    off = AMP * math.sin(t * WAVES * 2 * math.pi)
    cx = X0 + dx * t + px_ * off
    cy = Y0 + dy * t + py_ * off
    for w in range(WIDTH):
        x = round(cx + px_ * w * 0.9)
        y = round(cy + py_ * w * 0.9)
        if not (0 <= x < 1000 and 0 <= y < 1000):
            continue
        if (x, y) in seen or (x, y) == PIXEL_RETO2 or (x, y) in owned:
            continue
        seen.add((x, y))
        path.append({"x": x, "y": y, "rgb": COLORS[min(int(t * 5), 4)], "t": t})

pixels = [{"x": p["x"], "y": p["y"], "rgb": p["rgb"]} for p in path]
total = len(pixels) * 0.005
assert total <= 1.00, f"presupuesto excedido: ${total}"
print(json.dumps({"count": len(pixels), "estUsd": round(total, 3), "pixels": pixels}))
