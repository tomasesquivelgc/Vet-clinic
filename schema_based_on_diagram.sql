
CREATE TABLE public.patients (
  id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  date_of_birth DATE
);

CREATE TABLE public.medical_histories (
  id INTEGER PRIMARY KEY,
  admitted_at TIMESTAMP,
  patient_id INTEGER REFERENCES patients(id),
  status VARCHAR(100)
);

CREATE TAble public.treatments (
   id INTEGER PRIMARY KEY,
   type VARCHAR,
   name VARCHAR,
);

CREATE TAble public.invoice_items (
   id INTEGER PRIMARY KEY,
   unit_price DECIMAL,
   quntity INTEGER,
   total_price DECIMAL,
   invoice_id INTEGER REFERENCES invoices(id),
   treatment_id INTEGER REFERENCES treatments(id),
);

CREATE TABLE public.invoices (
  id INTEGER PRIMARY KEY,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history__id INTEGER REFERENCES medical_histories(id),
);

-- many to many relationship table between medical_histories and treatments

CREATE TABLE public.treatment_histories (
  id INTEGER PRIMARY KEY,
  medical_history__id INTEGER REFERENCES medical_histories(id),
  treatment_id INTEGER REFERENCES treatments(id),
);

CREATE INDEX ON medical_histories (patient_id);
CREATE INDEX ON invoices (medical_history_id);
CREATE INDEX ON invoice_items (invoice_id);
CREATE INDEX ON invoice_items (treatment_id);
CREATE INDEX ON treatment_histories (medical_history__id);
CREATE INDEX ON treatment_histories (treatment_id);