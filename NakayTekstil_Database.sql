-- Veritaban� olu�turulmas�
CREATE DATABASE NakayTekstil;
GO

USE NakayTekstil;

-- tKisiler tablosu
CREATE TABLE tKisiler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AdiSoyadi VARCHAR(100) NOT NULL,
    CepTel CHAR(11) NOT NULL UNIQUE,
    TcNo CHAR(11) UNIQUE NOT NULL,
    Adres VARCHAR(250)
);

-- tOdemeBilgileri tablosu (NULL eklenmesi gereksiz)
CREATE TABLE tOdemeBilgileri (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Kisi_tKisilerID INT REFERENCES tKisiler(ID) NOT NULL,
    OdemeSekli VARCHAR(50) NOT NULL,
    Iban VARCHAR(50),
    BankaBilgisi VARCHAR(100),
    OdemeMiktari DECIMAL(8,2) NOT NULL
);

-- �retim A�amalar� tablosu
CREATE TABLE tUretimAsamalari (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AsamaAdi VARCHAR(50) NOT NULL UNIQUE
);
-- Sat�� yap�lan Firmalar
CREATE TABLE tFirmalar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirmaAdi VARCHAR(100) NOT NULL UNIQUE,
    Telefon CHAR(11),
    Adres VARCHAR(250)
);

-- �retilen �r�nler tablosu
CREATE TABLE tUrunler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunAdi VARCHAR(100) NOT NULL,
    Renk VARCHAR(50),
    Firma_tFirmalar int references tFirmalar(ID),
    UretimMaliyeti DECIMAL(10,2) NOT NULL,
    SatisFiyati DECIMAL(10,2) NOT NULL,
    StokAdedi INT DEFAULT 0
);
--Tedarik�iler tablosu
CREATE TABLE tTedarikciler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TedarikciFirmaAdi VARCHAR(100) NOT NULL,
    Telefon CHAR(11),
    Adres VARCHAR(250),
    HammaddeAdi VARCHAR(100) NOT NULL -- Tedarik edilen hammaddeyi belirten alan
);

