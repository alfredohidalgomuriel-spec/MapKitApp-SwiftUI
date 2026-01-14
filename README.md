<p align="center">
  <img src="https://github.com/user-attachments/assets/017f8762-10a9-4994-a8b6-77be680a6632" width="160" style="border-radius: 35px; box-shadow: 0px 10px 20px rgba(0,0,0,0.1);">
</p>

<h1 align="center">MapKit App</h1>

<p align="center">
  <b>Localización avanzada y exploración con Look Around</b><br>
  Una experiencia moderna desarrollada íntegramente en SwiftUI.
</p>

---


Aplicación nativa de mapas desarrollada con **SwiftUI** y **MapKit**, enfocada en ofrecer una experiencia de usuario fluida y visualmente atractiva.

## ✨ Características principal
- **Ubicación en tiempo real**: Rastreo preciso de la posición del usuario.
- **Look Around**: Integración de la vista de calle (Street View de Apple) con transiciones suaves.
- **Marcadores Animados**: Implementación de componentes personalizados con animaciones de escala y opacidad.
- **Modo Oscuro/Claro**: Interfaz adaptable automáticamente al sistema.

## 🛠️ Tecnologías utilizadas
- **Lenguaje**: Swift 5.10
- **Framework**: SwiftUI
- **Mapas**: MapKit
- **Arquitectura**: MVVM (Model-View-ViewModel) con el nuevo protocolo `@Observable`.

## 🧠 Aspectos Técnicos Destacados
- **Gestión de Concurrencia**: Uso de `@MainActor` y `Task` para garantizar que las actualizaciones de la interfaz de usuario (como cerrar el modo Look Around) se ejecuten siempre en el hilo principal, evitando bloqueos.
- **Estado Reactivo**: Implementación de estados complejos para gestionar la visibilidad de componentes del sistema de forma coordinada.

## 📸 Capturas de pantalla
> *Aquí subiremos tus fotos en el siguiente paso*
