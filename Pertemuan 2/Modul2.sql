IF DB_ID('TokoRetailDB') IS NOT NULL
BEGIN
USE master;
DROP DATABASE TokoRetailDB;
END
GO

CREATE DATABASE TokoRetailDB;
GO

USE TokoRetailDB;
GO

CREATE TABLE KategoriProduk (
KategoriID INT IDENTITY(1,1) PRIMARY KEY,
NamaKategori VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Produk (
ProdukID INT IDENTITY(1001, 1) PRIMARY KEY,
SKU VARCHAR(20) NOT NULL UNIQUE,
NamaProduk VARCHAR(150) NOT NULL,
Harga DECIMAL(10, 2) NOT NULL,
Stok INT NOT NULL,
KategoriID INT NULL, 
CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0),
CONSTRAINT CHK_StokPositif CHECK (Stok >= 0),
CONSTRAINT FK_Produk_Kategori
FOREIGN KEY (KategoriID)
REFERENCES KategoriProduk(KategoriID)
);
GO

CREATE TABLE Pelanggan (
PelangganID INT IDENTITY(1,1) PRIMARY KEY,
NamaDepan VARCHAR(50) NOT NULL,
NamaBelakang VARCHAR(50) NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
NoTelepon VARCHAR(20) NULL,
TanggalDaftar DATE DEFAULT GETDATE()
);
GO


CREATE TABLE PesananHeader (
PesananID INT IDENTITY(50001, 1) PRIMARY KEY,
PelangganID INT NOT NULL,
TanggalPesanan DATETIME2 DEFAULT GETDATE(),
StatusPesanan VARCHAR(20) NOT NULL,
CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN ('Baru', 'Proses',
'Selesai', 'Batal')),
CONSTRAINT FK_Pesanan_Pelanggan
FOREIGN KEY (PelangganID)
REFERENCES Pelanggan(PelangganID)

);
GO
CREATE TABLE PesananDetail (
PesananDetailID INT IDENTITY(1,1) PRIMARY KEY,
PesananID INT NOT NULL,
ProdukID INT NOT NULL,
Jumlah INT NOT NULL,
HargaSatuan DECIMAL(10, 2) NOT NULL, 
CONSTRAINT CHK_JumlahPositif CHECK (Jumlah > 0),
CONSTRAINT FK_Detail_Header
FOREIGN KEY (PesananID)
REFERENCES PesananHeader(PesananID)
ON DELETE CASCADE, 
CONSTRAINT FK_Detail_Produk
FOREIGN KEY (ProdukID)
REFERENCES Produk(ProdukID)
);
GO
PRINT 'Database TokoRetailDB dan semua tabel berhasil dibuat.';

INSERT INTO Pelanggan (NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES
('Fakhri', 'Zaidi', 'fakhri@gmail.com', '081234567890'),
('Billie', 'Euis', 'billie@gmail.com', NULL);

INSERT INTO KategoriProduk (NamaKategori)
VALUES
('Elektronik'),
('Pakaian'),
('Buku');

PRINT 'Data Pelanggan:';
SELECT * FROM Pelanggan;

PRINT 'Data Kategori:';
SELECT * FROM KategoriProduk;

INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES
('ELEC-001', 'IPHONE 20 PRO MAX', 45000000.00, 50, 1),
('PAK-001', 'Kaos Polo', 75000.00, 200, 2),
('BUK-001', '10 Dosa Besar J-', 120000.00, 100, 3);

PRINT 'Data Produk:';
SELECT P.*, K.NamaKategori
FROM Produk AS P
JOIN KategoriProduk AS K ON P.KategoriID = K.KategoriID;



PRINT 'Uji Coba Error 1 (UNIQUE):';
INSERT INTO Pelanggan (NamaDepan, Email)
VALUES ('Fakhri', 'fakhri@gmail.com');
GO

PRINT 'Uji Coba Error 2 (FOREIGN KEY):';
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES ('XXX-001', 'Produk Aneh', 1000, 10, 99);
GO

PRINT 'Uji Coba Error 3 (CHECK):';
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES ('NGT-001', 'Produk Minus', -50000, 10, 1);
GO



PRINT 'Data Billie SEBELUM Update:';
SELECT * FROM Pelanggan WHERE PelangganID = 2;
BEGIN TRANSACTION;

BEGIN TRANSACTION;

UPDATE Pelanggan
SET NoTelepon = '085566778899'
WHERE PelangganID = 2; 

PRINT 'Data Billie SETELAH Update (Belum di-COMMIT):';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

COMMIT TRANSACTION;

PRINT 'Data Billie setelah di-COMMIT:';
SELECT * FROM Pelanggan WHERE PelangganID = 2;



PRINT 'Data Elektronik SEBELUM Update:';
SELECT * FROM Produk WHERE KategoriID = 1;

BEGIN TRANSACTION;

UPDATE Produk
SET Harga = Harga * 1.10 
WHERE KategoriID = 1;

PRINT 'Data Elektronik SETELAH Update (Belum di-COMMIT):';
SELECT * FROM Produk WHERE KategoriID = 1;
COMMIT TRANSACTION;



PRINT 'Data Produk SEBELUM Delete:';
SELECT * FROM Produk WHERE SKU = 'BUK-001';

BEGIN TRANSACTION;

DELETE FROM Produk
WHERE SKU = 'BUK-001';

PRINT 'Data Produk SETELAH Delete (Belum di-COMMIT):';
SELECT * FROM Produk WHERE SKU = 'BUK-001';

COMMIT TRANSACTION;

PRINT 'Data Stok SEBELUM Bencana:';
SELECT SKU, NamaProduk, Stok FROM Produk;

BEGIN TRANSACTION; 

UPDATE Produk
SET Stok = 0;

PRINT 'Data Stok SETELAH Bencana (PANIK!):';
SELECT SKU, NamaProduk, Stok FROM Produk;

PRINT 'Melakukan ROLLBACK...';
ROLLBACK TRANSACTION;

PRINT 'Data Stok SETELAH di-ROLLBACK (AMAN):';
SELECT SKU, NamaProduk, Stok FROM Produk;


INSERT INTO PesananHeader (PelangganID, StatusPesanan)
VALUES (1, 'Baru');

PRINT 'Data Pesanan Budi:';
SELECT * FROM PesananHeader WHERE PelangganID = 1;
GO

PRINT 'Mencoba menghapus Budi...';
BEGIN TRANSACTION;

DELETE FROM Pelanggan
WHERE PelangganID = 1;

ROLLBACK TRANSACTION;


CREATE TABLE ProdukArsip (
ProdukID INT PRIMARY KEY,
SKU VARCHAR(20) NOT NULL,
NamaProduk VARCHAR(150) NOT NULL,
Harga DECIMAL(10, 2) NOT NULL,
TanggalArsip DATE DEFAULT GETDATE()
);
GO

BEGIN TRANSACTION;

UPDATE Produk SET Stok = 0 WHERE SKU = 'PAK-001';

INSERT INTO ProdukArsip (ProdukID, SKU, NamaProduk, Harga)
SELECT ProdukID, SKU, NamaProduk, Harga
FROM Produk
WHERE Stok = 0;

DELETE FROM Produk
WHERE Stok = 0;

PRINT 'Cek Produk Aktif (Kaos harus hilang):';
SELECT * FROM Produk;

PRINT 'Cek Produk Arsip (Kaos harus ada):';
SELECT * FROM ProdukArsip;

COMMIT TRANSACTION;