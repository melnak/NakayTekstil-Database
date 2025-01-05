-- Veritabaný oluþturulmasý
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

-- Üretim Aþamalarý tablosu
CREATE TABLE tUretimAsamalari (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AsamaAdi VARCHAR(50) NOT NULL UNIQUE
);
-- Satýþ yapýlan Firmalar
CREATE TABLE tFirmalar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirmaAdi VARCHAR(100) NOT NULL UNIQUE,
    Telefon CHAR(11),
    Adres VARCHAR(250)
);

-- Üretilen Ürünler tablosu
CREATE TABLE tUrunler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunAdi VARCHAR(100) NOT NULL,
    Renk VARCHAR(50),
    Firma_tFirmalar int references tFirmalar(ID),
    UretimMaliyeti DECIMAL(10,2) NOT NULL,
    SatisFiyati DECIMAL(10,2) NOT NULL,
    StokAdedi INT DEFAULT 0
);
--Tedarikçiler tablosu
CREATE TABLE tTedarikciler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TedarikciFirmaAdi VARCHAR(100) NOT NULL,
    Telefon CHAR(11),
    Adres VARCHAR(250),
    HammaddeAdi VARCHAR(100) NOT NULL -- Tedarik edilen hammaddeyi belirten alan
);

-- Ürün Aþamalarý tablosu
CREATE TABLE tUrunAsamalari (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunID INT REFERENCES tUrunler(ID),
    AsamaID INT REFERENCES tUretimAsamalari(ID),
	Hammadde_tTedarikcilerID int references tTedarikciler(ID),--Kullanýlan kumaþ seçildi
    BaslamaTarihi DATE NOT NULL,
    BitisTarihi DATE,
    SorumluKisiID INT REFERENCES tKisiler(ID)
);
--Satýþlar tablosu
CREATE TABLE tSatislar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UrunID INT NOT NULL REFERENCES tUrunler(ID),
    SatisTarihi DATE NOT NULL,
    SatisAdedi INT NOT NULL
);
-- tSevkiyatlar (Sevkiyat Bilgileri) Tablosu Ürünlerin satýþ sonrasý sevkiyat bilgilerini takip etmek için bir tablo.
CREATE TABLE tSevkFirm (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirmaAdi VARCHAR(100) NOT NULL UNIQUE,
    Telefon CHAR(11),
    Adres VARCHAR(250),
    Email VARCHAR(100),
    YetkiliKisi VARCHAR(100) -- Firmadan sorumlu yetkili kiþi
);
--
CREATE TABLE tSevkiyatlar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SatisID INT REFERENCES tSatislar(ID) NOT NULL,
    SevkiyatTarihi DATE NOT NULL,
    TeslimTarihi DATE,
    TeslimDurumu VARCHAR(50), -- Örneðin: "Teslim Edildi", "Yolda"
    TeslimAlanKisi VARCHAR(100),
    sevkF_tSevkFirm INT REFERENCES tSevkFirm(ID) -- Sevkiyat firmasý bilgisi
);



	-- tKisiler tablosuna veri ekleme
	INSERT INTO tKisiler (AdiSoyadi, CepTel, TcNo, Adres)
	VALUES 
	('Ahmet Yýlmaz', '05311234567', '12345678901', 'Ýstanbul'),
	('Mehmet Demir', '05326543210', '10987654321', 'Ankara'),
	('Fatma Kaya', '05445566778', '11223344556', 'Ýzmir'),
	('Ayþe Güneþ', '05447788990', '22334455667', 'Antalya'),
	('Ali Þahin', '05336677889', '33445566778', 'Bursa');

	-- tOdemeBilgileri tablosuna veri ekleme
	INSERT INTO tOdemeBilgileri (Kisi_tKisilerID, OdemeSekli, Iban, BankaBilgisi, OdemeMiktari)
	VALUES 
	(1, 'Banka Havalesi', 'TR001234567890123456789012', 'Ziraat Bankasý', 2500.50),
	(2, 'Banka Havalesi', 'TR002345678901234567890123', 'Ýþ Bankasý', 3000.00),
	(3, 'Nakit', NULL, NULL, 1500.75),
	(4, 'Banka Havalesi', 'TR003456789012345678901234', 'Yapý Kredi', 2750.20),
	(5, 'Banka Havalesi', 'TR004567890123456789012345', 'Akbank', 3200.00);

	-- tUretimAsamalari tablosuna veri ekleme
	INSERT INTO tUretimAsamalari (AsamaAdi)
	VALUES 
	('Kesim'),
	('Dikim'),
	('Kalite Kontrol'),
	('Baský/Desen'),
	('Yýkama Temizleme'),
	('Ütü'),
	('Etiketleme'),
	('Katlama'),
	('Paketleme'),
	('Lojistik Hazýrlýk');


	INSERT INTO tFirmalar (FirmaAdi, Telefon, Adres)
	VALUES 
	('DenimCo Giyim', '02124445566', 'Ýstanbul'),
	('Yýlmazlar Giyim', '02123334455', 'Ýzmir'),
	('ModaLine', '03125556677', 'Ankara'),
	('Atlas Moda', '02324447788', 'Bursa'),
	('Kuzey Giyim', '02446677889', 'Antalya');

	-- tUrunler tablosuna ürün ekleme
	INSERT INTO tUrunler (UrunAdi, Renk, Firma_tFirmalar, UretimMaliyeti, SatisFiyati, StokAdedi)
	VALUES 
	('Pamuklu Polo Yaka Tiþört', 'Beyaz', 2, 40.00, 90.00, 1200),
	('Taþ Ýþlemeli Kot Pantolon', 'Açýk Mavi', 1, 80.00, 200.00, 750),
	('Ýpek Klasik Gömlek', 'Bordo', 3, 90.00, 250.00, 300),
	('Kadife Kalem Etek', 'Siyah', 4, 70.00, 180.00, 400),
	('Su Geçirmez Kýþlýk Mont', 'Koyu Gri', 5, 250.00, 600.00, 200);

	--tTedariciler tablsouna veri ekleme
	INSERT INTO tTedarikciler (TedarikciFirmaAdi, Telefon, Adres, HammaddeAdi)
	VALUES 
	('Yýldýz Kumaþ Sanayi', '02124445566', 'Ýstanbul', 'Pamuk Kumaþý'),
	('DenimTech Kumaþ', '02123334455', 'Ýzmir', 'Denim Kumaþý'),
	('ÝpekYol Kumaþ', '03125556677', 'Ankara', 'Ýpek Kumaþý'),
	('KadifeZeytin', '02324447788', 'Bursa', 'Kadife Kumaþ'),
	('Yeþil Tekstil A.Þ.', '02446677889', 'Antalya', 'Su Geçirmez Kumaþ');

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
	(1, '2024-12-10', 100),  -- Pamuklu Polo Yaka Tiþört
	(2, '2024-12-11', 50),   -- Taþ Ýþlemeli Kot Pantolon
	(3, '2024-12-12', 25),   -- Ýpek Klasik Gömlek
	(4, '2024-12-13', 30),   -- Kadife Kalem Etek
	(5, '2024-12-14', 15);   -- Su Geçirmez Kýþlýk Mont

	INSERT INTO  tSevkFirm(FirmaAdi, Telefon, Adres, Email, YetkiliKisi)
