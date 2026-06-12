# SPRsim-matlab

**Surface Plasmon Resonance (SPR) Simulation GUI for Multilayer Optical Structures**

A MATLAB App Designer application that simulates SPR reflectance curves for a Kretschmann-configuration biosensor using the **Transfer Matrix Method (TMM)**. Users can interactively tune layer thicknesses and optical constants in real time via sliders.

---

## Multilayer Structure

| Layer | Material | Tunable |
|-------|----------|---------|
| 1 | BK7 Glass Prism (Schott, 0.3–2.5 µm) | — |
| 2 | Titanium adhesion layer (Mash, 0.4–10 µm) | ✅ 0–20 nm |
| 3 | Gold thin film (Yakubovsky 25 nm, 300–2000 nm) | ✅ 0–100 nm |
| 4 | Biosensor base layer | — |
| 5 | Biosensor / analyte layer | ✅ 0–200 nm |
| 6 | Aqueous background | ✅ n = 1–2 RIU |

---

## Features

- Real-time TMM calculation as sliders move
- Adjustable wavelength (400–1500 nm)
- Internal **or** external angle display
- Normalized (0–1) or auto-scale Y axis
- Experimental optical constants loaded from `.mat` files (Schott BK7, Mash Ti, Yakubovsky Au)
- Context menu on plot for Export / Copy

---

## Requirements

- MATLAB R2021a or later (App Designer support)
- **Toolboxes:** None required beyond base MATLAB
- The `ExperimentalData/` folder containing:
  - `NBK7SCHOTT.mat`
  - `MashTitanium.mat`
  - `YakubovskyGold25nm.mat`

> **Note:** The experimental data `.mat` files are not included in this repository due to licensing of the original source data. Place them in `ExperimentalData/` before running.

---

## Getting Started

```matlab
% Launch the GUI
SPRsim_exported
```

Or call the core function directly:

```matlab
lambda  = 633e-9;   % wavelength in metres
d_au    = 50e-9;    % gold thickness (m)
d_ti    = 2e-9;     % titanium thickness (m)
n_water = 1.33;     % background refractive index (RIU)
d_bio   = 5e-9;     % biosensor layer thickness (m)
eps_bio = 2.5;      % biosensor layer permittivity

[RTM, theta_ref, theta_deg, epsilon] = SPRgui_func(lambda, d_au, d_ti, n_water, d_bio, eps_bio);

figure;
plot(theta_ref, RTM);
xlabel('Internal angle (deg)');
ylabel('Reflectance');
title('SPR curve — Kretschmann configuration');
```

---

## File Structure

```
SPRsim-matlab/
├── SPRgui_func.m          # Core TMM simulation function
├── SPRsim_exported.m      # MATLAB App Designer GUI class
├── ExperimentalData/      # Place .mat optical constant files here
│   ├── NBK7SCHOTT.mat     # (not included — see note above)
│   ├── MashTitanium.mat
│   └── YakubovskyGold25nm.mat
├── LICENSE
├── CITATION.cff
└── README.md
```

---

## Theory

The simulation uses the **Transfer Matrix Method** for TM-polarised light, following:

> Orfanidis, S. J. *Electromagnetic Waves and Antennas*, Ch. 8.2 — Lossy Multilayer Systems.

Optical constants are sourced from:
- **BK7:** SCHOTT Zemax catalog 2017-01-20b
- **Ti:** I. D. Mash & G. P. Motulevich, *Sov. Phys. JETP* 36, 516–520 (1973)
- **Au (25 nm):** D. I. Yakubovsky *et al.*, *Opt. Express* 25, 25574–25587 (2017)

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE).

---

## Citation

If you use this code in your research, please cite it using the metadata in [CITATION.cff](CITATION.cff).