-- �r�n A�amalar� tablosu
CREATE TABLE tUrunAsamalari (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunID INT REFERENCES tUrunler(ID),
    AsamaID INT REFERENCES tUretimAsamalari(ID),
	Hammadde_tTedarikcilerID int references tTedarikciler(ID),--Kullan�lan kuma� se�ildi
    BaslamaTarihi DATE NOT NULL,
    BitisTarihi DATE,
    SorumluKisiID INT REFERENCES tKisiler(ID)
);
--Sat��lar tablosu
CREATE TABLE tSatislar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunID INT NOT NULL REFERENCES tUrunler(ID),
    SatisTarihi DATE NOT NULL,
    SatisAdedi INT NOT NULL
);
-- tSevkiyatlar (Sevkiyat Bilgileri) Tablosu �r�nlerin sat�� sonras� sevkiyat bilgilerini takip etmek i�in bir tablo.
CREATE TABLE tSevkFirm (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirmaAdi VARCHAR(100) NOT NULL UNIQUE,
    Telefon CHAR(11),
    Adres VARCHAR(250),
    Email VARCHAR(100),
    YetkiliKisi VARCHAR(100) -- Firmadan sorumlu yetkili ki�i
);
--
CREATE TABLE tSevkiyatlar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SatisID INT REFERENCES tSatislar(ID) NOT NULL,
    SevkiyatTarihi DATE NOT NULL,
    TeslimTarihi DATE,
    TeslimDurumu VARCHAR(50), -- �rne�in: "Teslim Edildi", "Yolda"
    TeslimAlanKisi VARCHAR(100),
    sevkF_tSevkFirm INT REFERENCES tSevkFirm(ID) -- Sevkiyat firmas� bilgisi
);



	-- tKisiler tablosuna veri ekleme
	INSERT INTO tKisiler (AdiSoyadi, CepTel, TcNo, Adres)
	VALUES 
	('Ahmet Y�lmaz', '05311234567', '12345678901', '�stanbul'),
	('Mehmet Demir', '05326543210', '10987654321', 'Ankara'),
	('Fatma Kaya', '05445566778', '11223344556', '�zmir'),
	('Ay�e G�ne�', '05447788990', '22334455667', 'Antalya'),
	('Ali �ahin', '05336677889', '33445566778', 'Bursa');

	-- tOdemeBilgileri tablosuna veri ekleme
	INSERT INTO tOdemeBilgileri (Kisi_tKisilerID, OdemeSekli, Iban, BankaBilgisi, OdemeMiktari)
	VALUES 
	(1, 'Banka Havalesi', 'TR001234567890123456789012', 'Ziraat Bankas�', 2500.50),
	(2, 'Banka Havalesi', 'TR002345678901234567890123', '�� Bankas�', 3000.00),
	(3, 'Nakit', NULL, NULL, 1500.75),
	(4, 'Banka Havalesi', 'TR003456789012345678901234', 'Yap� Kredi', 2750.20),
	(5, 'Banka Havalesi', 'TR004567890123456789012345', 'Akbank', 3200.00);

	-- tUretimAsamalari tablosuna veri ekleme
	INSERT INTO tUretimAsamalari (AsamaAdi)
	VALUES 
	('Kesim'),
	('Dikim'),
	('Kalite Kontrol'),
	('Bask�/Desen'),
	('Y�kama Temizleme'),
	('�t�'),
	('Etiketleme'),
	('Katlama'),
	('Paketleme'),
	('Lojistik Haz�rl�k');


	INSERT INTO tFirmalar (FirmaAdi, Telefon, Adres)
	VALUES 
	('DenimCo Giyim', '02124445566', '�stanbul'),
	('Y�lmazlar Giyim', '02123334455', '�zmir'),
	('ModaLine', '03125556677', 'Ankara'),
	('Atlas Moda', '02324447788', 'Bursa'),
	('Kuzey Giyim', '02446677889', 'Antalya');

	-- tUrunler tablosuna �r�n ekleme
	INSERT INTO tUrunler (UrunAdi, Renk, Firma_tFirmalar, UretimMaliyeti, SatisFiyati, StokAdedi)
	VALUES 
	('Pamuklu Polo Yaka Ti��rt', 'Beyaz', 2, 40.00, 90.00, 1200),
	('Ta� ��lemeli Kot Pantolon', 'A��k Mavi', 1, 80.00, 200.00, 750),
	('�pek Klasik G�mlek', 'Bordo', 3, 90.00, 250.00, 300),
	('Kadife Kalem Etek', 'Siyah', 4, 70.00, 180.00, 400),
	('Su Ge�irmez K��l�k Mont', 'Koyu Gri', 5, 250.00, 600.00, 200);

	--tTedariciler tablsouna veri ekleme
	INSERT INTO tTedarikciler (TedarikciFirmaAdi, Telefon, Adres, HammaddeAdi)
	VALUES 
	('Y�ld�z Kuma� Sanayi', '02124445566', '�stanbul', 'Pamuk Kuma��'),
	('DenimTech Kuma�', '02123334455', '�zmir', 'Denim Kuma��'),
	('�pekYol Kuma�', '03125556677', 'Ankara', '�pek Kuma��'),
	('KadifeZeytin', '02324447788', 'Bursa', 'Kadife Kuma�'),
	('Ye�il Tekstil A.�.', '02446677889', 'Antalya', 'Su Ge�irmez Kuma�');

	-- tUrunAsamalari tablosuna veri ekleme
	INSERT INTO tUrunAsamalari (UrunID, AsamaID,Hammadde_tTedarikcilerID, BaslamaTarihi, BitisTarihi, SorumluKisiID)
	VALUES 
	(1, 1, 1,'2024-12-01', '2024-12-02', 1),
	(1, 6, 5, '2024-12-03', '2024-12-04', 2),
	(2, 2, 2, '2024-12-02', '2024-12-03', 3),
	(3, 3, 3 ,'2024-12-01', '2024-12-01', 4),
	(4, 8, 4, '2024-12-02', '2024-12-03', 5),
	(5, 7, 5,'2024-12-05', '2024-12-06', 1);

	-- tSatislar tablosuna veri ekleme
	INSERT INTO tSatislar (UrunID, SatisTarihi, SatisAdedi)
	VALUES 
	(1, '2024-12-10', 100),  -- Pamuklu Polo Yaka Ti��rt
	(2, '2024-12-11', 50),   -- Ta� ��lemeli Kot Pantolon
	(3, '2024-12-12', 25),   -- �pek Klasik G�mlek
	(4, '2024-12-13', 30),   -- Kadife Kalem Etek
	(5, '2024-12-14', 15);   -- Su Ge�irmez K��l�k Mont

	INSERT INTO  tSevkFirm(FirmaAdi, Telefon, Adres, Email, YetkiliKisi)