VALUES 
('HýzlýKargo A.Þ.', '02123334444', 'Ýstanbul', 'iletisim@hizlikargo.com', 'Kemal Aksoy'),
('GlobalExpress Lojistik', '03124445555', 'Ankara', 'info@globalexpress.com', 'Ayþe Erdem'),
('Anadolu Kargo', '02323334466', 'Ýzmir', 'destek@anadolukargo.com', 'Hasan Kaya'),
('MegaTaþýmacýlýk', '04124447788', 'Trabzon', 'iletisim@megatasimacilik.com', 'Buse Yýlmaz'),
('DoðuEkspres', '04224448899', 'Van', 'info@doguekspres.com', 'Ali Demir');
INSERT INTO tSevkiyatlar (SatisID, SevkiyatTarihi, TeslimTarihi, TeslimDurumu, TeslimAlanKisi, sevkF_tSevkFirm )
VALUES 
(1, '2024-12-11', '2024-12-12', 'Teslim Edildi', 'Ahmet Yýlmaz', 1), -- Pamuklu Polo Yaka Tiþört
(2, '2024-12-12', '2024-12-13', 'Teslim Edildi', 'Mehmet Demir', 2), -- Taþ Ýþlemeli Kot Pantolon
(3, '2024-12-13', '2024-12-14', 'Yolda', 'Fatma Kaya', 3),           -- Ýpek Klasik Gömlek
(4, '2024-12-14', '2024-12-15', 'Teslim Edildi', 'Ayþe Güneþ', 4),   -- Kadife Kalem Etek
(5, '2024-12-15', '2024-12-16', 'Yolda', 'Ali Þahin', 5);            -- Su Geçirmez Kýþlýk Mont

