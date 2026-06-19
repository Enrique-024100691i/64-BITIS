# Sistema de Información Web para la Optimización de Productos (Autopartes) de Intrasev Motors

Este repositorio contiene el código fuente y la documentación del proyecto **Intrasev Motors**, un Sistema de Información Web (ERP moderno) diseñado para optimizar el control de productos, la gestión de inventario de autopartes de alto rendimiento y la administración de procesos comerciales de la empresa.

El desarrollo se llevó a cabo en el marco del **Proyecto Final (Sprint 3)** para la Universidad Andina del Cusco (Facultad de Ingeniería y Arquitectura, Escuela Profesional de Ingeniería de Sistemas).

## Información del Proyecto

* **Institución:** Universidad Andina del Cusco
* **Docente:** Hugo Espetia Huamanga
* **Curso/Sprint:** Proyecto Final (Sprint 3)
* **Grupo:** 64 bits
* **Integrantes (100% participación):**
  * Triveños Llaccta Richard
  * Yehan Carlos Surcos Alvarez
  * Mariño Chauca Joseph Beder
  * Zavaleta Fuentes Paolo
* **Año:** 2026

## Descripción General

Intrasev Motors enfrentaba desafíos operativos debido a procesos manuales y herramientas no integradas, lo que generaba errores en el stock, retrasos en la atención y pérdida de ventas. Este sistema centraliza la información mediante una aplicación web moderna (tipo ERP) optimizada para el manejo especializado de motores de alto valor y repuestos multimarcas.

La interfaz implementa un enfoque de **modo oscuro premium** inspirado en el mundo del motorsport, la Fórmula 1 y los talleres de competición, garantizando una excelente visualización de indicadores críticos mediante tableros y sistemas de alerta visuales (semáforos).

## Arquitectura y Módulos del Sistema

El sistema cuenta con un alcance funcional detallado organizado en los siguientes módulos:

1. **Gestión de Clientes:** Registro dinámico para personas (DNI) y empresas (RUC), motores de búsqueda, historial clínico de compras y mantenimiento de contactos (CRUD).
2. **Gestión de Productos (Inventario):** Catálogo indexado por categoría y marca compatible (BMW, Mercedes, Audi, etc.), control de existencias en tiempo real y alertas de stock bajo mediante códigos de color.
3. **Gestión de Ventas (Transaccional):** Formulario multilínea (carrito de compras), cálculo automático de subtotales y totales, y exportación digital de comprobantes.
4. **Gestión de Empleados:** Control de personal basado en cargos (Vendedor, Supervisor, Administrador) y reportes de desempeño individual.
5. **Reportes y Dashboards (Business Intelligence):** Gráficos estadísticos de ingresos temporales, rankings de rotación y análisis de riesgo de inventario.
6. **Autenticación y Roles:** Seguridad mediante Control de Acceso Basado en Roles (RBAC).
7. **Motor de Búsquedas Inteligentes:** Búsqueda predictiva de piezas, verificación de disponibilidad en mostrador y validación de identidad instantánea.

## Tecnologías Utilizadas

* **UI/UX & Prototipado:** Google Stitch (Herramienta para el diseño interactivo de alta fidelidad).
* **Copiloto de Desarrollo:** Google AI Studio (Ingeniería de prompts para la estructura de componentes, lógica de transacciones simuladas y maquetación de formularios).
* **Frontend:** React, Tailwind CSS, JavaScript.
* **Despliegue y Control de Versiones:** GitHub para el control de código y Vercel/Servidores institucionales para la integración y despliegue continuo (CI/CD).

## Historial de Prompts (Prompt Engineering Log)

Durante el Sprint, se utilizó la asistencia de IA en Google AI Studio para agilizar los componentes clave del código. Ejemplos de directivas utilizadas:

* **Módulo de Productos:** Generación de estructuras de formularios reactivos y tablas interactivas con Tailwind CSS para el registro de códigos, categorías y existencias.
* **Control de Stock Automático:** Lógica en JavaScript para la deducción matemática en tiempo real al confirmar una transacción, impidiendo la generación de inventario negativo mediante validaciones.
* **Dashboard de Negocio:** Construcción de tarjetas KPI (total de ventas, capital invertido, productos críticos) y visualizaciones gráficas reutilizables.

## Resultados de los Casos de Prueba

* **Gestión de Productos:** Registro exitoso de componentes automotrices con validación de campos obligatorios interactivos.
* **Control de Stock Automático:** Bloqueo correcto de transacciones cuando la cantidad solicitada supera las existencias en almacén.
* **Deducción de Inventario:** Descuento inmediato y automático de unidades disponibles tras procesar una venta válida.
* **Inteligencia de Negocio:** Renderizado fluido de gráficos de barras y KPIs comerciales utilizando datos de prueba integrados.

## Sugerencias para Futuras Mejoras

* **Integración de Base de Datos Real:** Migrar los datos simulados a motores relacionales como PostgreSQL o MySQL para ejecutar lógica SQL transaccional pura de producción.
* **Activación de Bloqueos de Seguridad (RBAC):** Restringir técnicamente las rutas según el rol autenticado (Vendedor, Supervisor, Administrador).
* **Motor de Búsquedas Predictivas Completo:** Conectar indexaciones para búsquedas en milisegundos basadas en la compatibilidad multimarcas.
* **Exportación Automatizada:** Incorporar librerías específicas de renderizado para emitir facturas y boletas en PDF de forma nativa.
