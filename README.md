# 📡 Signalist

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="Platform: macOS" />
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 5.9" />
  <img src="https://img.shields.io/badge/SwiftUI-000000?style=for-the-badge&logo=swift&logoColor=white" alt="SwiftUI" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Xcode-15.2-147EFB?style=for-the-badge&logo=xcode&logoColor=white" alt="Made with Xcode 15.2" />
  <img src="https://img.shields.io/badge/Architecture-MVVM-8A2BE2?style=for-the-badge" alt="Architecture: MVVM" />
  <img src="https://img.shields.io/badge/Combine-FF375F?style=for-the-badge&logo=swift&logoColor=white" alt="Combine" />
</p>

<p align="center">
  <b>Convierte texto a código Morse — y viceversa — al instante, con una interfaz nativa de macOS.</b>
</p>

---

## ✨ Descripción

**Signalist** es una app nativa de **macOS** hecha con **SwiftUI** que convierte texto a código Morse y código Morse a texto en tiempo real. Diseñada con una estética minimalista al estilo Apple: tarjetas translúcidas, tipografía redondeada, SF Symbols animados, y soporte completo de modo claro/oscuro.

## 🖥️ Requisitos

| | |
|---|---|
| **Sistema operativo** | macOS 13.0 o superior |
| **Xcode** | 15.2 |
| **Lenguaje** | Swift 5.9 |
| **Framework UI** | SwiftUI |

## 🚀 Características

- 🔤 **Conversión en tiempo real** — texto → Morse y Morse → texto, sin botones extra.
- 🌗 **Modo claro / oscuro** — sigue el sistema o elige tu apariencia preferida, con persistencia entre sesiones.
- 🎨 **Diseño estilo Apple** — tarjetas con `.regularMaterial`, degradados de marca, y tipografía `.rounded`.
- ✅ **Feedback visual animado** — el ícono de resultado cambia de color y rebota al completarse la conversión.
- 📋 **Copiar al portapapeles** con un clic.
- 🆕 **Pantalla "What's New"** — se muestra automáticamente en el primer lanzamiento, con opción de volver a verla desde la barra de herramientas.
- 🧩 **Arquitectura MVVM** — lógica de conversión, estado y vista completamente separados.
- 🔄 **Reactivo con Combine** — el pipeline de conversión usa `CombineLatest` y `debounce` para un procesamiento eficiente mientras escribes.

## 🏗️ Arquitectura

El proyecto sigue el patrón **MVVM (Model - View - ViewModel)**:

```
Signalist/
├── SignalistApp.swift
├── Models/
│   ├── MorseCode.swift          # Lógica pura de codificación/decodificación
│   └── WhatsNewFeature.swift    # Modelo de características para onboarding
├── ViewModels/
│   └── MorseViewModel.swift     # Estado observable + pipeline reactivo con Combine
├── Views/
│   ├── ContentView.swift        # Vista principal
│   └── WhatsNewView.swift       # Pantalla de novedades
└── Utilities/
    └── Theme.swift              # Colores de marca y preferencia de apariencia
```

- **Model**: sin dependencias de UI, fácilmente testeable.
- **ViewModel**: `@MainActor`, expone estado mediante `@Published` y usa `Combine` para reaccionar a cambios de texto/modo con debounce.
- **View**: solo presenta datos y captura interacción del usuario, sin lógica de negocio.

## 📸 Capturas de pantalla

<img width="1126" height="1280" alt="WhatsApp Image 2026-07-10 at 15 47 15" src="https://github.com/user-attachments/assets/9d60a688-c918-4879-8ca7-41d44ee4ec13" />


## 🛠️ Instalación

```bash
git clone https://github.com/danimelenge/signalist.git
cd signalist
open Signalist.xcodeproj
```

Luego, en Xcode: selecciona el esquema `Signalist` y presiona `Cmd + R` para compilar y ejecutar.


## 📄 Licencia

Este proyecto está disponible bajo la licencia que definas (MIT, GPL, etc. — agrega tu archivo `LICENSE` correspondiente).

---

<p align="center">Hecho con 🩵 usando SwiftUI</p>
