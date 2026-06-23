-- ============================================
-- SCRIPT: Criar Conta Demo SiloFlux
-- ============================================
-- Instruções:
-- 1. Acesse: https://app.supabase.com
-- 2. Vá ao projeto: cizpxkjzvfyewnlqhjzf
-- 3. Abra SQL Editor
-- 4. Cole este script inteiro
-- 5. Execute (Ctrl+Enter ou botão RUN)
-- ============================================

BEGIN;

-- 1. Criar usuário demo (via auth)
-- NOTA: Isso precisa ser feito via UI do Supabase
-- Menu: Authentication > Users > Add User
-- Email: demo@siloflux.com.br
-- Password: Siloflux2026
-- Auto Confirm: SIM

-- 2. Inserir empresa demo
INSERT INTO public.empresas (
  nome,
  email,
  plano,
  status,
  criado_em
) VALUES (
  'Demo Transportes',
  'demo@siloflux.com.br',
  'premium',
  'ativo',
  NOW()
) ON CONFLICT DO NOTHING;

-- 3. Inserir motoristas demo (3 carretas silo)
INSERT INTO public.motoristas (
  empresa_id,
  nome,
  categoria,
  placa_cavalo,
  placa_carreta,
  whatsapp,
  laudo_anual_vence,
  laudo_trimestral_vence,
  criado_em
)
SELECT
  e.id as empresa_id,
  motorista,
  'FROTA',
  cavalo,
  carreta,
  wa,
  laudo_anual,
  laudo_trimestral,
  NOW()
FROM (
  VALUES
  ('MARCOS SILVA', 'ABC-1234', 'SLO-0001', '+55 41 99111-1111', '2026-08-15'::date, '2026-07-20'::date),
  ('RODRIGO COSTA', 'ABC-5678', 'SLO-0002', '+55 41 99222-2222', '2026-09-10'::date, '2026-07-15'::date),
  ('FELIPE SANTOS', 'ABC-9999', 'SLO-0003', '+55 41 99333-3333', '2026-07-25'::date, '2026-08-05'::date)
) AS motoristas(motorista, cavalo, carreta, wa, laudo_anual, laudo_trimestral),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- 4. Inserir fábricas/origens
INSERT INTO public.fabrica (
  empresa_id,
  nome,
  criado_em
)
SELECT
  e.id as empresa_id,
  fabrica,
  NOW()
FROM (
  VALUES
  ('Fábrica São Paulo'),
  ('Fábrica Minas Gerais'),
  ('Fábrica Paraná')
) AS fabricas(fabrica),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- 5. Inserir clientes/destinos
INSERT INTO public.cliente (
  empresa_id,
  nome,
  criado_em
)
SELECT
  e.id as empresa_id,
  cliente,
  NOW()
FROM (
  VALUES
  ('Construtora ABC - São Paulo'),
  ('Empreendimento XYZ - Minas'),
  ('Obra JKL - Paraná'),
  ('Construção DEF - Rio'),
  ('Projeto MNO - Brasília')
) AS clientes(cliente),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- 6. Inserir pedidos fictícios (10+)
INSERT INTO public.pedidos (
  empresa_id,
  numero_pedido,
  motorista_id,
  fabrica_id,
  cliente_id,
  qtd_ton,
  programado_de,
  programado_ate,
  valor_frete,
  status,
  criado_em
)
SELECT
  e.id as empresa_id,
  'PED-' || LPAD((ROW_NUMBER() OVER (ORDER BY i))::text, 6, '0') as numero_pedido,
  m.id as motorista_id,
  f.id as fabrica_id,
  c.id as cliente_id,
  30.0 + (ROW_NUMBER() OVER (ORDER BY i) * 5) as qtd_ton,
  (CURRENT_DATE + (ROW_NUMBER() OVER (ORDER BY i) - 1))::date as programado_de,
  (CURRENT_DATE + (ROW_NUMBER() OVER (ORDER BY i) + 2))::date as programado_ate,
  4500.00 + (ROW_NUMBER() OVER (ORDER BY i) * 250) as valor_frete,
  CASE
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 3 THEN 'VIAGEM'
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 6 THEN 'ENTREGUE'
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 8 THEN 'CARREG'
    ELSE 'PROG'
  END as status,
  NOW() - INTERVAL '1 day' * (ROW_NUMBER() OVER (ORDER BY i)) as criado_em
FROM
  GENERATE_SERIES(1, 12) AS i,
  public.empresas e
  CROSS JOIN public.motoristas m ON m.empresa_id = e.id
  CROSS JOIN public.fabrica f ON f.empresa_id = e.id
  CROSS JOIN public.cliente c ON c.empresa_id = e.id
WHERE
  e.nome = 'Demo Transportes'
  AND m.nome = 'MARCOS SILVA'
  AND f.nome = 'Fábrica São Paulo'
  AND c.nome = 'Construtora ABC - São Paulo'
ON CONFLICT DO NOTHING;

-- 7. Inserir alguns laudos vencendo
INSERT INTO public.motoristas_laudos (
  motorista_id,
  tipo_laudo,
  vencimento,
  criado_em
)
SELECT
  m.id as motorista_id,
  'ANUAL' as tipo_laudo,
  (CURRENT_DATE + INTERVAL '15 days')::date as vencimento,
  NOW()
FROM public.motoristas m
CROSS JOIN public.empresas e ON m.empresa_id = e.id
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

COMMIT;

-- ============================================
-- Resultado esperado:
-- ✓ Empresa: Demo Transportes
-- ✓ Motoristas: 3 (Marcos, Rodrigo, Felipe)
-- ✓ Carretas: 3 (SLO-0001, SLO-0002, SLO-0003)
-- ✓ Pedidos: 12+ em diferentes status
-- ✓ Laudos: Alguns vencendo em 15 dias
-- ============================================
