# MapKitApp 🌍

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
