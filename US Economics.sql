SELECT

yc.Year,
real_infla_adj AS SP_500I_Value,
((real_infla_adj/LAG(real_infla_adj, 1) OVER (ORDER BY Year))-1)*100 AS Prct_Chnge_SP500I,
gdpc.gdp AS Real_GDP_Per_Capita_th,
gdp.rgdp AS Real_GDP,
rgdp - LAG(rgdp)
OVER (ORDER BY Year) AS Real_GDP_Change,
((rgdp/LAG(rgdp, 1) OVER (ORDER BY Year))-1)*100 AS Prct_Chnge_GDP,
rev AS Tax_Rev_b,
rev - LAG(rev)
OVER (ORDER BY Year) AS Tax_Rev_Diff,
((rev/LAG(rev, 1) OVER (ORDER BY Year))-1)*100 AS Prct_Chnge_Tax_Rev,
avg_value Money_In_Circ_b,
avg_value - LAG(avg_value)
OVER (ORDER BY Year) AS Money_Printed_billions,
((avg_value/LAG(avg_value, 1) OVER (ORDER BY Year ASC))-1)*100 AS Prct_Chnge_Printed,
cpi AS CPI,
fed_rate AS EFFR,
mortgage_rate AS Mortgage_Rate,
US_house_units,
mspus AS MSPUS_th,
(cpi/avg_value)*100 AS Purch_Power

FROM year_change yc

JOIN cpi_per_year c
ON c.year = yc.year

LEFT JOIN fed_rate_per_year fr
ON fr.year = yc.year

LEFT JOIN mortgage_rate_per_year mr
ON mr.year = yc.year

LEFT JOIN real_gdp_capita_per_year gdpc
ON gdpc.year = yc.year

LEFT JOIN real_gdp_year gdp
ON gdp.year = yc.year

LEFT JOIN sp_500_index1 sp
ON sp.year = yc.year

LEFT JOIN tax_rev1 tr
ON tr.year = yc.year

LEFT JOIN us_housing_units_m hu
ON hu.year = yc.year

LEFT JOIN msp_us msp
ON msp.year = yc.year

ORDER BY Year DESC;

-- CREATE TABLE cpi_per_year as 
SELECT
Year,
AVG(CPI)
FROM cpi_us
GROUP BY Year;

-- CREATE TABLE fed_rate_per_year
SELECT
Year,
AVG(fed_rate)
FROM fed_rate
GROUP BY year;

-- CREATE TABLE mortgage_rate_per_year
SELECT
Year,
AVG(mortgage_rate)
FROM mortgage_rates
GROUP BY year;

-- CREATE TABLE real_gdp_capita_per_year
SELECT
Year,
AVG(real_gdp_capita)
FROM real_gdp_per_capita
GROUP BY year;

-- CREATE TABLE real_gdp_year
SELECT
Year,
AVG(gdp)
FROM real_gdp
GROUP BY year;

-- CREATE TABLE sp_500_index1
SELECT
Year,
AVG(real_infla_adj)
FROM sp_500_index
GROUP BY year;

-- CREATE TABLE tax_rev1
SELECT
Year,
AVG(rev)
FROM tax_rev
GROUP BY year;

-- CREATE TABLE msp_us
SELECT
Year,
AVG(MSPUS)
FROM mspus
GROUP BY Year;
