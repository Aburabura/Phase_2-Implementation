# Phase 2 Implementation

## 📌 Project Overview
This project is a relational database system designed to manage a structured dataset for our application. It includes schema design, data seeding, triggers, views, and example queries to demonstrate functionality and integrity.

---

## 🗄️ Database Schema

The database is built using a relational model with normalized tables to reduce redundancy and improve efficiency.

### Main Tables:
- **Patients**
  - Stores patient information such as name, contact details, and demographics.
  
- **Staff**
  - Stores staff details including roles and contact information.

- **Appointments**
  - Links patients and staff with scheduled appointments.

- **Additional Supporting Tables**
  - Used for extended functionality depending on project requirements (e.g., services, billing, etc.).

---

## ⚙️ SQL Files

The project is structured into modular SQL scripts executed in order:

1. `001_init.sql`
   - Creates database schema and tables.

2. `002_seed_data.sql`
   - Inserts initial sample data.

3. `003_triggers.sql`
   - Defines triggers for automation and data integrity.

4. `004_views.sql`
   - Creates views for simplified querying.

5. `005_queries.sql`
   - Contains example queries for testing and demonstration.

---

## 👁️ Views

### Appointment Summary View
A view that combines patient and staff information for easier reporting.

```sql
CREATE OR REPLACE VIEW "Appointment_Summary" AS
SELECT 
    a."appointment_id",
    p."first_name" || ' ' || p."last_name" AS patient_name,
    s."first_name" || ' ' || s."last_name" AS staff_name,
    a."appointment_date",
    a."status"
FROM "Appointments" a
JOIN "Patients" p ON a."patient_id" = p."patient_id"
JOIN "Staff" s ON a."staff_id" = s."staff_id";