VALUES 
('H�zl�Kargo A.�.', '02123334444', '�stanbul', 'iletisim@hizlikargo.com', 'Kemal Aksoy'),
('GlobalExpress Lojistik', '03124445555', 'Ankara', 'info@globalexpress.com', 'Ay�e Erdem'),
('Anadolu Kargo', '02323334466', '�zmir', 'destek@anadolukargo.com', 'Hasan Kaya'),
('MegaTa��mac�l�k', '04124447788', 'Trabzon', 'iletisim@megatasimacilik.com', 'Buse Y�lmaz'),
('Do�uEkspres', '04224448899', 'Van', 'info@doguekspres.com', 'Ali Demir');
INSERT INTO tSevkiyatlar (SatisID, SevkiyatTarihi, TeslimTarihi, TeslimDurumu, TeslimAlanKisi, sevkF_tSevkFirm )
VALUES 
(1, '2024-12-11', '2024-12-12', 'Teslim Edildi', 'Ahmet Y�lmaz', 1), -- Pamuklu Polo Yaka Ti��rt
(2, '2024-12-12', '2024-12-13', 'Teslim Edildi', 'Mehmet Demir', 2), -- Ta� ��lemeli Kot Pantolon
(3, '2024-12-13', '2024-12-14', 'Yolda', 'Fatma Kaya', 3),           -- �pek Klasik G�mlek
(4, '2024-12-14', '2024-12-15', 'Teslim Edildi', 'Ay�e G�ne�', 4),   -- Kadife Kalem Etek
(5, '2024-12-15', '2024-12-16', 'Yolda', 'Ali �ahin', 5);            -- Su Ge�irmez K��l�k Mont

-- 5. VIEW'LER
/*View (G�r�n�m), bir veritaban�ndaki bir veya birden fazla tablodan al�nan verilerin sanal bir tablosudur.
Fiziksel bir tablo de�ildir, yani veriler bir view i�inde saklanmaz. 
Veriler view olu�turulurken kullan�lan SQL sorgusu �al��t�r�ld���nda dinamik olarak al�n�r.
View'ler, karma��k sorgular� daha kolay hale getirmek, veri g�venli�ini sa�lamak veya belirli kullan�c�lar i�in veriyi filtreleyerek g�stermek amac�yla kullan�l�r.
Karma��k ve s�k kullan�lan sorgular� bir view i�inde tan�mlayarak yeniden kullan�labilir hale getirmek, baz� durumlarda sorgu performans�n� art�rabilir.*/

-- 1. Ama�: Stok miktar� s�f�rdan b�y�k olan ve sat��a haz�r durumdaki �r�nleri listelemek.
CREATE VIEW vAktifUrunStoklari AS ----AS ile view'i tan�ml�yoruz
SELECT 
    u.UrunAdi, 
    u.Renk, 
    f.FirmaAdi, 
    u.StokAdedi, 
    u.SatisFiyati
FROM tUrunler u
LEFT JOIN tFirmalar f ON u.Firma_tFirmalar = f.ID
WHERE u.StokAdedi > 0;

--2. Ki�ilerin �r�n Sorumluluklar� kimin hangi �r�n�n hangi a�amas�nda g�rev ald���na dair bir view
CREATE VIEW vKisiSorumluluklari AS
SELECT 
    k.AdiSoyadi,
    u.UrunAdi,
    a.AsamaAdi,
    ua.BaslamaTarihi,
    ua.BitisTarihi
FROM tUrunAsamalari ua
LEFT JOIN tKisiler k ON ua.SorumluKisiID = k.ID
LEFT JOIN tUrunler u ON ua.UrunID = u.ID
LEFT JOIN tUretimAsamalari a ON ua.AsamaID = a.ID;

-- 3.Ama�: Sat�� yap�lan �r�nlerin �zet bilgilerini g�stermek (�r�n ad�, sat�� adedi, toplam gelir).
CREATE VIEW vSatisOzet AS
SELECT 
    tUrunler.UrunAdi,
    SUM(tSatislar.SatisAdedi) AS ToplamSatisAdedi,
    SUM(tSatislar.SatisAdedi * tUrunler.SatisFiyati) AS ToplamGelir
FROM tSatislar
LEFT JOIN tUrunler ON tSatislar.UrunID = tUrunler.ID
GROUP BY tUrunler.UrunAdi;



