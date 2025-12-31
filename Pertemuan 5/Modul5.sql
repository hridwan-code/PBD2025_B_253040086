SELECT * FROM Dosen;
SELECT * FROM MataKuliah;

SELECT NamaDosen FROM Dosen;

SELECT NamaDosen FROM Dosen 
WHERE Prodi = 'Informatika'

SELECT D.NamaDosen
From Dosen D
INNER JOIN MataKuliah MK ON D.DosenID = MK.DosenID
WHERE MK.NamaMK = 'Basis Data'

SELECT NamaDosen
FROM Dosen
WHERE DosenID = (
	SELECT DosenID 
	FROM MataKuliah
	WHERE NamaMK = 'Basis Data'
)

SELECT NamaMK
FROM MataKuliah
WHERE DosenID = (
	SELECT DosenID 
	FROM Dosen
	WHERE NamaDosen = 'Agus Hidayat, M.Kom'
)

SELECT * FROM Nilai;
SELECT * FROM Mahasiswa;
SELECT * FROM MataKuliah;


SELECT NamaMahasiswa
FROM Mahasiswa
WHERE MahasiswaID IN (
	SELECT MahasiswaID 
	FROM Nilai
	WHERE NilaiAkhir= 'A'
)

SELECT NamaMK
FROM MataKuliah
WHERE MataKuliahId IN (
	SELECT MataKuliahID 
	FROM Nilai
	WHERE NilaiAkhir= 'A'
)

SELECT * FROM Mahasiswa
SELECT * FROM MataKuliah
SELECT * FROM KRS

SELECT Prodi, TotalMhs
FROM (
	SELECT Prodi, COUNT(*) AS TotalMhs
	FROM Mahasiswa
	GROUP BY Prodi
) AS HitungMhs
WHERE TotalMhs > 2;


WITH MhsIF AS (
	SELECT *
	FROM Mahasiswa
	WHERE Prodi = 'Informatika'
)
SELECT * FROM MhsIF

WITH MhsProdi AS (
	SELECT Prodi, COUNT(*) TotalMahasiswa 
	FROM Mahasiswa
	GROUP BY Prodi
)
SELECT * FROM MhsProdi
WHERE TotalMahasiswa > 2


SELECT * FROM Ruangan

SELECT NamaDosen FROM Dosen
UNION
Select NamaMahasiswa From Mahasiswa;

SELECT Kapasitas, KodeRuangan From Ruangan Where Kapasitas > 40
UNION
SELECT Kapasitas, KodeRuangan From Ruangan Where Kapasitas < 40;

SELECT MahasiswaID FROM KRS
INTERSECT
SELECT MahasiswaID FROM Nilai;

SELECT MataKuliahID FROM MataKuliah
INTERSECT
SELECT MatakuliahID FROM Nilai;










