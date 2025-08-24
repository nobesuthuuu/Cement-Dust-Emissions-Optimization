-- CEMENT PLANT DUST EMISSIONS OPTIMIZATION PROJECT --

CREATE DATABASE cement_plant_data;
USE cement_plant_data;

CREATE TABLE plant_data (
id  INT AUTO_INCREMENT PRIMARY KEY,
dust_concentration_mg_m3 FLOAT,
inlet_gas_flow_rate_m3h FLOAT,
temperature_degrees_C FLOAT,
differential_pressure_mbar FLOAT,
residue_percent FLOAT
);

-- testing whether table is working properly
SELECT *
FROM plant_data LIMIT 10;
-- ------------------------------------------

-- basic summary
SELECT 
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust,
  ROUND(AVG(inlet_gas_flow_rate_m3h), 2) AS avg_flow,
  ROUND(AVG(temperature_degrees_C), 2) AS avg_temp,
  ROUND(AVG(differential_pressure_mbar), 2) AS avg_dp,
  ROUND(AVG(residue_percent), 2) AS avg_residue
FROM plant_data;


-- checking for outliers and high emission flags
SELECT * 
FROM plant_data
WHERE dust_concentration_mg_m3 > 50
ORDER BY dust_concentration_mg_m3 DESC
;

-- dust concentration and pressure correlations
SELECT 
  ROUND(differential_pressure_mbar, 1) AS dp_bin,
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY dp_bin
ORDER BY dp_bin;

-- dust concentration and inlet gas flow rate correlation
SELECT
ROUND(inlet_gas_flow_rate_m3h, 0) AS gas_flow,
ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY gas_flow
ORDER BY gas_flow;

--  dust concentration and temperature correlation
SELECT 
  FLOOR(temperature_degrees_C / 5) * 5 AS temp_range_start,
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY temp_range_start
ORDER BY temp_range_start;

-- dust concentration and residue correlation
SELECT 
  ROUND(residue_percent, 0) AS residue_group,
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY residue_group
ORDER BY residue_group;

-- multivariate correlation
SELECT 
  ROUND(temperature_degrees_C, 0) AS temp,
  ROUND(differential_pressure_mbar, 1) AS dp,
  ROUND(residue_percent, 0) AS residue,
  ROUND(inlet_gas_flow_rate_m3h, 0) AS gas_flow,
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY temp, dp, residue, gas_flow
ORDER BY avg_dust DESC;

-- creating a view for export later
CREATE VIEW cement_plant_dust_summary_export_view AS
SELECT 
  ROUND(temperature_degrees_C, 0) AS temp,
  ROUND(differential_pressure_mbar, 1) AS dp,
  ROUND(residue_percent, 0) AS residue,
  ROUND(inlet_gas_flow_rate_m3h, 0) AS gas_flow,
  ROUND(AVG(dust_concentration_mg_m3), 2) AS avg_dust
FROM plant_data
GROUP BY temp, dp, residue, gas_flow
ORDER BY avg_dust DESC;

-- exporting the view to prepare for visualization
SELECT *
FROM cement_plant_dust_summary_export_view;



