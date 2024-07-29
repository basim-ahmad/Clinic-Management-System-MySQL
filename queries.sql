USE cms;

-- ---------------------- 01
SELECT COUNT(*) AS patient_count FROM patient;


-- ----------------------02
SELECT 
    CASE 
        WHEN SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) > SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) THEN 'More males'
        WHEN SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) < SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) THEN 'More females'
        ELSE 'Equal number of males and females'
    END AS gender_distribution
FROM patient;


-- -----------------------03
SELECT p.name
FROM patient p
JOIN appointment a ON p.patient_id = a.patient_id
WHERE p.name LIKE '%Lee%' AND a.notes LIKE '%follow-up%';


-- -----------------------04
SELECT m.name AS medication_name
FROM medication m
JOIN prescription p ON m.medication_id = p.medication_id
JOIN appointment a ON a.appointment_id = p.appointment_id
JOIN patient pat ON pat.patient_id = a.patient_id
WHERE pat.name LIKE '%Smith';


-- ---------------------------05
SELECT *
FROM doctor
WHERE doctor_id NOT IN (
    SELECT DISTINCT doctor_id
    FROM appointment
);


-- --------------------------06
SELECT d.*
FROM doctor d
JOIN appointment a ON d.doctor_id = a.doctor_id
JOIN prescription p ON a.appointment_id = p.appointment_id
JOIN medication m ON p.medication_id = m.medication_id
WHERE m.description LIKE '%pain%'
GROUP BY d.doctor_id
HAVING COUNT(*) > 2;


-- ------------------------07
SELECT DISTINCT p.*
FROM patient p
JOIN appointment a ON p.patient_id = a.patient_id
WHERE YEAR(a.appointment_date) = 2023 AND MONTH(a.appointment_date) = 6;



-- ------------------------08
SELECT d.doctor_id, d.name AS doctor_name, COUNT(*) AS num_appointments
FROM appointment a
JOIN doctor d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, DATE(a.appointment_date)
ORDER BY num_appointments DESC
LIMIT 1;



-- ------------------------09
SELECT DAYNAME(appointment_date) AS day_of_week, COUNT(*) AS total_appointments 
FROM appointment 
GROUP BY DAYNAME(appointment_date), DAYOFWEEK(appointment_date) 
ORDER BY DAYOFWEEK(appointment_date);

-- ------------------------10
SELECT DISTINCT 
    LEAST(p1.name, p2.name) AS patient1_name, 
    GREATEST(p1.name, p2.name) AS patient2_name, 
    MONTH(p1.dob) AS birth_month
FROM 
    patient p1
JOIN 
    patient p2 ON p1.patient_id < p2.patient_id
WHERE 
    MONTH(p1.dob) = MONTH(p2.dob)
ORDER BY 
    birth_month;


-- --------------------11
SELECT COUNT(*) AS num_patients_without_appointments
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;

-- OR

-- 11
SELECT p.name, COUNT(a.appointment_id) AS num_appointments
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
HAVING num_appointments = 0;




-- -----------------------------------12
SELECT m.medication_id, m.name
FROM medication m
LEFT JOIN prescription p ON m.medication_id = p.medication_id
WHERE p.prescription_id IS NULL;


-- ------------------------------------13
SELECT DISTINCT d.*
FROM doctor d
JOIN appointment a ON d.doctor_id = a.doctor_id
JOIN patient p ON a.patient_id = p.patient_id AND p.state_code = 'WA';





-- -----------------------------------14
SELECT name AS medication_name, COUNT(*) AS prescription_count
FROM medication
JOIN prescription ON medication.medication_id = prescription.medication_id
GROUP BY medication.medication_id
ORDER BY prescription_count DESC
LIMIT 1 OFFSET 1;


-- ------------------------------------15
SELECT DISTINCT p.*
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id AND a.status = 'cancelled'
WHERE a.appointment_id IS NULL;




-- ----------------------------------16
SELECT *
FROM (
    SELECT *
    FROM patient
    WHERE gender = 'female'
    ORDER BY dob ASC
    LIMIT 1
) AS youngest_female
UNION
SELECT *
FROM (
    SELECT *
    FROM patient
    WHERE gender = 'female'
    ORDER BY dob DESC
    LIMIT 1
) AS oldest_female;



-- -----------------------------17
SELECT m.medication_id, m.name
FROM medication m
JOIN prescription p ON m.medication_id = p.medication_id
GROUP BY m.medication_id, m.name
HAVING COUNT(*) = 1;



-- ------------------------------18
SELECT m.name AS medication_name, d.name AS doctor_name
FROM medication m
JOIN prescription p ON m.medication_id = p.medication_id
JOIN appointment a ON p.appointment_id = a.appointment_id
JOIN doctor d ON a.doctor_id = d.doctor_id
GROUP BY m.medication_id, m.name, d.doctor_id, d.name
HAVING COUNT(*) = 1;




-- ----------------------------------19
SELECT patient_id, COUNT(DISTINCT doctor_id) AS num_doctors
FROM appointment
GROUP BY patient_id
HAVING COUNT(DISTINCT doctor_id) >= 3;



















