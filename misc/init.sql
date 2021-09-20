CREATE SCHEMA demodata;

CREATE TABLE public.formation (
	id int8 NOT NULL,
	nom varchar NULL,
	salle varchar NULL
);

INSERT INTO public.formation
(id, nom, salle)
VALUES(1, 'formation1', 'salle1');

INSERT INTO public.formation
(id, nom, salle)
VALUES(2, 'formation2', 'salle2');