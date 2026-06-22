-- ============================================================
-- LogFlux SaaS — Dados fictícios para conta DEMO  (VERSÃO PRONTA)
-- NÃO precisa trocar nenhum ID: o script acha o user_id sozinho
-- pelo e-mail demo@logflux.com.br.
--
-- PRÉ-REQUISITO: criar o usuário demo@logflux.com.br em
-- Authentication → Users → Add user (marque "Auto Confirm User").
-- Depois é só colar TUDO isto no SQL Editor e clicar Run.
-- ============================================================

-- 1) Cadastro do assinante DEMO (status = ativo)
INSERT INTO public.logflux_assinantes (user_id, empresa, email, status)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'Transportadora Demo · Logflux', 'demo@logflux.com.br', 'ativo'
)
ON CONFLICT (user_id) DO UPDATE SET status = 'ativo';

-- 2) FROTA FICTÍCIA (5 carretas silo)
INSERT INTO public.logflux_dados (user_id, chave, dados)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'frota',
  '[
    {"placa":"AAA-0001","mot":"Carlos Silva","status":"Disponível","lat":-25.4284,"lng":-49.2733,"hist":[]},
    {"placa":"BBB-0002","mot":"João Santos","status":"Em viagem","lat":-25.3244,"lng":-49.1631,"hist":[]},
    {"placa":"CCC-0003","mot":"Pedro Oliveira","status":"Entregue","lat":-25.4961,"lng":-49.1691,"hist":[]},
    {"placa":"DDD-0004","mot":"Marcos Ferreira","status":"Aguard. descarga","lat":-25.3900,"lng":-49.2200,"hist":[]},
    {"placa":"EEE-0005","mot":"Ricardo Costa","status":"Em manutenção","lat":-25.4400,"lng":-49.2100,"hist":[]}
  ]'::jsonb
)
ON CONFLICT (user_id, chave) DO UPDATE SET dados = EXCLUDED.dados;

-- 3) MOTORISTAS FICTÍCIOS
INSERT INTO public.logflux_dados (user_id, chave, dados)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'motoristas',
  '[
    {"nome":"Carlos Silva","tel":"41 99123-4567","placa":"AAA-0001","status":"ativo","doc":"12345678901"},
    {"nome":"João Santos","tel":"41 99234-5678","placa":"BBB-0002","status":"ativo","doc":"12345678902"},
    {"nome":"Pedro Oliveira","tel":"41 99345-6789","placa":"CCC-0003","status":"ativo","doc":"12345678903"},
    {"nome":"Marcos Ferreira","tel":"41 99456-7890","placa":"DDD-0004","status":"ativo","doc":"12345678904"},
    {"nome":"Ricardo Costa","tel":"41 99567-8901","placa":"EEE-0005","status":"ativo","doc":"12345678905"}
  ]'::jsonb
)
ON CONFLICT (user_id, chave) DO UPDATE SET dados = EXCLUDED.dados;

