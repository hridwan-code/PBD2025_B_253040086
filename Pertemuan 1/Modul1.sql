CREATE DATABASE TokoRetailDB;
GO

USE TokoRetailDB;
GO

PRINT 'Database TokoRetailDB berhasil dibuat dan digunakan.';

CREATE TABLE Produk (
    ProdukID INT,
    SKU VARCHAR(15),
    NamaProduk VARCHAR(100),
    Harga DECIMAL(10, 2),
    Stok INT
);

EXEC sp_help 'Produk';

CREATE TABLE Pelanggan (
    PelangganID INT IDENTITY(1,1) PRIMARY KEY,
    NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    TanggalDaftar DATE DEFAULT GETDATE()
);

EXEC sp_help 'Pelanggan';

CREATE TABLE PesananHeader (
    PesananID INT IDENTITY(1,1) PRIMARY KEY,
    TanggalPesanan DATETIME2 NOT NULL,
    PelangganID INT NOT NULL,
    StatusPesanan VARCHAR(10) NOT NULL,
    CONSTRAINT FK_Pesanan_Pelanggan
    FOREIGN KEY (PelangganID)
    REFERENCES Pelanggan(PelangganID),
    CONSTRAINT CHK_StatusPesanan
    CHECK (StatusPesanan IN ('Baru', 'Proses', 'Selesai'))
);

EXEC sp_help 'PesananHeader';

ALTER TABLE Produk
ALTER COLUMN ProdukID INT NOT NULL;
GO
ALTER TABLE Produk
ADD CONSTRAINT PK_Produk PRIMARY KEY (ProdukID);
GO
ALTER TABLE Pelanggan
ADD NoTelepon VARCHAR(20) NULL;
GO
ALTER TABLE Produk
ALTER COLUMN Harga DECIMAL(10, 2) NOT NULL;
GO

EXEC sp_help 'Produk';
EXEC sp_help 'Pelanggan';

CREATE TABLE PesananDetail (
    PesananDetailID INT IDENTITY(1,1) PRIMARY KEY,
    PesananID INT NOT NULL,
    ProdukID INT NOT NULL,
    Jumlah INT NOT NULL,

    CONSTRAINT FK_Detail_Header
    FOREIGN KEY (PesananID) REFERENCES PesananHeader(PesananID),

    CONSTRAINT FK_Detail_Produk
    FOREIGN KEY (ProdukID) REFERENCES Produk(ProdukID)
);
GO

PRINT 'Mencoba menghapus Pelanggan... (Harusnya Gagal)';
DROP TABLE Pelanggan;
GO

PRINT 'Mencoba menghapus PesananHeader... (Harusnya Gagal)';
DROP TABLE PesananHeader;
GO

PRINT 'Menghapus PesananDetail (tabel anak) terlebih dahulu...';
DROP TABLE PesananDetail;
GO

PRINT 'Menghapus PesananHeader (tabel induk dari detail) ...';
DROP TABLE PesananHeader;
GO

PRINT 'Menghapus Pelanggan (tabel induk dari header)...';
DROP TABLE Pelanggan;
GO

PRINT 'Semua tabel pesanan dan pelanggan berhasil dihapus.';

CREATE TABLE KategoriProduk (
    KategoriID INT IDENTITY(1,1) PRIMARY KEY,
    NamaKategori VARCHAR(100) NOT NULL UNIQUE
);

ALTER TABLE Produk ADD KategoriID INT;

ALTER TABLE Produk 
ADD CONSTRAINT FK_Produk_Kategori
FOREIGN KEY (KategoriID) REFERENCES KategoriProduk(KategoriID);