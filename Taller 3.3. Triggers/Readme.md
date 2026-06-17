# Taller 3.3. Triggers - Grupo 64 bits

Este repositorio contiene el proceso de diseño, implementación y validación de una serie de **triggers (disparadores)** desarrollados bajo el lenguaje **Transact-SQL (T-SQL)** para Microsoft SQL Server. El proyecto se ha desarrollado aplicando el pensamiento sistémico para resolver necesidades específicas de consistencia de datos y automatización de procesos empresariales reales.

## 👥 Integrantes
* Triveños Llaccta Richard (100%)
* Yehan Carlos Surcos Alvarez (100%)
* Mariño Chauca Joseph Beder (100%)
* Zavaleta Fuentes Paolo (100%)

**Docente:** Hugo Espetia Huamanga  
**Institución:** Universidad Andina del Cusco  
**Facultad:** Ingeniería y Arquitectura  
**Escuela Profesional:** Ingeniería de Sistemas  
**Año:** 2026

---

## 📖 Introducción
Los triggers son mecanismos clave para ejecutar lógica de negocio de forma automática en respuesta a eventos de manipulación de datos (`INSERT`, `UPDATE`, `DELETE`). Para los escenarios de pruebas, se utilizaron dos bases de datos relacionales estándar de la industria:
1. **Northwind**: Simula las operaciones logísticas y comerciales de una importadora y exportadora de alimentos.
2. **Pubs**: Representa la operación y flujo de información de una empresa editorial o distribuidora de libros.

---

## 📊 Soluciones Implementadas

### 🗄️ Base de Datos: Northwind
El proyecto contempla el desarrollo de los siguientes disparadores avanzados orientados al control de inventarios y auditoría:

1. **Trigger de auditoría de eliminación de empleados:** Registra de manera histórica en una tabla de control los datos de cualquier empleado que sea eliminado del sistema relacional.
2. **Trigger de control de stock automático (`AFTER INSERT` en `order_details`):** Resta automáticamente las unidades compradas de la columna de stock disponible (`unitsinstock`) de la tabla de productos.
3. **Trigger de auditoría de inventario (Historial de Stock):** Monitorea los cambios en el stock y almacena en la tabla `historico_stock` el valor anterior, el valor nuevo, la fecha del cambio y el usuario que realizó la acción.
4. **Trigger de histórico de cambios de precio:** Realiza una auditoría comercial registrando las variaciones del precio unitario de los productos a través del uso de las tablas lógicas `inserted` y `deleted`.
5. **Trigger de descuento automático por volumen:** Aplica de manera automática una regla de negocio que otorga un 15% de descuento directo si la cantidad de artículos agregada en una orden es igual o superior a 50 unidades.

### 📚 Base de Datos: Pubs
Orientado a mantener la consistencia de estadísticas de venta e integridad referencial estricta:

1. **`trg_UpdateYtdSales_Insert` (`AFTER INSERT` en `sales`):** Suma la cantidad de libros vendidos al acumulado de ventas anuales (`ytd_sales`) en la tabla `titles`.
2. **`trg_UpdateYtdSales_Delete` (`AFTER DELETE` en `sales`):** Resta la cantidad del pedido cancelado directamente de las ventas anuales acumuladas de la obra correspondiente.
3. **`trg_UpdateYtdSales_Update` (`AFTER UPDATE` en `sales`):** Calcula la diferencia neta entre la cantidad antigua y la nueva, ajustando fielmente el valor final de `ytd_sales`.
4. **`trg_PreventDeleteAuthor` (`INSTEAD OF DELETE` en `authors`):** Disparador crítico de integridad. Intercepta e impide la eliminación de un autor si posee libros registrados en la tabla intermedia `titleauthor` (hace `ROLLBACK` de la transacción).
5. **`trg_PreventDeleteTitle` (`INSTEAD OF DELETE` en `titles`):** Protege los datos comerciales bloqueando el borrado de un libro si este ya cuenta con registros históricos de ventas en la tabla `sales`.

---

## 🚀 Conclusiones
La realización de este proyecto consolida la importancia de los disparadores como herramientas de software esenciales para salvaguardar la integridad referencial y automatizar procesos, mitigando eficazmente los riesgos de redundancia o inconsistencia en arquitecturas de datos complejas.

## 🔗 Enlaces del Proyecto
* **Repositorio en GitHub:** [https://github.com/Enrique-024100691i/64-BITIS](https://github.com/Enrique-024100691i/64-BITIS)
* **Infografía Interactiva (GitHub Pages):** [https://024100235c-ai.github.io/infografia/](https://024100235c-ai.github.io/infografia/)