-- 4. Stok Durumu ve Kar
CREATE VIEW vStokKar AS
SELECT 
    UrunAdi, 
    StokAdedi, 
    (SatisFiyati - UretimMaliyeti) * StokAdedi AS ToplamKar
FROM tUrunler
WHERE StokAdedi > 0;--S�f�r stoklar� hari� tutmak i�in
--5. En �ok Satan �r�nler:
CREATE VIEW vEnCokSatanUrunler AS
SELECT TOP 10 
    u.UrunAdi,
    SUM(s.SatisAdedi) AS ToplamSatisAdedi
FROM tSatislar s
LEFT JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY u.UrunAdi
ORDER BY SUM(s.SatisAdedi) DESC;



-- 6. Indexlerin Olu�turulmas�
-- Indexler performans optimizasyonu sa�lamak, sorgu h�z�n� art�rmak ve ili�kili tablolarda daha h�zl� eri�im sa�lamak amac�yla olu�turulur.

-- tKisiler tablosunda TcNo i�in benzersiz bir index (unique constraint mevcut ancak h�zl� eri�im i�in ayr� bir index eklenebilir)
CREATE UNIQUE INDEX IX_tKisiler_TcNo ON tKisiler(TcNo);

-- tOdemeBilgileri tablosunda Kisi_tKisilerID i�in index
CREATE INDEX IX_tOdemeBilgileri_KisiID ON tOdemeBilgileri(Kisi_tKisilerID);

-- tUrunler tablosunda Firma_tFirmalar i�in index
CREATE INDEX IX_tUrunler_FirmaID ON tUrunler(Firma_tFirmalar);

-- tUrunAsamalari tablosunda UrunID ve AsamaID i�in index
CREATE INDEX IX_tUrunAsamalari_UrunID_AsamaID ON tUrunAsamalari(UrunID, AsamaID);

-- tSatislar tablosunda UrunID i�in index
CREATE INDEX IX_tSatislar_UrunID ON tSatislar(UrunID);

-- tSevkiyatlar tablosunda SatisID i�in index
CREATE INDEX IX_tSevkiyatlar_SatisID ON tSevkiyatlar(SatisID);


-- 9. G�nl�k Karlar�n Listelenmesi
SELECT 
    s.SatisTarihi,
    u.UrunAdi,
    SUM(s.SatisAdedi * (u.SatisFiyati - u.UretimMaliyeti)) AS GunlukKar
FROM tSatislar s
JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY s.SatisTarihi, u.UrunAdi
ORDER BY s.SatisTarihi;

-- 10. Ortalama Ayl�k Kar�n Alt�ndaki Sat��lar�n Listelenmesi
WITH AylikKar AS (
    SELECT 
        YEAR(SatisTarihi) AS Yil,
        MONTH(SatisTarihi) AS Ay,
        SUM(s.SatisAdedi * (u.SatisFiyati - u.UretimMaliyeti)) AS AylikKar
    FROM tSatislar s
    JOIN tUrunler u ON s.UrunID = u.ID
    GROUP BY YEAR(SatisTarihi), MONTH(SatisTarihi)
), OrtalamaKar AS (
    SELECT AVG(AylikKar) AS OrtalamaAylikKar FROM AylikKar
)
SELECT *
FROM AylikKar
WHERE AylikKar < (SELECT OrtalamaAylikKar FROM OrtalamaKar);

-- 11. Zarar Edilen �r�nlerin Listelenmesi
SELECT 
    u.UrunAdi,
    (u.SatisFiyati - u.UretimMaliyeti) AS KarMiktari
FROM tUrunler u
WHERE u.SatisFiyati < u.UretimMaliyeti;

-- 12. En �ok Sat�lan �r�n�n Listelenmesi
SELECT TOP 1 
    u.UrunAdi,
    SUM(s.SatisAdedi) AS ToplamSatisAdedi
FROM tSatislar s
JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY u.UrunAdi
ORDER BY SUM(s.SatisAdedi) DESC;

-- 13. Procedure'lar

-- 1. G�nl�k Kar� Hesaplayan Procedure
CREATE PROCEDURE spGunlukKar
AS
BEGIN
    SELECT 
        s.SatisTarihi,
        SUM(s.SatisAdedi * (u.SatisFiyati - u.UretimMaliyeti)) AS GunlukKar
    FROM tSatislar s
    JOIN tUrunler u ON s.UrunID = u.ID
    GROUP BY s.SatisTarihi
    ORDER BY s.SatisTarihi;