-- 4) PEDIDOS FICTÍCIOS (20 pedidos com números Votorantim)
INSERT INTO public.logflux_dados (user_id, chave, dados)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'pedidos',
  '[
    {"id":"9051000001","de":"2026-06-21","ate":"2026-06-21","mot":"Carlos Silva","st":"Entregue","cliente":"Supermix Demo","t":30,"nf":"NF-001","de2":"Fábrica SP","ate2":"Obra São Paulo","obs":"","anexos":[]},
    {"id":"9051000002","de":"2026-06-20","ate":"2026-06-20","mot":"João Santos","st":"Entregue","cliente":"Polimix Demo","t":28,"nf":"NF-002","de2":"Fábrica SP","ate2":"Obra Guarulhos","obs":"","anexos":[]},
    {"id":"9051000003","de":"2026-06-21","ate":"2026-06-22","mot":"João Santos","st":"Em viagem","cliente":"Concreteira Exemplo","t":32,"nf":"NF-003","de2":"Fábrica SP","ate2":"Concreto do Vale","obs":"Saída 14h30","anexos":[]},
    {"id":"9051000004","de":"2026-06-21","ate":"2026-06-21","mot":"Pedro Oliveira","st":"Aguard. descarga","cliente":"Supermix Demo","t":29,"nf":"NF-004","de2":"Fábrica SP","ate2":"Obra Campinas","obs":"Chegou 9h","anexos":[]},
    {"id":"9051000005","de":"2026-06-19","ate":"2026-06-19","mot":"Marcos Ferreira","st":"Entregue","cliente":"Polimix Demo","t":31,"nf":"NF-005","de2":"Fábrica SP","ate2":"Obra Jundiaí","obs":"","anexos":[]},
    {"id":"9051000006","de":"2026-06-21","ate":"2026-06-21","mot":"Carlos Silva","st":"Programado","cliente":"Concreteira Exemplo","t":27,"nf":"NF-006","de2":"Fábrica SP","ate2":"Concreto Itu","obs":"Para amanhã","anexos":[]},
    {"id":"9051000007","de":"2026-06-20","ate":"2026-06-20","mot":"Ricardo Costa","st":"Entregue","cliente":"Supermix Demo","t":30,"nf":"NF-007","de2":"Fábrica SP","ate2":"Obra Sorocaba","obs":"","anexos":[]},
    {"id":"9051000008","de":"2026-06-21","ate":"2026-06-22","mot":"Carlos Silva","st":"Programado","cliente":"Polimix Demo","t":28,"nf":"NF-008","de2":"Fábrica SP","ate2":"Obra Piracicaba","obs":"Saída 8h","anexos":[]},
    {"id":"9051000009","de":"2026-06-19","ate":"2026-06-19","mot":"João Santos","st":"Entregue","cliente":"Concreteira Exemplo","t":33,"nf":"NF-009","de2":"Fábrica SP","ate2":"Concreto Regional","obs":"","anexos":[]},
    {"id":"9051000010","de":"2026-06-20","ate":"2026-06-20","mot":"Pedro Oliveira","st":"Entregue","cliente":"Supermix Demo","t":26,"nf":"NF-010","de2":"Fábrica SP","ate2":"Obra Santo André","obs":"","anexos":[]},
    {"id":"9051000011","de":"2026-06-18","ate":"2026-06-18","mot":"Marcos Ferreira","st":"Entregue","cliente":"Polimix Demo","t":29,"nf":"NF-011","de2":"Fábrica SP","ate2":"Obra Mauá","obs":"","anexos":[]},
    {"id":"9051000012","de":"2026-06-21","ate":"2026-06-21","mot":"Ricardo Costa","st":"Programado","cliente":"Concreteira Exemplo","t":31,"nf":"NF-012","de2":"Fábrica SP","ate2":"Concreto Premium","obs":"Confirmado","anexos":[]},
    {"id":"9051000013","de":"2026-06-17","ate":"2026-06-17","mot":"Carlos Silva","st":"Entregue","cliente":"Supermix Demo","t":30,"nf":"NF-013","de2":"Fábrica SP","ate2":"Obra SBC","obs":"","anexos":[]},
    {"id":"9051000014","de":"2026-06-21","ate":"2026-06-21","mot":"João Santos","st":"Programado","cliente":"Polimix Demo","t":28,"nf":"NF-014","de2":"Fábrica SP","ate2":"Obra Diadema","obs":"Saída 10h","anexos":[]},
    {"id":"9051000015","de":"2026-06-19","ate":"2026-06-19","mot":"Pedro Oliveira","st":"Entregue","cliente":"Concreteira Exemplo","t":32,"nf":"NF-015","de2":"Fábrica SP","ate2":"Concreto Zona Leste","obs":"","anexos":[]},
    {"id":"9051000016","de":"2026-06-16","ate":"2026-06-16","mot":"Marcos Ferreira","st":"Entregue","cliente":"Supermix Demo","t":29,"nf":"NF-016","de2":"Fábrica SP","ate2":"Obra Itaquaquecetuba","obs":"","anexos":[]},
    {"id":"9051000017","de":"2026-06-20","ate":"2026-06-20","mot":"Ricardo Costa","st":"Entregue","cliente":"Polimix Demo","t":30,"nf":"NF-017","de2":"Fábrica SP","ate2":"Obra Arujá","obs":"","anexos":[]},
    {"id":"9051000018","de":"2026-06-21","ate":"2026-06-21","mot":"Carlos Silva","st":"Programado","cliente":"Concreteira Exemplo","t":27,"nf":"NF-018","de2":"Fábrica SP","ate2":"Concreto Industrial","obs":"Confirmado","anexos":[]},
    {"id":"9051000019","de":"2026-06-18","ate":"2026-06-18","mot":"João Santos","st":"Entregue","cliente":"Supermix Demo","t":31,"nf":"NF-019","de2":"Fábrica SP","ate2":"Obra Osasco","obs":"","anexos":[]},
    {"id":"9051000020","de":"2026-06-21","ate":"2026-06-23","mot":"Pedro Oliveira","st":"Programado","cliente":"Polimix Demo","t":35,"nf":"NF-020","de2":"Fábrica SP","ate2":"Obra Barueri","obs":"Saída amanhã cedo","anexos":[]}
  ]'::jsonb
)
ON CONFLICT (user_id, chave) DO UPDATE SET dados = EXCLUDED.dados;

