-- KIMIA FARMA ANALYTICAL TABLE
-- Project: Rakamin_KF_Analytics
-- Dataset: kimia_farma
-- Author : Muhammad Zainur Rahman Afandi

--Membuat tabel analisa
CREATE OR REPLACE TABLE `Rakamin_KF_Analytics.tabel_analisa` AS
SELECT
t.transaction_id,
t.date,
kc.branch_id,
kc.branch_name,
kc.kota,
kc.provinsi,
kc.rating as rating_cabang,
t.customer_name,
t.product_id,
p.product_name,
p.price as actual_price,
t.discount_percentage,
--Membuat persentase gross laba berdasarkan kondisi
CASE
  WHEN p.price <= 50000 THEN 0.10
  WHEN p.price <= 100000 THEN 0.15
  WHEN p.price <= 300000 THEN 0.20
  WHEN p.price <= 500000 THEN 0.25
ELSE 0.30
END AS persentase_gross_laba,

--Membuat perhitungan harga Setelah Diskon
ROUND(p.price*(1-t.discount_percentage), 0) AS nett_sales,
--Mencari laba bersih untuk setiap transaksi
ROUND(p.price*(1-t.discount_percentage)*
CASE
  WHEN p.price <= 50000 THEN 0.10
  WHEN p.price <= 100000 THEN 0.15
  WHEN p.price <= 300000 THEN 0.20
  WHEN p.price <= 500000 THEN 0.25
ELSE 0.30
END, 2) AS nett_profit,
t.rating AS rating_transaksi
from `Rakamin_KF_Analytics.transaction` t
--Melakukan join dengan tabel kantor_cabang
LEFT JOIN `Rakamin_KF_Analytics.kantor_cabang` kc
ON t.branch_id=kc.branch_id
--Melakukan join dengan tabel product
LEFT JOIN `Rakamin_KF_Analytics.product` p
ON t.product_id=p.product_id
--Mengurutkan berdasarkan tanggal dari tanggal yang lebih awal hingga paling baru
ORDER BY t.date ASC;