END;

-- Procedure'�n �al��t�r�lmas�
EXEC spGunlukKar;

-- 2. Ayl�k Ortalama Kar Alt�ndaki Sat��lar� Listeleyen Procedure
CREATE PROCEDURE spAylikKarAltinda
AS
BEGIN
    WITH AylikKar AS (
        SELECT 
            YEAR(SatisTarihi) AS Yil,
            MONTH(SatisTarihi) AS Ay,
            SUM(s.SatisAdedi * (u.SatisFiyati - u.UretimMaliyeti)) AS AylikKar
        FROM tSatislar s
        JOIN tUrunler u ON s.UrunID = u.ID
        GROUP BY YEAR(SatisTarihi), MONTH(SatisTarihi)
    ), OrtalamaKar AS (
        SELECT AVG(AylikKar) AS OrtalamaAylikKar FROM AylikKar
    )
    SELECT *
    FROM AylikKar
    WHERE AylikKar < (SELECT OrtalamaAylikKar FROM OrtalamaKar);
END;

-- Procedure'�n �al��t�r�lmas�
EXEC spAylikKarAltinda;

-- 3. Zarar Edilen �r�nleri Listeleyen Procedure
CREATE PROCEDURE spZararEdilenUrunler
AS
BEGIN
    SELECT 
        u.UrunAdi,
        (u.SatisFiyati - u.UretimMaliyeti) AS KarMiktari
    FROM tUrunler u
    WHERE u.SatisFiyati < u.UretimMaliyeti;
END;

-- Procedure'�n �al��t�r�lmas�
EXEC spZararEdilenUrunler;

-- 4. En �ok Sat�lan �r�n� Listeleyen Procedure
CREATE PROCEDURE spEnCokSatilanUrun
AS
BEGIN
    SELECT TOP 1 
        u.UrunAdi,
        SUM(s.SatisAdedi) AS ToplamSatisAdedi
    FROM tSatislar s
    JOIN tUrunler u ON s.UrunID = u.ID
    GROUP BY u.UrunAdi
    ORDER BY SUM(s.SatisAdedi) DESC;
END;

-- Procedure'�n �al��t�r�lmas�
EXEC spEnCokSatilanUrun;

-- 5. �r�n Stok Durumunu G�ncelleyen Procedure
CREATE PROCEDURE spStokGuncelle
    @UrunID INT,
    @YeniStok INT
AS
BEGIN
    UPDATE tUrunler
    SET StokAdedi = @YeniStok
    WHERE ID = @UrunID;
END;

-- Procedure'�n �al��t�r�lmas�
EXEC spStokGuncelle @UrunID = 1, @YeniStok = 1500;
-- 7. Tablolardaki De�erlerin/Kay�tlar�n Silinmesi
-- Silme i�lemleri tablolar�n ili�kilerine dikkat edilerek yap�lmal�d�r.

-- tSevkiyatlar tablosundaki t�m kay�tlar� silme
DELETE FROM tSevkiyatlar;

-- tSevkFirm tablosundaki t�m kay�tlar� silme
DELETE FROM tSevkFirm;

-- tSatislar tablosundaki t�m kay�tlar� silme (ba�l� tSevkiyatlar kay�tlar� da silinir)
DELETE FROM tSatislar;

-- tUrunAsamalari tablosundaki t�m kay�tlar� silme
DELETE FROM tUrunAsamalari;

-- tSevkFirm tablosundaki t�m kay�tlar� silme
DELETE FROM tTedarikciler;

-- tUrunler tablosundaki t�m kay�tlar� silme (ba�l� tSatislar ve tUrunAsamalari kay�tlar� da silinir)
DELETE FROM tUrunler;

-- tFirmalar tablosundaki t�m kay�tlar� silme (ba�l� tUrunler kay�tlar� da silinir)
DELETE FROM tFirmalar;

-- tSevkFirm tablosundaki t�m kay�tlar� silme
DELETE FROM tUretimAsamalari;

-- tSevkFirm tablosundaki t�m kay�tlar� silme
DELETE FROM tOdemeBilgileri;
-- tKisiler tablosundaki t�m kay�tlar� silme (ba�l� tOdemeBilgileri ve tUrunAsamalari kay�tlar� da silinir)
DELETE FROM tKisiler;
