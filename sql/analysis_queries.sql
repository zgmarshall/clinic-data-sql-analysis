-- Grand Total Visits Across All Clinics
SELECT
  COUNT(*) AS total_visits_all_clinics
FROM billing;

-- Count of Each Appointment Type by Clinic
SELECT
  cr.clinic_name,
  b.appointment_type,
  COUNT(*) AS appointment_count
FROM billing b
JOIN clinic_resources cr ON b.clinic_id = cr.clinic_id
GROUP BY cr.clinic_name, b.appointment_type
ORDER BY cr.clinic_name, appointment_count DESC;

-- Clinics with the Highest Number of Urgent and Follow-up Appointments
SELECT
  cr.clinic_name,
  b.appointment_type,
  COUNT(*) AS appointment_count
FROM billing b
JOIN clinic_resources cr ON b.clinic_id = cr.clinic_id
WHERE b.appointment_type IN ('Follow-up', 'Urgent')
GROUP BY cr.clinic_name, b.appointment_type
ORDER BY appointment_count DESC;

-- Average Total Bill by Appointment Type
SELECT
  appointment_type,
  ROUND(AVG(total_bill), 2) AS avg_total_bill
FROM billing
GROUP BY appointment_type
ORDER BY avg_total_bill DESC;

-- Average Out-of-Pocket by Appointment Type
SELECT 
  appointment_type, 
  ROUND(AVG(out_of_pocket_expenses), 2) AS avg_oop
FROM billing
GROUP BY appointment_type
ORDER BY avg_oop DESC;

-- Do Older Patients Have Higher Total Costs
SELECT
  CASE
    WHEN p.age < 20 THEN 'Under 20'
    WHEN p.age BETWEEN 20 AND 39 THEN '20–39'
    WHEN p.age BETWEEN 40 AND 59 THEN '40–59'
    ELSE '60+'
  END AS age_group,
  ROUND(AVG(b.total_bill), 2) AS avg_total_bill,
  ROUND(AVG(b.out_of_pocket_expenses), 2) AS avg_oop
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
GROUP BY age_group
ORDER BY age_group;

-- How Insurance Coverage Affects Out-of-Pocket Expenses
SELECT
  FLOOR(insurance_coverage_percentage / 10) * 10 AS coverage_percentage_range,
  ROUND(AVG(out_of_pocket_expenses), 2) AS avg_oop
FROM billing
GROUP BY coverage_percentage_range
ORDER BY coverage_percentage_range;

-- Total Billing Revenue Per Clinic Location
SELECT
  cr.clinic_name,
  COUNT(*) AS visit_count,
  SUM(b.total_bill) AS total_revenue
FROM billing b
JOIN (
  SELECT DISTINCT clinic_id, clinic_name
  FROM clinic_resources
) cr ON b.clinic_id = cr.clinic_id
GROUP BY cr.clinic_name
ORDER BY visit_count DESC;

-- Total Revenue Across All Clinics
SELECT SUM(total_bill) AS total_revenue_all_clinics
FROM billing;
