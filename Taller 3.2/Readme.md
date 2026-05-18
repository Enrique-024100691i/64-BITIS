# Taller 3.2: Álgebra Relacional - Operaciones Unarias y Binarias

Este repositorio contiene el desarrollo del Taller 3.2 de Álgebra Relacional, correspondiente a la asignatura de Modelado de Base de Datos de la Escuela Profesional de Ingeniería de Sistemas de la Universidad Andina del Cusco (2026).

El objetivo principal de este trabajo es aplicar los fundamentos matemáticos del álgebra relacional para consultar, manipular y organizar información de forma eficiente sobre bases de datos relacionales tradicionales utilizando herramientas de desarrollo de software.

## Información del Proyecto

* **Institución:** Universidad Andina del Cusco
* **Facultad:** Ingeniería y Arquitectura
* **Escuela Profesional:** Ingeniería de Sistemas
* **Curso:** Modelado de Base de Datos (Semestre 2025-II / Académico 2026)
* **Docente:** Hugo Espetia Huamanga
* **Grupo de Trabajo:** 64 bits

### Integrantes (100% Contribución)
* Triveños Llaccta, Richard
* Surcos Alvarez, Yehan Carlos
* Mariño Chauca, Joseph Beder
* Zavaleta Fuentes, Paolo

---

## Tecnologías y Entornos Utilizados

* **Bases de Datos de Prueba:** * PUBS (Base de datos de ejemplo sobre publicaciones, empleados y autores)
  * NORTHWIND (Base de datos de ejemplo sobre comercio y distribución comercial)
* **Framework / ORM:** Entity Framework Core (Implementación de Fluent API y Navigation Properties)
* **Lenguaje:** C# / LINQ (Estructuras de consultas avanzadas y expresiones lambda)

---

## Resultados de Aprendizaje e Indicadores

El desarrollo de este taller se alinea con los estándares de evaluación del programa de Ingeniería de Sistemas:
* **[AG-C07] Conocimientos de Computación:** Aplicación de conocimientos apropiados de matemáticas y computación para resolver problemas complejos de base de datos.
* **[AG-C09] Diseño y Desarrollo de Soluciones:** Diseño e implementación de soluciones para problemas complejos de computación utilizando pensamiento sistémico en localhost.

---

## Estructura del Taller

El proyecto aborda ejercicios prácticos formulados para cada una de las operaciones del álgebra relacional distribuidos en las siguientes secciones:

### 1. Operaciones Unarias (3 Ejercicios por operación)
* **Selección ($\sigma$):** Filtrado de filas específicas bajo criterios lógicos en tablas como `publishers`, `titles` y `employee` (en PUBS), así como `customers` (en Northwind).
* **Proyección ($\pi$):** Reducción de columnas para visualizar únicamente los atributos requeridos en entidades como `authors`, `stores` y `jobs`.
* **Renombramiento ($\rho$):** Reestructuración conceptual de columnas y entidades para resolver ambigüedades.

### 2. Operaciones Binarias
* **Unión ($\cup$):** Combinación de conjuntos compatibles (ej. consultas sobre autores o tiendas).
* **Diferencia ($-$):** Identificación de registros exclusivos excluyendo coincidencias de otros conjuntos (ej. `DifCustomer`, `DifProducts`).
* **Producto Cartesiano ($\times$):** Combinación total de registros entre dos entidades (ej. relaciones cruzadas autor-libro, tiendas-proveedores o empleados-trabajos).

---

## Recursos Adicionales

* **Infografía del Proyecto:** [Ver Infografía Interactiva](https://024100235c-ai.github.io/infografia2.4/)
* **Documentación de Referencia:**
  * Microsoft Entity Framework Core Documentation (2026)
  * Guía de Evaluación: Modelado de Base de Datos - UAC

---

## Licencia

Este proyecto se comparte exclusivamente con fines académicos. Desarrollado por el grupo 64 bits de la Universidad Andina del Cusco.
