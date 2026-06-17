/* ================================================================
   ARCHIVO UNICO: Pubs Database + Triggers + DEMO
   ================================================================
   CONTENIDO:
     1. CREACION DE LA BASE DE DATOS PUBS
     2. CREACION DE LOS 5 TRIGGERS
     3. DEMO: EJECUCION DE CADA TRIGGER CON TABLAS
   ================================================================ */

SET NOCOUNT ON
GO

/* ================================================================
   PARTE 1: CREACION DE LA BASE DE DATOS PUBS
   ================================================================ */

USE master
GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name='pubs')
BEGIN
    DROP DATABASE pubs
END
GO

CREATE DATABASE pubs
GO

USE pubs
GO

-- Tipos de datos definidos por el usuario
EXEC sp_addtype id, 'varchar(11)', 'NOT NULL'
EXEC sp_addtype tid, 'varchar(6)', 'NOT NULL'
EXEC sp_addtype empid, 'char(9)', 'NOT NULL'
GO

-- TABLA: authors
CREATE TABLE authors (
    au_id id CHECK (au_id LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')
        CONSTRAINT UPKCL_auidind PRIMARY KEY CLUSTERED,
    au_lname varchar(40) NOT NULL,
    au_fname varchar(20) NOT NULL,
    phone char(12) NOT NULL DEFAULT ('UNKNOWN'),
    address varchar(40) NULL,
    city varchar(20) NULL,
    state char(2) NULL,
    zip char(5) NULL CHECK (zip LIKE '[0-9][0-9][0-9][0-9][0-9]'),
    contract bit NOT NULL
)
GO

-- TABLA: publishers
CREATE TABLE publishers (
    pub_id char(4) NOT NULL
        CONSTRAINT UPKCL_pubind PRIMARY KEY CLUSTERED
        CHECK (pub_id IN ('1389','0736','0877','1622','1756') OR pub_id LIKE '99[0-9][0-9]'),
    pub_name varchar(40) NULL,
    city varchar(20) NULL,
    state char(2) NULL,
    country varchar(30) NULL DEFAULT('USA')
)
GO

-- TABLA: titles
CREATE TABLE titles (
    title_id tid CONSTRAINT UPKCL_titleidind PRIMARY KEY CLUSTERED,
    title varchar(80) NOT NULL,
    type char(12) NOT NULL DEFAULT ('UNDECIDED'),
    pub_id char(4) NULL REFERENCES publishers(pub_id),
    price money NULL,
    advance money NULL,
    royalty int NULL,
    ytd_sales int NULL,
    notes varchar(200) NULL,
    pubdate datetime NOT NULL DEFAULT (GETDATE())
)
GO

-- TABLA: titleauthor
CREATE TABLE titleauthor (
    au_id id REFERENCES authors(au_id),
    title_id tid REFERENCES titles(title_id),
    au_ord tinyint NULL,
    royaltyper int NULL,
    CONSTRAINT UPKCL_taind PRIMARY KEY CLUSTERED(au_id, title_id)
)
GO

-- TABLA: stores
CREATE TABLE stores (
    stor_id char(4) NOT NULL CONSTRAINT UPK_storeid PRIMARY KEY CLUSTERED,
    stor_name varchar(40) NULL,
    stor_address varchar(40) NULL,
    city varchar(20) NULL,
    state char(2) NULL,
    zip char(5) NULL
)
GO

-- TABLA: sales
CREATE TABLE sales (
    stor_id char(4) NOT NULL REFERENCES stores(stor_id),
    ord_num varchar(20) NOT NULL,
    ord_date datetime NOT NULL,
    qty smallint NOT NULL,
    payterms varchar(12) NOT NULL,
    title_id tid REFERENCES titles(title_id),
    CONSTRAINT UPKCL_sales PRIMARY KEY CLUSTERED (stor_id, ord_num, title_id)
)
GO

-- TABLA: roysched
CREATE TABLE roysched (
    title_id tid REFERENCES titles(title_id),
    lorange int NULL,
    hirange int NULL,
    royalty int NULL
)
GO

-- TABLA: discounts
CREATE TABLE discounts (
    discounttype varchar(40) NOT NULL,
    stor_id char(4) NULL REFERENCES stores(stor_id),
    lowqty smallint NULL,
    highqty smallint NULL,
    discount dec(4,2) NOT NULL
)
GO

-- TABLA: jobs
CREATE TABLE jobs (
    job_id smallint IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    job_desc varchar(50) NOT NULL DEFAULT 'New Position - title not formalized yet',
    min_lvl tinyint NOT NULL CHECK (min_lvl >= 10),
    max_lvl tinyint NOT NULL CHECK (max_lvl <= 250)
)
GO

-- TABLA: pub_info
CREATE TABLE pub_info (
    pub_id char(4) NOT NULL
        REFERENCES publishers(pub_id)
        CONSTRAINT UPKCL_pubinfo PRIMARY KEY CLUSTERED,
    logo image NULL,
    pr_info text NULL
)
GO

-- TABLA: employee
CREATE TABLE employee (
    emp_id empid
        CONSTRAINT PK_emp_id PRIMARY KEY NONCLUSTERED
        CONSTRAINT CK_emp_id CHECK (emp_id LIKE '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]'
           OR emp_id LIKE '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'),
    fname varchar(20) NOT NULL,
    minit char(1) NULL,
    lname varchar(30) NOT NULL,
    job_id smallint NOT NULL DEFAULT 1 REFERENCES jobs(job_id),
    job_lvl tinyint DEFAULT 10,
    pub_id char(4) NOT NULL DEFAULT ('9952') REFERENCES publishers(pub_id),
    hire_date datetime NOT NULL DEFAULT (GETDATE())
)
GO

-- TRIGGER existente de Pubs
CREATE TRIGGER employee_insupd ON employee FOR INSERT, UPDATE AS
    DECLARE @min_lvl tinyint, @max_lvl tinyint, @emp_lvl tinyint, @job_id smallint
    SELECT @min_lvl = min_lvl, @max_lvl = max_lvl, @emp_lvl = i.job_lvl, @job_id = i.job_id
    FROM employee e, jobs j, inserted i
    WHERE e.emp_id = i.emp_id AND i.job_id = j.job_id
    IF (@job_id = 1) AND (@emp_lvl <> 10)
    BEGIN
        RAISERROR ('Job id 1 expects the default level of 10.',16,1)
        ROLLBACK TRANSACTION
    END
    ELSE IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
    BEGIN
        RAISERROR ('The level for job_id:%d should be between %d and %d.',16,1,@job_id,@min_lvl,@max_lvl)
        ROLLBACK TRANSACTION
    END
GO

PRINT '=== TABLAS CREADAS CORRECTAMENTE ==='
GO

-- DATOS: authors
INSERT authors VALUES('409-56-7008','Bennet','Abraham','415 658-9932','6223 Bateman St.','Berkeley','CA','94705',1)
INSERT authors VALUES('213-46-8915','Green','Marjorie','415 986-7020','309 63rd St. #411','Oakland','CA','94618',1)
INSERT authors VALUES('238-95-7766','Carson','Cheryl','415 548-7723','589 Darwin Ln.','Berkeley','CA','94705',1)
INSERT authors VALUES('998-72-3567','Ringer','Albert','801 826-0752','67 Seventh Av.','Salt Lake City','UT','84152',1)
INSERT authors VALUES('899-46-2035','Ringer','Anne','801 826-0752','67 Seventh Av.','Salt Lake City','UT','84152',1)
INSERT authors VALUES('722-51-5454','DeFrance','Michel','219 547-9982','3 Balding Pl.','Gary','IN','46403',1)
INSERT authors VALUES('807-91-6654','Panteley','Sylvia','301 946-8853','1956 Arlington Pl.','Rockville','MD','20853',1)
INSERT authors VALUES('893-72-1158','McBadden','Heather','707 448-4982','301 Putnam','Vacaville','CA','95688',0)
INSERT authors VALUES('724-08-9931','Stringer','Dirk','415 843-2991','5420 Telegraph Av.','Oakland','CA','94609',0)
INSERT authors VALUES('274-80-9391','Straight','Dean','415 834-2919','5420 College Av.','Oakland','CA','94609',1)
INSERT authors VALUES('756-30-7391','Karsen','Livia','415 534-9219','5720 McAuley St.','Oakland','CA','94609',1)
INSERT authors VALUES('724-80-9391','MacFeather','Stearns','415 354-7128','44 Upland Hts.','Oakland','CA','94612',1)
INSERT authors VALUES('427-17-2319','Dull','Ann','415 836-7128','3410 Blonde St.','Palo Alto','CA','94301',1)
INSERT authors VALUES('672-71-3249','Yokomoto','Akiko','415 935-4228','3 Silver Ct.','Walnut Creek','CA','94595',1)
INSERT authors VALUES('267-41-2394','O''Leary','Michael','408 286-2428','22 Cleveland Av. #14','San Jose','CA','95128',1)
INSERT authors VALUES('472-27-2349','Gringlesby','Burt','707 938-6445','PO Box 792','Covelo','CA','95428',3)
INSERT authors VALUES('527-72-3246','Greene','Morningstar','615 297-2723','22 Graybar House Rd.','Nashville','TN','37215',0)
INSERT authors VALUES('172-32-1176','White','Johnson','408 496-7223','10932 Bigge Rd.','Menlo Park','CA','94025',1)
INSERT authors VALUES('712-45-1867','del Castillo','Innes','615 996-8275','2286 Cram Pl. #86','Ann Arbor','MI','48105',1)
INSERT authors VALUES('846-92-7186','Hunter','Sheryl','415 836-7128','3410 Blonde St.','Palo Alto','CA','94301',1)
INSERT authors VALUES('486-29-1786','Locksley','Charlene','415 585-4620','18 Broadway Av.','San Francisco','CA','94130',1)
INSERT authors VALUES('648-92-1872','Blotchet-Halls','Reginald','503 745-6402','55 Hillsdale Bl.','Corvallis','OR','97330',1)
INSERT authors VALUES('341-22-1782','Smith','Meander','913 843-0462','10 Mississippi Dr.','Lawrence','KS','66044',0)
GO

-- DATOS: publishers
INSERT publishers VALUES('0736','New Moon Books','Boston','MA','USA')
INSERT publishers VALUES('0877','Binnet & Hardley','Washington','DC','USA')
INSERT publishers VALUES('1389','Algodata Infosystems','Berkeley','CA','USA')
INSERT publishers VALUES('9952','Scootney Books','New York','NY','USA')
INSERT publishers VALUES('1622','Five Lakes Publishing','Chicago','IL','USA')
INSERT publishers VALUES('1756','Ramona Publishers','Dallas','TX','USA')
INSERT publishers VALUES('9901','GGG&G','Munchen',NULL,'Germany')
INSERT publishers VALUES('9999','Lucerne Publishing','Paris',NULL,'France')
GO

-- DATOS: titles
INSERT titles VALUES ('PC8888','Secrets of Silicon Valley','popular_comp','1389',$20.00,$8000.00,10,4095,'Muckraking reporting on the world''s largest computer hardware and software manufacturers.','06/12/94')
INSERT titles VALUES ('BU1032','The Busy Executive''s Database Guide','business','1389',$19.99,$5000.00,10,4095,'An overview of available database systems with emphasis on common business applications. Illustrated.','06/12/91')
INSERT titles VALUES ('PS7777','Emotional Security: A New Algorithm','psychology','0736',$7.99,$4000.00,10,3336,'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.','06/12/91')
INSERT titles VALUES ('PS3333','Prolonged Data Deprivation: Four Case Studies','psychology','0736',$19.99,$2000.00,10,4072,'What happens when the data runs dry?  Searching evaluations of information-shortage effects.','06/12/91')
INSERT titles VALUES ('BU1111','Cooking with Computers: Surreptitious Balance Sheets','business','1389',$11.95,$5000.00,10,3876,'Helpful hints on how to use your electronic resources to the best advantage.','06/09/91')
INSERT titles VALUES ('MC2222','Silicon Valley Gastronomic Treats','mod_cook','0877',$19.99,$0.00,12,2032,'Favorite recipes for quick, easy, and elegant meals.','06/09/91')
INSERT titles VALUES ('TC7777','Sushi, Anyone?','trad_cook','0877',$14.99,$8000.00,10,4095,'Detailed instructions on how to make authentic Japanese sushi in your spare time.','06/12/91')
INSERT titles VALUES ('TC4203','Fifty Years in Buckingham Palace Kitchens','trad_cook','0877',$11.95,$4000.00,14,15096,'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.','06/12/91')
INSERT titles VALUES ('PC1035','But Is It User Friendly?','popular_comp','1389',$22.95,$7000.00,16,8780,'A survey of software for the naive user, focusing on the ''friendliness'' of each.','06/30/91')
INSERT titles VALUES('BU2075','You Can Combat Computer Stress!','business','0736',$2.99,$10125.00,24,18722,'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.','06/30/91')
INSERT titles VALUES('PS2091','Is Anger the Enemy?','psychology','0736',$10.95,$2275.00,12,2045,'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.','06/15/91')
INSERT titles VALUES('PS2106','Life Without Fear','psychology','0736',$7.00,$6000.00,10,111,'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.','10/05/91')
INSERT titles VALUES('MC3021','The Gourmet Microwave','mod_cook','0877',$2.99,$15000.00,24,22246,'Traditional French gourmet recipes adapted for modern microwave cooking.','06/18/91')
INSERT titles VALUES('TC3218','Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean','trad_cook','0877',$20.95,$7000.00,10,375,'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.','10/21/91')
INSERT titles (title_id, title, pub_id) VALUES('MC3026','The Psychology of Computer Cooking','0877')
INSERT titles VALUES ('BU7832','Straight Talk About Computers','business','1389',$19.99,$5000.00,10,4095,'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.','06/22/91')
INSERT titles VALUES('PS1372','Computer Phobic AND Non-Phobic Individuals: Behavior Variations','psychology','0877',$21.59,$7000.00,10,375,'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.','10/21/91')
INSERT titles (title_id, title, type, pub_id, notes) VALUES('PC9999','Net Etiquette','popular_comp','1389','A must-read for computer conferencing.')
GO

-- DATOS: titleauthor
INSERT titleauthor VALUES('409-56-7008','BU1032',1,60)
INSERT titleauthor VALUES('486-29-1786','PS7777',1,100)
INSERT titleauthor VALUES('486-29-1786','PC9999',1,100)
INSERT titleauthor VALUES('712-45-1867','MC2222',1,100)
INSERT titleauthor VALUES('172-32-1176','PS3333',1,100)
INSERT titleauthor VALUES('213-46-8915','BU1032',2,40)
INSERT titleauthor VALUES('238-95-7766','PC1035',1,100)
INSERT titleauthor VALUES('213-46-8915','BU2075',1,100)
INSERT titleauthor VALUES('998-72-3567','PS2091',1,50)
INSERT titleauthor VALUES('899-46-2035','PS2091',2,50)
INSERT titleauthor VALUES('998-72-3567','PS2106',1,100)
INSERT titleauthor VALUES('722-51-5454','MC3021',1,75)
INSERT titleauthor VALUES('899-46-2035','MC3021',2,25)
INSERT titleauthor VALUES('807-91-6654','TC3218',1,100)
INSERT titleauthor VALUES('274-80-9391','BU7832',1,100)
INSERT titleauthor VALUES('427-17-2319','PC8888',1,50)
INSERT titleauthor VALUES('846-92-7186','PC8888',2,50)
INSERT titleauthor VALUES('756-30-7391','PS1372',1,75)
INSERT titleauthor VALUES('724-80-9391','PS1372',2,25)
INSERT titleauthor VALUES('724-80-9391','BU1111',1,60)
INSERT titleauthor VALUES('267-41-2394','BU1111',2,40)
INSERT titleauthor VALUES('672-71-3249','TC7777',1,40)
INSERT titleauthor VALUES('267-41-2394','TC7777',2,30)
INSERT titleauthor VALUES('472-27-2349','TC7777',3,30)
INSERT titleauthor VALUES('648-92-1872','TC4203',1,100)
GO

-- DATOS: stores
INSERT stores VALUES('7066','Barnum''s','567 Pasadena Ave.','Tustin','CA','92789')
INSERT stores VALUES('7067','News & Brews','577 First St.','Los Gatos','CA','96745')
INSERT stores VALUES('7131','Doc-U-Mat: Quality Laundry and Books','24-A Avogadro Way','Remulade','WA','98014')
INSERT stores VALUES('8042','Bookbeat','679 Carson St.','Portland','OR','89076')
INSERT stores VALUES('6380','Eric the Read Books','788 Catamaugus Ave.','Seattle','WA','98056')
INSERT stores VALUES('7896','Fricative Bookshop','89 Madison St.','Fremont','CA','90019')
GO

-- DATOS: sales
INSERT sales VALUES('7066','QA7442.3','09/13/94',75,'ON invoice','PS2091')
INSERT sales VALUES('7067','D4482','09/14/94',10,'Net 60','PS2091')
INSERT sales VALUES('7131','N914008','09/14/94',20,'Net 30','PS2091')
INSERT sales VALUES('7131','N914014','09/14/94',25,'Net 30','MC3021')
INSERT sales VALUES('8042','423LL922','09/14/94',15,'ON invoice','MC3021')
INSERT sales VALUES('8042','423LL930','09/14/94',10,'ON invoice','BU1032')
INSERT sales VALUES('6380','722a','09/13/94',3,'Net 60','PS2091')
INSERT sales VALUES('6380','6871','09/14/94',5,'Net 60','BU1032')
INSERT sales VALUES('8042','P723','03/11/93',25,'Net 30','BU1111')
INSERT sales VALUES('7896','X999','02/21/93',35,'ON invoice','BU2075')
INSERT sales VALUES('7896','QQ2299','10/28/93',15,'Net 60','BU7832')
INSERT sales VALUES('7896','TQ456','12/12/93',10,'Net 60','MC2222')
INSERT sales VALUES('8042','QA879.1','5/22/93',30,'Net 30','PC1035')
INSERT sales VALUES('7066','A2976','5/24/93',50,'Net 30','PC8888')
INSERT sales VALUES('7131','P3087a','5/29/93',20,'Net 60','PS1372')
INSERT sales VALUES('7131','P3087a','5/29/93',25,'Net 60','PS2106')
INSERT sales VALUES('7131','P3087a','5/29/93',15,'Net 60','PS3333')
INSERT sales VALUES('7131','P3087a','5/29/93',25,'Net 60','PS7777')
INSERT sales VALUES('7067','P2121','6/15/92',40,'Net 30','TC3218')
INSERT sales VALUES('7067','P2121','6/15/92',20,'Net 30','TC4203')
INSERT sales VALUES('7067','P2121','6/15/92',20,'Net 30','TC7777')
GO

-- DATOS: roysched
INSERT roysched VALUES('BU1032',0,5000,10)
INSERT roysched VALUES('BU1032',5001,50000,12)
INSERT roysched VALUES('PC1035',0,2000,10)
INSERT roysched VALUES('PC1035',2001,3000,12)
INSERT roysched VALUES('PC1035',3001,4000,14)
INSERT roysched VALUES('PC1035',4001,10000,16)
INSERT roysched VALUES('PC1035',10001,50000,18)
INSERT roysched VALUES('BU2075',0,1000,10)
INSERT roysched VALUES('BU2075',1001,3000,12)
INSERT roysched VALUES('BU2075',3001,5000,14)
INSERT roysched VALUES('BU2075',5001,7000,16)
INSERT roysched VALUES('BU2075',7001,10000,18)
INSERT roysched VALUES('BU2075',10001,12000,20)
INSERT roysched VALUES('BU2075',12001,14000,22)
INSERT roysched VALUES('BU2075',14001,50000,24)
INSERT roysched VALUES('PS2091',0,1000,10)
INSERT roysched VALUES('PS2091',1001,5000,12)
INSERT roysched VALUES('PS2091',5001,10000,14)
INSERT roysched VALUES('PS2091',10001,50000,16)
INSERT roysched VALUES('PS2106',0,2000,10)
INSERT roysched VALUES('PS2106',2001,5000,12)
INSERT roysched VALUES('PS2106',5001,10000,14)
INSERT roysched VALUES('PS2106',10001,50000,16)
INSERT roysched VALUES('MC3021',0,1000,10)
INSERT roysched VALUES('MC3021',1001,2000,12)
INSERT roysched VALUES('MC3021',2001,4000,14)
INSERT roysched VALUES('MC3021',4001,6000,16)
INSERT roysched VALUES('MC3021',6001,8000,18)
INSERT roysched VALUES('MC3021',8001,10000,20)
INSERT roysched VALUES('MC3021',10001,12000,22)
INSERT roysched VALUES('MC3021',12001,50000,24)
INSERT roysched VALUES('TC3218',0,2000,10)
INSERT roysched VALUES('TC3218',2001,4000,12)
INSERT roysched VALUES('TC3218',4001,6000,14)
INSERT roysched VALUES('TC3218',6001,8000,16)
INSERT roysched VALUES('TC3218',8001,10000,18)
INSERT roysched VALUES('TC3218',10001,12000,20)
INSERT roysched VALUES('TC3218',12001,14000,22)
INSERT roysched VALUES('TC3218',14001,50000,24)
INSERT roysched VALUES('PC8888',0,5000,10)
INSERT roysched VALUES('PC8888',5001,10000,12)
INSERT roysched VALUES('PC8888',10001,15000,14)
INSERT roysched VALUES('PC8888',15001,50000,16)
INSERT roysched VALUES('PS7777',0,5000,10)
INSERT roysched VALUES('PS7777',5001,50000,12)
INSERT roysched VALUES('PS3333',0,5000,10)
INSERT roysched VALUES('PS3333',5001,10000,12)
INSERT roysched VALUES('PS3333',10001,15000,14)
INSERT roysched VALUES('PS3333',15001,50000,16)
INSERT roysched VALUES('BU1111',0,4000,10)
INSERT roysched VALUES('BU1111',4001,8000,12)
INSERT roysched VALUES('BU1111',8001,10000,14)
INSERT roysched VALUES('BU1111',12001,16000,16)
INSERT roysched VALUES('BU1111',16001,20000,18)
INSERT roysched VALUES('BU1111',20001,24000,20)
INSERT roysched VALUES('BU1111',24001,28000,22)
INSERT roysched VALUES('BU1111',28001,50000,24)
INSERT roysched VALUES('MC2222',0,2000,10)
INSERT roysched VALUES('MC2222',2001,4000,12)
INSERT roysched VALUES('MC2222',4001,8000,14)
INSERT roysched VALUES('MC2222',8001,12000,16)
INSERT roysched VALUES('MC2222',12001,20000,18)
INSERT roysched VALUES('MC2222',20001,50000,20)
INSERT roysched VALUES('TC7777',0,5000,10)
INSERT roysched VALUES('TC7777',5001,15000,12)
INSERT roysched VALUES('TC7777',15001,50000,14)
INSERT roysched VALUES('TC4203',0,2000,10)
INSERT roysched VALUES('TC4203',2001,8000,12)
INSERT roysched VALUES('TC4203',8001,16000,14)
INSERT roysched VALUES('TC4203',16001,24000,16)
INSERT roysched VALUES('TC4203',24001,32000,18)
INSERT roysched VALUES('TC4203',32001,40000,20)
INSERT roysched VALUES('TC4203',40001,50000,22)
INSERT roysched VALUES('BU7832',0,5000,10)
INSERT roysched VALUES('BU7832',5001,10000,12)
INSERT roysched VALUES('BU7832',10001,15000,14)
INSERT roysched VALUES('BU7832',15001,20000,16)
INSERT roysched VALUES('BU7832',20001,25000,18)
INSERT roysched VALUES('BU7832',25001,30000,20)
INSERT roysched VALUES('BU7832',30001,35000,22)
INSERT roysched VALUES('BU7832',35001,50000,24)
INSERT roysched VALUES('PS1372',0,10000,10)
INSERT roysched VALUES('PS1372',10001,20000,12)
INSERT roysched VALUES('PS1372',20001,30000,14)
INSERT roysched VALUES('PS1372',30001,40000,16)
INSERT roysched VALUES('PS1372',40001,50000,18)
GO

-- DATOS: discounts
INSERT discounts VALUES('Initial Customer', NULL, NULL, NULL, 10.5)
INSERT discounts VALUES('Volume Discount', NULL, 100, 1000, 6.7)
INSERT discounts VALUES('Customer Discount', '8042', NULL, NULL, 5.0)
GO

-- DATOS: jobs
INSERT jobs VALUES ('New Hire - Job not specified', 10, 10)
INSERT jobs VALUES ('Chief Executive Officer', 200, 250)
INSERT jobs VALUES ('Business Operations Manager', 175, 225)
INSERT jobs VALUES ('Chief Financial Officier', 175, 250)
INSERT jobs VALUES ('Publisher', 150, 250)
INSERT jobs VALUES ('Managing Editor', 140, 225)
INSERT jobs VALUES ('Marketing Manager', 120, 200)
INSERT jobs VALUES ('Public Relations Manager', 100, 175)
INSERT jobs VALUES ('Acquisitions Manager', 75, 175)
INSERT jobs VALUES ('Productions Manager', 75, 165)
INSERT jobs VALUES ('Operations Manager', 75, 150)
INSERT jobs VALUES ('Editor', 25, 100)
INSERT jobs VALUES ('Sales Representative', 25, 100)
INSERT jobs VALUES ('Designer', 25, 100)
GO

-- DATOS: employee
INSERT employee VALUES ('PTC11962M','Philip','T','Cramer',2,215,'9952','11/11/89')
INSERT employee VALUES ('AMD15433F','Ann','M','Devon',3,200,'9952','07/16/91')
INSERT employee VALUES ('F-C16315M','Francisco','','Chang',4,227,'9952','11/03/90')
INSERT employee VALUES ('LAL21447M','Laurence','A','Lebihan',5,175,'0736','06/03/90')
INSERT employee VALUES ('PXH22250M','Paul','X','Henriot',5,159,'0877','08/19/93')
INSERT employee VALUES ('SKO22412M','Sven','K','Ottlieb',5,150,'1389','04/05/91')
INSERT employee VALUES ('RBM23061F','Rita','B','Muller',5,198,'1622','10/09/93')
INSERT employee VALUES ('MJP25939M','Maria','J','Pontes',5,246,'1756','03/01/89')
INSERT employee VALUES ('JYL26161F','Janine','Y','Labrune',5,172,'9901','05/26/91')
INSERT employee VALUES ('CFH28514M','Carlos','F','Hernadez',5,211,'9999','04/21/89')
INSERT employee VALUES ('VPA30890F','Victoria','P','Ashworth',6,140,'0877','09/13/90')
INSERT employee VALUES ('L-B31947F','Lesley','','Brown',7,120,'0877','02/13/91')
INSERT employee VALUES ('ARD36773F','Anabela','R','Domingues',8,100,'0877','01/27/93')
INSERT employee VALUES ('M-R38834F','Martine','','Rance',9,75,'0877','02/05/92')
INSERT employee VALUES ('PHF38899M','Peter','H','Franken',10,75,'0877','05/17/92')
INSERT employee VALUES ('DBT39435M','Daniel','B','Tonini',11,75,'0877','01/01/90')
INSERT employee VALUES ('H-B39728F','Helen','','Bennett',12,35,'0877','09/21/89')
INSERT employee VALUES ('PMA42628M','Paolo','M','Accorti',13,35,'0877','08/27/92')
INSERT employee VALUES ('ENL44273F','Elizabeth','N','Lincoln',14,35,'0877','07/24/90')
INSERT employee VALUES ('MGK44605M','Matti','G','Karttunen',6,220,'0736','05/01/94')
INSERT employee VALUES ('PDI47470M','Palle','D','Ibsen',7,195,'0736','05/09/93')
INSERT employee VALUES ('MMS49649F','Mary','M','Saveley',8,175,'0736','06/29/93')
INSERT employee VALUES ('GHT50241M','Gary','H','Thomas',9,170,'0736','08/09/88')
INSERT employee VALUES ('MFS52347M','Martin','F','Sommer',10,165,'0736','04/13/90')
INSERT employee VALUES ('R-M53550M','Roland','','Mendel',11,150,'0736','09/05/91')
INSERT employee VALUES ('HAS54740M','Howard','A','Snyder',12,100,'0736','11/19/88')
INSERT employee VALUES ('TPO55093M','Timothy','P','O''Rourke',13,100,'0736','06/19/88')
INSERT employee VALUES ('KFJ64308F','Karin','F','Josephs',14,100,'0736','10/17/92')
INSERT employee VALUES ('DWR65030M','Diego','W','Roel',6,192,'1389','12/16/91')
INSERT employee VALUES ('M-L67958F','Maria','','Larsson',7,135,'1389','03/27/92')
INSERT employee VALUES ('PSP68661F','Paula','S','Parente',8,125,'1389','01/19/94')
INSERT employee VALUES ('MAS70474F','Margaret','A','Smith',9,78,'1389','09/29/88')
INSERT employee VALUES ('A-C71970F','Aria','','Cruz',10,87,'1389','10/26/91')
INSERT employee VALUES ('MAP77183M','Miguel','A','Paolino',11,112,'1389','12/07/92')
INSERT employee VALUES ('Y-L77953M','Yoshi','','Latimer',12,32,'1389','06/11/89')
INSERT employee VALUES ('CGS88322F','Carine','G','Schmitt',13,64,'1389','07/07/92')
INSERT employee VALUES ('PSA89086M','Pedro','S','Afonso',14,89,'1389','12/24/90')
INSERT employee VALUES ('A-R89858F','Annette','','Roulet',6,152,'9999','02/21/90')
INSERT employee VALUES ('HAN90777M','Helvetius','A','Nagy',7,120,'9999','03/19/93')
INSERT employee VALUES ('M-P91209M','Manuel','','Pereira',8,101,'9999','01/09/89')
INSERT employee VALUES ('KJJ92907F','Karla','J','Jablonski',9,170,'9999','03/11/94')
INSERT employee VALUES ('POK93028M','Pirkko','O','Koskitalo',10,80,'9999','11/29/93')
INSERT employee VALUES ('PCM98509F','Patricia','C','McKenna',11,150,'9999','08/01/89')
GO

-- DATOS: pub_info
INSERT pub_info VALUES('0736', NULL, 'Sample text data for New Moon Books, publisher 0736.')
INSERT pub_info VALUES('0877', NULL, 'Sample text data for Binnet & Hardley, publisher 0877.')
INSERT pub_info VALUES('1389', NULL, 'Sample text data for Algodata Infosystems, publisher 1389.')
INSERT pub_info VALUES('1622', NULL, 'Sample text data for Five Lakes Publishing, publisher 1622.')
INSERT pub_info VALUES('1756', NULL, 'Sample text data for Ramona Publishers, publisher 1756.')
INSERT pub_info VALUES('9901', NULL, 'Sample text data for GGG&G, publisher 9901.')
INSERT pub_info VALUES('9952', NULL, 'Sample text data for Scootney Books, publisher 9952.')
INSERT pub_info VALUES('9999', NULL, 'Sample text data for Lucerne Publishing, publisher 9999.')
GO

-- INDICES
CREATE CLUSTERED INDEX employee_ind ON employee(lname, fname, minit)
CREATE INDEX aunmind ON authors (au_lname, au_fname)
CREATE INDEX titleidind ON sales (title_id)
CREATE INDEX titleind ON titles (title)
CREATE INDEX auidind ON titleauthor (au_id)
CREATE INDEX titleidind ON titleauthor (title_id)
CREATE INDEX titleidind ON roysched (title_id)
GO

PRINT 'BASE DE DATOS PUBS CREADA EXITOSAMENTE.'
GO


/* ================================================================
   PARTE 2: CREACION DE LOS 5 TRIGGERS
   ================================================================ */

PRINT ''
PRINT '============================================'
PRINT 'CREANDO LOS 5 TRIGGERS...'
PRINT '============================================'
GO

-- TRIGGER 1: AFTER INSERT en sales
-- Actualiza ytd_sales en titles sumando la cantidad vendida
CREATE TRIGGER trg_UpdateYtdSales_Insert
ON sales
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON
    UPDATE t
    SET ytd_sales = ISNULL(t.ytd_sales, 0) + i.qty
    FROM titles t
    INNER JOIN inserted i ON t.title_id = i.title_id
END
GO
PRINT 'TRIGGER 1 CREADO: trg_UpdateYtdSales_Insert'
GO

-- TRIGGER 2: AFTER DELETE en sales
-- Actualiza ytd_sales en titles restando la cantidad eliminada
CREATE TRIGGER trg_UpdateYtdSales_Delete
ON sales
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON
    UPDATE t
    SET ytd_sales = ISNULL(t.ytd_sales, 0) - d.qty
    FROM titles t
    INNER JOIN deleted d ON t.title_id = d.title_id
END
GO
PRINT 'TRIGGER 2 CREADO: trg_UpdateYtdSales_Delete'
GO

-- TRIGGER 3: AFTER UPDATE en sales
-- Ajusta ytd_sales segun la diferencia entre la cantidad nueva y la anterior
CREATE TRIGGER trg_UpdateYtdSales_Update
ON sales
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    UPDATE t
    SET ytd_sales = ISNULL(t.ytd_sales, 0) + (i.qty - d.qty)
    FROM titles t
    INNER JOIN inserted i ON t.title_id = i.title_id
    INNER JOIN deleted d ON i.stor_id = d.stor_id AND i.ord_num = d.ord_num AND i.title_id = d.title_id
END
GO
PRINT 'TRIGGER 3 CREADO: trg_UpdateYtdSales_Update'
GO

-- TRIGGER 4: INSTEAD OF DELETE en authors
-- Evita eliminar un autor si tiene libros en titleauthor
CREATE TRIGGER trg_PreventDeleteAuthor
ON authors
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (SELECT 1 FROM deleted d INNER JOIN titleauthor ta ON d.au_id = ta.au_id)
    BEGIN
        RAISERROR('No se puede eliminar un autor que tiene libros registrados en titleauthor.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    DELETE a FROM authors a INNER JOIN deleted d ON a.au_id = d.au_id
END
GO
PRINT 'TRIGGER 4 CREADO: trg_PreventDeleteAuthor'
GO

-- TRIGGER 5: INSTEAD OF DELETE en titles
-- Evita eliminar un titulo si tiene ventas en sales
CREATE TRIGGER trg_PreventDeleteTitle
ON titles
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (SELECT 1 FROM deleted d INNER JOIN sales s ON d.title_id = s.title_id)
    BEGIN
        RAISERROR('No se puede eliminar un titulo que tiene ventas registradas en sales.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    DELETE t FROM titles t INNER JOIN deleted d ON t.title_id = d.title_id
END
GO
PRINT 'TRIGGER 5 CREADO: trg_PreventDeleteTitle'
GO

PRINT ''
PRINT 'LOS 5 TRIGGERS FUERON CREADOS EXITOSAMENTE.'
GO


/* ================================================================
   PARTE 3: DEMO - EJECUCION DE CADA TRIGGER CON TABLAS
   ================================================================ */

PRINT ''
PRINT '============================================'
PRINT 'DEMO: VERIFICACION DE CADA TRIGGER'
PRINT '============================================'
GO

/* ---------- TRIGGER 1: INSERT ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 1 - trg_UpdateYtdSales_Insert'
PRINT 'Evento: AFTER INSERT en tabla sales'
PRINT 'Funcion: suma qty a ytd_sales en titles'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL INSERT ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: INSERT INTO sales VALUES(''7066'',''DEMO1'',GETDATE(),50,''Net 30'',''BU1032'')'
INSERT INTO sales VALUES('7066','DEMO1',GETDATE(),50,'Net 30','BU1032')
PRINT ''
PRINT '--- VALOR DESPUES DEL INSERT (ytd_sales aumento en 50) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 2: UPDATE ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 3 - trg_UpdateYtdSales_Update'
PRINT 'Evento: AFTER UPDATE en tabla sales'
PRINT 'Funcion: ajusta ytd_sales segun diferencia'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL UPDATE ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: UPDATE sales SET qty=30 WHERE ord_num=''DEMO1'' (era 50, diferencia -20)'
UPDATE sales SET qty = 30 WHERE ord_num = 'DEMO1'
PRINT ''
PRINT '--- VALOR DESPUES DEL UPDATE (ytd_sales disminuye en 20) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 3: DELETE ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 2 - trg_UpdateYtdSales_Delete'
PRINT 'Evento: AFTER DELETE en tabla sales'
PRINT 'Funcion: resta qty de ytd_sales en titles'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL DELETE ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: DELETE FROM sales WHERE ord_num=''DEMO1'''
DELETE FROM sales WHERE ord_num = 'DEMO1'
PRINT ''
PRINT '--- VALOR DESPUES DEL DELETE (ytd_sales vuelve al valor original) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 4: INSTEAD OF DELETE authors ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 4 - trg_PreventDeleteAuthor'
PRINT 'Evento: INSTEAD OF DELETE en tabla authors'
PRINT 'Funcion: bloquea borrar autor con libros'
PRINT '============================================'
PRINT ''
PRINT '--- AUTOR QUE INTENTAREMOS ELIMINAR ---'
SELECT au_id AS ID, au_lname + ', ' + au_fname AS Nombre FROM authors WHERE au_id = '172-32-1176'
PRINT ''
PRINT '--- LIBROS ASOCIADOS A ESTE AUTOR ---'
SELECT ta.au_id AS Autor, t.title_id AS TituloID, t.title AS Titulo
FROM titleauthor ta INNER JOIN titles t ON ta.title_id = t.title_id
WHERE ta.au_id = '172-32-1176'
PRINT ''
PRINT 'Ejecutando: DELETE FROM authors WHERE au_id=''172-32-1176'''
PRINT ''
DELETE FROM authors WHERE au_id = '172-32-1176'
PRINT '>>> EL TRIGGER BLOQUEO LA ELIMINACION (RAISERROR + ROLLBACK) <<<'
PRINT ''
PRINT '--- VERIFICACION: EL AUTOR SIGUE EXISTIENDO ---'
SELECT au_id AS ID, au_lname + ', ' + au_fname AS Nombre FROM authors WHERE au_id = '172-32-1176'
GO

/* ---------- TRIGGER 5: INSTEAD OF DELETE titles ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 5 - trg_PreventDeleteTitle'
PRINT 'Evento: INSTEAD OF DELETE en tabla titles'
PRINT 'Funcion: bloquea borrar titulo con ventas'
PRINT '============================================'
PRINT ''
PRINT '--- TITULO QUE INTENTAREMOS ELIMINAR ---'
SELECT title_id AS ID, title AS Titulo FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT '--- VENTAS ASOCIADAS A ESTE TITULO ---'
SELECT title_id AS Titulo, COUNT(*) AS CantVentas FROM sales WHERE title_id = 'BU1032' GROUP BY title_id
PRINT ''
PRINT 'Ejecutando: DELETE FROM titles WHERE title_id=''BU1032'''
PRINT ''
DELETE FROM titles WHERE title_id = 'BU1032'
PRINT '>>> EL TRIGGER BLOQUEO LA ELIMINACION (RAISERROR + ROLLBACK) <<<'
PRINT ''
PRINT '--- VERIFICACION: EL TITULO SIGUE EXISTIENDO ---'
SELECT title_id AS ID, title AS Titulo FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- LISTADO FINAL ---------- */
PRINT ''
PRINT '============================================'
PRINT 'LISTADO DE TODOS LOS TRIGGERS EN LA BD'
PRINT '============================================'
SELECT
    OBJECT_NAME(parent_obj) AS Tabla,
    name AS Trigger_Nombre,
    CASE WHEN OBJECTPROPERTY(id, 'ExecIsAfterTrigger') = 1 THEN 'AFTER'
         WHEN OBJECTPROPERTY(id, 'ExecIsInsteadOfTrigger') = 1 THEN 'INSTEAD OF'
         ELSE 'OTRO' END AS Tipo,
    CASE WHEN OBJECTPROPERTY(id, 'ExecIsInsertTrigger') = 1 THEN 'SI' ELSE 'NO' END AS [INSERT],
    CASE WHEN OBJECTPROPERTY(id, 'ExecIsUpdateTrigger') = 1 THEN 'SI' ELSE 'NO' END AS [UPDATE],
    CASE WHEN OBJECTPROPERTY(id, 'ExecIsDeleteTrigger') = 1 THEN 'SI' ELSE 'NO' END AS [DELETE]
FROM sysobjects
WHERE xtype = 'TR'
ORDER BY name
GO

PRINT ''
PRINT '============================================'
PRINT 'FIN - TODOS LOS TRIGGERS VERIFICADOS'
PRINT '============================================'
GO

/* ================================================================
   EJECUCION INDIVIDUAL DE CADA TRIGGER
   Copiar y ejecutar cada bloque por separado
   ================================================================ */

/* ---------- TRIGGER 1: trg_UpdateYtdSales_Insert ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 1 - trg_UpdateYtdSales_Insert'
PRINT 'Evento: AFTER INSERT en tabla sales'
PRINT 'Funcion: suma qty a ytd_sales en titles'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL INSERT ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: INSERT INTO sales VALUES(''7066'',''DEMO1'',GETDATE(),50,''Net 30'',''BU1032'')'
INSERT INTO sales VALUES('7066','DEMO1',GETDATE(),50,'Net 30','BU1032')
PRINT ''
PRINT '--- VALOR DESPUES DEL INSERT (ytd_sales aumento en 50) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 2: trg_UpdateYtdSales_Update ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 3 - trg_UpdateYtdSales_Update'
PRINT 'Evento: AFTER UPDATE en tabla sales'
PRINT 'Funcion: ajusta ytd_sales segun diferencia'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL UPDATE ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: UPDATE sales SET qty=30 WHERE ord_num=''DEMO1'' (era 50, diferencia -20)'
UPDATE sales SET qty = 30 WHERE ord_num = 'DEMO1'
PRINT ''
PRINT '--- VALOR DESPUES DEL UPDATE (ytd_sales disminuye en 20) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 3: trg_UpdateYtdSales_Delete ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 2 - trg_UpdateYtdSales_Delete'
PRINT 'Evento: AFTER DELETE en tabla sales'
PRINT 'Funcion: resta qty de ytd_sales en titles'
PRINT '============================================'
PRINT ''
PRINT '--- VALOR ANTES DEL DELETE ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT 'Ejecutando: DELETE FROM sales WHERE ord_num=''DEMO1'''
DELETE FROM sales WHERE ord_num = 'DEMO1'
PRINT ''
PRINT '--- VALOR DESPUES DEL DELETE (ytd_sales vuelve al valor original) ---'
SELECT title_id AS ID, title AS Titulo, ytd_sales AS Ventas_Anio FROM titles WHERE title_id = 'BU1032'
GO

/* ---------- TRIGGER 4: trg_PreventDeleteAuthor ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 4 - trg_PreventDeleteAuthor'
PRINT 'Evento: INSTEAD OF DELETE en tabla authors'
PRINT 'Funcion: bloquea borrar autor con libros'
PRINT '============================================'
PRINT ''
PRINT '--- AUTOR QUE INTENTAREMOS ELIMINAR ---'
SELECT au_id AS ID, au_lname + ', ' + au_fname AS Nombre FROM authors WHERE au_id = '172-32-1176'
PRINT ''
PRINT '--- LIBROS ASOCIADOS A ESTE AUTOR ---'
SELECT ta.au_id AS Autor, t.title_id AS TituloID, t.title AS Titulo
FROM titleauthor ta INNER JOIN titles t ON ta.title_id = t.title_id
WHERE ta.au_id = '172-32-1176'
PRINT ''
PRINT 'Ejecutando: DELETE FROM authors WHERE au_id=''172-32-1176'''
DELETE FROM authors WHERE au_id = '172-32-1176'
PRINT ''
PRINT '>>> EL TRIGGER BLOQUEO LA ELIMINACION <<<'
PRINT ''
PRINT '--- VERIFICACION: EL AUTOR SIGUE EXISTIENDO ---'
SELECT au_id AS ID, au_lname + ', ' + au_fname AS Nombre FROM authors WHERE au_id = '172-32-1176'
GO

/* ---------- TRIGGER 5: trg_PreventDeleteTitle ---------- */
PRINT ''
PRINT '============================================'
PRINT 'TRIGGER 5 - trg_PreventDeleteTitle'
PRINT 'Evento: INSTEAD OF DELETE en tabla titles'
PRINT 'Funcion: bloquea borrar titulo con ventas'
PRINT '============================================'
PRINT ''
PRINT '--- TITULO QUE INTENTAREMOS ELIMINAR ---'
SELECT title_id AS ID, title AS Titulo FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT '--- VENTAS ASOCIADAS A ESTE TITULO ---'
SELECT title_id AS Titulo, COUNT(*) AS CantVentas FROM sales WHERE title_id = 'BU1032' GROUP BY title_id
PRINT ''
PRINT 'Ejecutando: DELETE FROM titles WHERE title_id=''BU1032'''
DELETE FROM titles WHERE title_id = 'BU1032'
PRINT ''
PRINT '>>> EL TRIGGER BLOQUEO LA ELIMINACION <<<'
PRINT ''
PRINT '--- VERIFICACION: EL TITULO SIGUE EXISTIENDO ---'
SELECT title_id AS ID, title AS Titulo FROM titles WHERE title_id = 'BU1032'
GO
