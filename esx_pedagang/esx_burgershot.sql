INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_pedagang', 'pedagang', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_pedagang', 'pedagang', 1),
  ('society_pedagang_fridge', 'pedagang(frigorifico)', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_pedagang', 'pedagang', 1)
;

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  ('pedagang', 'Pedagang', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('pedagang', 0, 'recluta', 'Practicante', 800, '{}', '{}'),
  ('pedagang', 1, 'novato', 'Ayudante de cocina', 800, '{}', '{}'),
  ('pedagang', 2, 'chef', 'Chef', 800, '{}', '{}'),
  ('pedagang', 3, 'viceboss', 'Sub-Gerente', 800, '{}', '{}'),
  ('pedagang', 4, 'boss', 'Gerente', 800, '{}', '{}')
;