-- 5. VIEW'LER
/*View (Görünüm), bir veritabanýndaki bir veya birden fazla tablodan alýnan verilerin sanal bir tablosudur.
Fiziksel bir tablo deðildir, yani veriler bir view içinde saklanmaz. 
Veriler view oluþturulurken kullanýlan SQL sorgusu çalýþtýrýldýðýnda dinamik olarak alýnýr.
View'ler, karmaþýk sorgularý daha kolay hale getirmek, veri güvenliðini saðlamak veya belirli kullanýcýlar için veriyi filtreleyerek göstermek amacýyla kullanýlýr.
Karmaþýk ve sýk kullanýlan sorgularý bir view içinde tanýmlayarak yeniden kullanýlabilir hale getirmek, bazý durumlarda sorgu performansýný artýrabilir.*/

-- 1. Amaç: Stok miktarý sýfýrdan büyük olan ve satýþa hazýr durumdaki ürünleri listelemek.
CREATE VIEW vAktifUrunStoklari AS ----AS ile view'i tanýmlýyoruz
SELECT 
    u.UrunAdi, 
    u.Renk, 
    f.FirmaAdi, 
    u.StokAdedi, 
    u.SatisFiyati
FROM tUrunler u
LEFT JOIN tFirmalar f ON u.Firma_tFirmalar = f.ID
WHERE u.StokAdedi > 0;

--2. Kiþilerin Ürün Sorumluluklarý kimin hangi ürünün hangi aþamasýnda görev aldýðýna dair bir view
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

-- 3.Amaç: Satýþ yapýlan ürünlerin özet bilgilerini göstermek (ürün adý, satýþ adedi, toplam gelir).
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
WHERE StokAdedi > 0;--Sýfýr stoklarý hariç tutmak için
--5. En Çok Satan Ürünler:
CREATE VIEW vEnCokSatanUrunler AS
SELECT TOP 10 
    u.UrunAdi,
    SUM(s.SatisAdedi) AS ToplamSatisAdedi
FROM tSatislar s
LEFT JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY u.UrunAdi
ORDER BY SUM(s.SatisAdedi) DESC;



-- 6. Indexlerin Oluþturulmasý
-- Indexler performans optimizasyonu saðlamak, sorgu hýzýný artýrmak ve iliþkili tablolarda daha hýzlý eriþim saðlamak amacýyla oluþturulur.

-- tKisiler tablosunda TcNo için benzersiz bir index (unique constraint mevcut ancak hýzlý eriþim için ayrý bir index eklenebilir)
CREATE UNIQUE INDEX IX_tKisiler_TcNo ON tKisiler(TcNo);

-- tOdemeBilgileri tablosunda Kisi_tKisilerID için index
CREATE INDEX IX_tOdemeBilgileri_KisiID ON tOdemeBilgileri(Kisi_tKisilerID);

-- tUrunler tablosunda Firma_tFirmalar için index
CREATE INDEX IX_tUrunler_FirmaID ON tUrunler(Firma_tFirmalar);

-- tUrunAsamalari tablosunda UrunID ve AsamaID için index
CREATE INDEX IX_tUrunAsamalari_UrunID_AsamaID ON tUrunAsamalari(UrunID, AsamaID);

-- tSatislar tablosunda UrunID için index
CREATE INDEX IX_tSatislar_UrunID ON tSatislar(UrunID);

-- tSevkiyatlar tablosunda SatisID için index
CREATE INDEX IX_tSevkiyatlar_SatisID ON tSevkiyatlar(SatisID);


