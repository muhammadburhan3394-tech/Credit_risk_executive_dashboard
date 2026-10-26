/* =================================================================================
PROJECT TITLE   : Executive Credit Risk Analysis (Lending Club)
AUTHOR          : Muhammad Burhanudin
DATE            : Oktober 2026
RDBMS           : MySQL 8.0
DATASET VOLUME  : 2.26 Million Rows

BUSINESS OBJECTIVE:
Mengeksekusi proses ETL (Extract, Transform, Load), pembersihan data (Data Cleaning),
dan Exploratory Data Analysis (EDA) untuk mengidentifikasi korelasi antara tingkat 
pendapatan (annual_inc), beban suku bunga (int_rate), dan risiko gagal bayar 
(loan_status) guna mendukung strategi Risk-Based Pricing.

KEY SQL TECHNIQUES APPLIED:
1. Bulk Data Ingestion (LOAD DATA INFILE)
2. Data Cleaning & Type Casting (ALTER TABLE, Handling Missing Values)
3. Data Aggregation & Profiling (GROUP BY, HAVING, MIN/MAX/AVG)
4. Conditional Logic for Risk Segmentation (CASE WHEN)
================================================================================= */

-- [DI BAWAH INI ADALAH KODE SQL ANDA]

-- 1. Membuat Staging Table
-- CREATE TABLE tabel_pinjaman (...

-- 2. Import Data 1.16 GB
-- LOAD DATA INFILE ...

-- 3. Data Cleaning
-- DELETE FROM tabel_pinjaman WHERE ...

-- 4. Exploratory Data Analysis (EDA)
-- SELECT CASE WHEN ...


CREATE DATABASE risk_management;
USE risk_management;

CREATE table tabel_pinjaman (
	int_rate FLOAT,
    annual_inc FLOAT,
    loan_status VARCHAR(50),
    purpose VARCHAR(50)
);
    
SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/mini_loan.csv"
INTO TABLE tabel_pinjaman
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Karena proses load data eror di tengah jalan, maka kita hapus dulu sebagian data yang sudah masuk

TRUNCATE TABLE tabel_pinjaman;         #----> me reset isi tabel yang sudah terlanjur masuk setengah jalan

# Setelah di reset, kita rubah semua jenis kolomnya menjadi VARCHAR dulu agar bisa terupload semua ke table

ALTER TABLE tabel_pinjaman MODIFY int_rate VARCHAR(255);
ALTER TABLE tabel_pinjaman MODIFY annual_inc VARCHAR(255);
ALTER TABLE tabel_pinjaman MODIFY loan_status VARCHAR(255);      
ALTER TABLE tabel_pinjaman MODIFY purpose VARCHAR(255);          

# Kita ulangi proses load data nya

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/mini_loan.csv"
INTO TABLE tabel_pinjaman
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS; 

# Cek total data yang berhasil terupload

SELECT COUNT(*) FROM tabel_pinjaman;

# PROSES PEMBERSIHAN DATA (Data Cleansing)

SELECT * FROM tabel_pinjaman
WHERE annual_inc = '' OR annual_inc IS NULL LIMIT 10;

SELECT COUNT(*) AS total_data_kosong
FROM tabel_pinjaman
WHERE annual_inc = '' OR annual_inc IS NULL;

# Hapus data yang kosong dari tabel karena jumlahnya hanya 4 (di bawah 1%)

DELETE FROM tabel_pinjaman
WHERE annual_inc = '' OR annual_inc IS NULL;

# Rubah kembali tipe data annual_inc dan int_rate menjadi Float

ALTER TABLE tabel_pinjaman MODIFY int_rate float;
ALTER TABLE tabel_pinjaman MODIFY annual_inc float;

## Agregasi Dasar ## --> TINGKAT 1
# "Berapa rata-rata gaji tahunan (annual_inc) nasabah kita, berapa suku bunga (int_rate) tertinggi yang pernah diberikan, dan berapa suku bunga terendahnya?"

SELECT 
	ROUND(AVG(annual_inc),2) as rata_rata_gaji,
    MAX(int_rate) as suku_bunga_tertinggi,
    MIN(int_rate) as suku_bunga_terendah
FROM tabel_pinjaman;

## Segmentasi Data (Group by)  ## --> TINGKAT 2
# "Apakah nasabah yang gagal bayar (Charged Off) memiliki rata-rata gaji yang lebih rendah dan dikenakan bunga yang lebih tinggi dibandingkan nasabah yang pelunasannya lancar (Fully Paid)?"

SELECT 
	loan_status,
    COUNT(*) AS total_nasabah,
    ROUND(AVG(annual_inc),2) AS rata_rata_gaji,
    ROUND(AVG(int_rate),2) AS rata_rata_bunga
FROM tabel_pinjaman
GROUP BY loan_status
ORDER BY total_nasabah DESC;

## Konsep Tingkat Lanjut SQL: Pengelompokan Kustom (CASE WHEN) ## --> TINGKAT 3
# Berapa total Kredit Bagus (Good Loan) vs Kredit Bermasalah (Bad Loan)?  --> Pengelompokkan dari 9 loan_status menjadi 2 kategori loan_status

SELECT
	CASE
		WHEN loan_status IN ('Fully Paid', 'Current') THEN 'Good Loan'
        ELSE 'Bad Loan'
	END as kategori_resiko,
    COUNT(*) AS total_nasabah,
    ROUND(AVG(annual_inc),2) AS rata_rata_gaji,
    ROUND(AVG(int_rate),2) AS rata_rata_bunga
FROM tabel_pinjaman
GROUP BY kategori_resiko
ORDER BY total_nasabah DESC;

SELECT
	CASE
		WHEN loan_status IN ('Fully Paid', 'Current') THEN 'Good Loan'
        ELSE 'Bad Loan'
	END as kategori_resiko,
    COUNT(*) AS total_nasabah,
    ROUND(AVG(annual_inc),2) AS rata_rata_gaji,
    ROUND(AVG(int_rate),2) AS rata_rata_bunga
FROM tabel_pinjaman
GROUP BY kategori_resiko
HAVING total_nasabah > 10000
ORDER BY total_nasabah DESC;







