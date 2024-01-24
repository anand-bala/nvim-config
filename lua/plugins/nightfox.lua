--- Colorscheme
---
--- # My Colorblindness simulation
---
--- Source: https://daltonlens.org/evaluating-cvd-simulation/#Generating-Ishihara-like-plates-for-self-evaluation
---
--- | Plate method           | Protan | Deutan | Tritan |
--- | ---------------------- | ------ | ------ | ------ |
--- | Brettel 1997 sRGB      | 0.4    | 0.9    | 0.1    |
--- | Vischeck (Brettel CRT) | 0.3    | 0.9    | 0.1    |
--- | Viénot 1999 sRGB       | 0.4    | 0.9    | 0.1    |
--- | Machado 2009 sRGB      | 0.4    | 0.8    | 0.1    |

require("nightfox").setup {
  options = {
    colorblind = {
      enable = true,
      severity = {
        protan = 0.4,
        deutan = 1.0,
      },
    },
  },
}
