# 🌈 Caño Cristales 1px

**Un río entero en un pixel.** Entrega para el Reto 2 (One Pixel Challenge) del Dev Racing × [frontpage.sh/million](https://www.frontpage.sh/million).

## El concepto

El pixel **(295, 487)** es [Caño Cristales](https://es.wikipedia.org/wiki/Ca%C3%B1o_Cristales), el "río de los cinco colores" de La Macarena, Colombia — considerado el río más hermoso del mundo. Solo entre junio y noviembre la planta endémica *Macarenia clavigera* lo tiñe de rojo. **Hoy el río está en temporada, y este pixel también.**

Tres capas de significado en un solo pixel:

1. **Posición** — si el canvas de 1000×1000 fuera un mapamundi equirectangular, (295, 487) cae exactamente sobre La Macarena:
   - `x = (180 − 73.7871°W) / 360 × 1000 = 295`
   - `y = (90 − 2.2547°N) / 180 × 1000 = 487`
2. **Tiempo** — un bot recompra el pixel y lo hace fluir por los 5 colores reales del río (rojo → amarillo → verde → azul → negro). Es el único pixel del board que *fluye*. Cada recompra duplica el precio: el ciclo de 5 colores cuesta $0.155 en total — economía consciente, como manda el brief.
3. **Click** — el label cuenta la etapa del río en hover, y el link abre un sitio bilingüe (ES/EN) con fotos reales, el estado del pixel en vivo vía la API del canvas, y la historia del río.

## Demo

- 🌐 Sitio: https://jaircelisv.github.io/cano-cristales-1px/
- 🎨 El pixel: https://www.frontpage.sh/api/million/pixel?x=295&y=487
- 🖼️ En el canvas: https://www.frontpage.sh/million (busca el punto que cambia de color)

## Stack

- Pagos: USDC en la red [Tempo](https://tempo.xyz) (mainnet) vía MPP — `tempo request` maneja el 402 Payment Required automáticamente.
- Bot: [`bot/cycle.sh`](bot/cycle.sh) — quote → buy → verify por cada color, con `--max-spend` como cinturón de seguridad.
- Sitio: HTML/CSS/JS vanilla, GitHub Pages. Fotos CC BY-SA de Wikimedia Commons (créditos en el footer).

## Correr el ciclo

```bash
./bot/cycle.sh 0 90   # las 5 etapas, una cada 90 segundos
./bot/cycle.sh 2      # retomar desde la etapa 3 (verde)
```

---
🏁 *Release Before Ready.* Hecho con Claude Code durante el race.