-- 9. Günlük Karlarýn Listelenmesi
SELECT 
    s.SatisTarihi,
    u.UrunAdi,
    SUM(s.SatisAdedi * (u.SatisFiyati - u.UretimMaliyeti)) AS GunlukKar
FROM tSatislar s
JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY s.SatisTarihi, u.UrunAdi
ORDER BY s.SatisTarihi;

-- 10. Ortalama Aylýk Karýn Altýndaki Satýþlarýn Listelenmesi
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

-- 11. Zarar Edilen Ürünlerin Listelenmesi
SELECT 
    u.UrunAdi,
    (u.SatisFiyati - u.UretimMaliyeti) AS KarMiktari
FROM tUrunler u
WHERE u.SatisFiyati < u.UretimMaliyeti;

-- 12. En Çok Satýlan Ürünün Listelenmesi
SELECT TOP 1 
    u.UrunAdi,
    SUM(s.SatisAdedi) AS ToplamSatisAdedi
FROM tSatislar s
JOIN tUrunler u ON s.UrunID = u.ID
GROUP BY u.UrunAdi
ORDER BY SUM(s.SatisAdedi) DESC;

-- 13. Procedure'lar

-- 1. Günlük Karý Hesaplayan Procedure
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

-- Procedure'ün çalýþtýrýlmasý
EXEC spGunlukKar;

-- 2. Aylýk Ortalama Kar Altýndaki Satýþlarý Listeleyen Procedure
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

-- Procedure'ün çalýþtýrýlmasý
EXEC spAylikKarAltinda;

-- 3. Zarar Edilen Ürünleri Listeleyen Procedure
CREATE PROCEDURE spZararEdilenUrunler
AS
BEGIN
    SELECT 
        u.UrunAdi,
        (u.SatisFiyati - u.UretimMaliyeti) AS KarMiktari
    FROM tUrunler u
    WHERE u.SatisFiyati < u.UretimMaliyeti;
END;

-- Procedure'ün çalýþtýrýlmasý
EXEC spZararEdilenUrunler;

-- 4. En Çok Satýlan Ürünü Listeleyen Procedure
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

-- Procedure'ün çalýþtýrýlmasý
EXEC spEnCokSatilanUrun;

-- 5. Ürün Stok Durumunu Güncelleyen Procedure
CREATE PROCEDURE spStokGuncelle
    @UrunID INT,
    @YeniStok INT
AS
BEGIN
    UPDATE tUrunler
    SET StokAdedi = @YeniStok
    WHERE ID = @UrunID;
END;

-- Procedure'ün çalýþtýrýlmasý
EXEC spStokGuncelle @UrunID = 1, @YeniStok = 1500;
-- 7. Tablolardaki Deðerlerin/Kayýtlarýn Silinmesi
-- Silme iþlemleri tablolarýn iliþkilerine dikkat edilerek yapýlmalýdýr.

-- tSevkiyatlar tablosundaki tüm kayýtlarý silme
DELETE FROM tSevkiyatlar;

-- tSevkFirm tablosundaki tüm kayýtlarý silme
DELETE FROM tSevkFirm;

-- tSatislar tablosundaki tüm kayýtlarý silme (baðlý tSevkiyatlar kayýtlarý da silinir)
DELETE FROM tSatislar;

-- tUrunAsamalari tablosundaki tüm kayýtlarý silme
DELETE FROM tUrunAsamalari;

-- tSevkFirm tablosundaki tüm kayýtlarý silme
DELETE FROM tTedarikciler;

-- tUrunler tablosundaki tüm kayýtlarý silme (baðlý tSatislar ve tUrunAsamalari kayýtlarý da silinir)
DELETE FROM tUrunler;

-- tFirmalar tablosundaki tüm kayýtlarý silme (baðlý tUrunler kayýtlarý da silinir)
DELETE FROM tFirmalar;

-- tSevkFirm tablosundaki tüm kayýtlarý silme
DELETE FROM tUretimAsamalari;

-- tSevkFirm tablosundaki tüm kayýtlarý silme
DELETE FROM tOdemeBilgileri;
-- tKisiler tablosundaki tüm kayýtlarý silme (baðlý tOdemeBilgileri ve tUrunAsamalari kayýtlarý da silinir)
DELETE FROM tKisiler;