-- 5) ABASTECIMENTOS FICTÍCIOS
INSERT INTO public.logflux_dados (user_id, chave, dados)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'abastecimento',
  '[
    {"data":"2026-06-21","hora":"08:30","motorista":"Carlos Silva","placa":"AAA-0001","posto":"ESSO","destino":"Obra SP","nf":"NF-001","valor":"850,00","status":"Enviada","completar":false},
    {"data":"2026-06-21","hora":"09:15","motorista":"João Santos","placa":"BBB-0002","posto":"BR","destino":"Guarulhos","nf":"NF-003","valor":"920,00","status":"Enviada","completar":false},
    {"data":"2026-06-20","hora":"07:45","motorista":"Pedro Oliveira","placa":"CCC-0003","posto":"PETROBRAS","destino":"Campinas","nf":"NF-004","valor":"880,00","status":"Confirmado","completar":true},
    {"data":"2026-06-20","hora":"06:30","motorista":"Marcos Ferreira","placa":"DDD-0004","posto":"ESSO","destino":"Jundiaí","nf":"NF-005","valor":"900,00","status":"Confirmado","completar":false},
    {"data":"2026-06-21","hora":"08:00","motorista":"Ricardo Costa","placa":"EEE-0005","posto":"BR","destino":"Sorocaba","nf":"NF-007","valor":"870,00","status":"Enviada","completar":true}
  ]'::jsonb
)
ON CONFLICT (user_id, chave) DO UPDATE SET dados = EXCLUDED.dados;

-- 6) HISTÓRICO DE AÇÕES
INSERT INTO public.logflux_dados (user_id, chave, dados)
VALUES (
  (SELECT id FROM auth.users WHERE email='demo@logflux.com.br'),
  'acoes',
  '[
    {"hora":"21/06/2026 10:45:00","acao":"Sistema demo criado para demonstração do Logflux"},
    {"hora":"21/06/2026 10:30:00","acao":"Frota inicializada com 5 carretas silo"},
    {"hora":"21/06/2026 10:15:00","acao":"20 pedidos fictícios carregados - números compatíveis com Votorantim"},
    {"hora":"21/06/2026 10:00:00","acao":"Motoristas cadastrados com dados realistas"},
    {"hora":"21/06/2026 09:45:00","acao":"Abastecimentos registrados para os últimos 2 dias"}
  ]'::jsonb
)
ON CONFLICT (user_id, chave) DO UPDATE SET dados = EXCLUDED.dados;

-- ============================================================
-- Conferir se deu certo:
--   SELECT empresa, email, status FROM public.logflux_assinantes
--   WHERE email='demo@logflux.com.br';
-- Deve aparecer status = ativo.
-- ============================================================
