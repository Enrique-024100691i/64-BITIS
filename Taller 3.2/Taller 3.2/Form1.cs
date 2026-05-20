using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using WindowsFormsApp2.Properties;

namespace WindowsFormsApp2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from C in northwind.Customers
                               where C.Country == "Mexico"
                               select new
                               {
                                   C.CustomerID,
                                   C.CompanyName,
                                   C.ContactName,
                                   C.Country
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from OD in northwind.Order_Details
                               where OD.Discount > 0 && OD.Quantity > 50
                               select new
                               {
                                   OD.OrderID,
                                   OD.ProductID,
                                   OD.UnitPrice,
                                   OD.Quantity,
                                   OD.Discount
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                string[] titulosFemeninos = { "Ms.", "Mrs." };

                var consulta = from E in northwind.Employees
                               where titulosFemeninos.Contains(E.TitleOfCourtesy)
                               select new
                               {
                                   E.EmployeeID,
                                   E.FirstName,
                                   E.LastName,
                                   E.TitleOfCourtesy,
                                   E.City
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from P in northwind.Products
                               select new
                               {
                                   P.ProductID,
                                   P.ProductName,
                                   P.UnitPrice
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = (from T in northwind.Territories
                                select new
                                {
                                    T.RegionID
                                }).Distinct();

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from Cat in northwind.Categories
                               select new
                               {
                                   Cat.CategoryID,
                                   Cat.CategoryName,
                                   Cat.Description
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from O in northwind.Orders
                               select new
                               {
                                   CodigoPedido = O.OrderID,
                                   FechaDeEnvio = O.ShippedDate,
                                   Destinatario = O.ShipName,
                                   PaisDestino = O.ShipCountry
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button8_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from S in northwind.Suppliers
                               select new
                               {
                                   CodigoProveedor = S.SupplierID,
                                   NombreEmpresa = S.CompanyName,
                                   PersonaContacto = S.ContactName,
                                   TelefonoFijo = S.Phone
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from Sh in northwind.Shippers
                               select new
                               {
                                   CodigoTransportista = Sh.ShipperID,
                                   CompaniaDistribuidora = Sh.CompanyName,
                                   NumeroContacto = Sh.Phone
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button11_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Empleados de London
                var consulta1 = from E in northwind.Employees
                                where E.City == "London"
                                select new
                                {
                                    E.EmployeeID,
                                    Nombre = E.FirstName + " " + E.LastName,
                                    E.City,
                                    E.Country
                                };

                // Empleados de Seattle
                var consulta2 = from E in northwind.Employees
                                where E.City == "Seattle"
                                select new
                                {
                                    E.EmployeeID,
                                    Nombre = E.FirstName + " " + E.LastName,
                                    E.City,
                                    E.Country
                                };

                // UNION
                var consulta = consulta1.Union(consulta2);

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button12_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Productos con precio mayor a 50
                var consulta1 = from P in northwind.Products
                                where P.UnitPrice > 50
                                select new
                                {
                                    P.ProductID,
                                    P.ProductName,
                                    P.UnitPrice
                                };

                // Productos con stock mayor a 50
                var consulta2 = from P in northwind.Products
                                where P.UnitsInStock > 50
                                select new
                                {
                                    P.ProductID,
                                    P.ProductName,
                                    P.UnitPrice
                                };

                // UNION
                var consulta = consulta1.Union(consulta2);

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button10_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Clientes de Germany
                var consulta1 = from C in northwind.Customers
                                where C.Country == "Germany"
                                select new
                                {
                                    C.CustomerID,
                                    C.CompanyName,
                                    C.City,
                                    C.Country
                                };

                // Clientes de France
                var consulta2 = from C in northwind.Customers
                                where C.Country == "France"
                                select new
                                {
                                    C.CustomerID,
                                    C.CompanyName,
                                    C.City,
                                    C.Country
                                };

                // UNION
                var consulta = consulta1.Union(consulta2);

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button13_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Clientes de Germany
                var consulta1 = from C in northwind.Customers
                                where C.Country == "Germany"
                                select C;

                // Clientes de Berlin
                var consulta2 = from C in northwind.Customers
                                where C.City == "Berlin"
                                select C;

                // DIFERENCIA
                var consulta = consulta1.Except(consulta2);

                dgvNorthwind.DataSource = consulta
                    .Select(C => new
                    {
                        C.CustomerID,
                        C.CompanyName,
                        C.City,
                        C.Country
                    })
                    .ToList();
            }
        }

        private void button14_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Productos caros
                var consulta1 = from P in northwind.Products
                                where P.UnitPrice > 30
                                select P;

                // Productos con poco stock
                var consulta2 = from P in northwind.Products
                                where P.UnitsInStock < 20
                                select P;

                // DIFERENCIA
                var consulta = consulta1.Except(consulta2);

                dgvNorthwind.DataSource = consulta
                    .Select(P => new
                    {
                        P.ProductID,
                        P.ProductName,
                        P.UnitPrice,
                        P.UnitsInStock
                    })
                    .ToList();
            }
        }

        private void button15_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                // Empleados de USA
                var consulta1 = from E in northwind.Employees
                                where E.Country == "USA"
                                select new
                                {
                                    E.EmployeeID,
                                    E.FirstName,
                                    E.LastName,
                                    E.City,
                                    E.Country
                                };

                // Empleados de Seattle
                var consulta2 = from E in northwind.Employees
                                where E.City == "Seattle"
                                select new
                                {
                                    E.EmployeeID,
                                    E.FirstName,
                                    E.LastName,
                                    E.City,
                                    E.Country
                                };

                // DIFERENCIA
                var consulta = consulta1.Except(consulta2);

                dgvNorthwind.DataSource = consulta
                    .Select(E => new
                    {
                        E.EmployeeID,
                        Nombre = E.FirstName + " " + E.LastName,
                        E.City,
                        E.Country
                    })
                    .ToList();
            }
        }

        private void button16_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from C in northwind.Customers
                               from E in northwind.Employees
                               select new
                               {
                                   Cliente = C.CompanyName,
                                   Empleado = E.FirstName + " " + E.LastName
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }
        private void button17_Click_1(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from P in northwind.Products
                               from C in northwind.Categories
                               select new
                               {
                                   P.ProductName,
                                   Categoria = C.CategoryName
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }

        private void button18_Click(object sender, EventArgs e)
        {
            using (NorthwindEntities northwind = new NorthwindEntities())
            {
                var consulta = from S in northwind.Suppliers
                               from Sh in northwind.Shippers
                               select new
                               {
                                   Proveedor = S.CompanyName,
                                   Transportista = Sh.CompanyName
                               };

                dgvNorthwind.DataSource = consulta.ToList();
            }
        }
    }
}
