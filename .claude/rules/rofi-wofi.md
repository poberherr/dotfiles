---
paths:
  - ".config/rofi/**"
  - ".config/wofi/**"
---
# Rofi & Wofi Rules
- Rofi uses `.rasi` format (its own DSL, not CSS/JSON). Theme at `themes/dark.rasi`, referenced via `@theme "dark"` in `config.rasi`.
- Wofi config is simple `key=value` format. Wofi style is standard CSS.
