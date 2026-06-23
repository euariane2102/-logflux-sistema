# ⚡ Criar Conta Demo SiloFlux — Versão Rápida

## 3 Passos Simples (5 minutos)

### Passo 1: Criar usuário em Auth (1 minuto)

1. Abra: https://app.supabase.com
2. Selecione projeto: **cizpxkjzvfyewnlqhjzf**
3. Menu esquerdo: **Authentication** → **Users**
4. Botão azul: **Add User**
5. Preencha:
   - **Email**: `demo@siloflux.com.br`
   - **Password**: `Siloflux2026`
   - ✅ **Auto Confirm Email** (marque)
6. Clique: **Save**

**Pronto! Usuário criado.**

---

### Passo 2: Executar Script SQL (3 minutos)

1. Menu esquerdo: **SQL Editor**
2. Botão: **New Query**
3. **Cole o script completo** (veja abaixo)
4. Botão: **RUN** (ou Ctrl+Enter)
5. Aguarde: "Query executed successfully"

---

## 📝 Script SQL Completo

Copie e cole tudo isto no SQL Editor do Supabase:

```sql
BEGIN;

-- Criar empresa
INSERT INTO public.empresas (nome, email, plano, status, criado_em)
VALUES ('Demo Transportes', 'demo@siloflux.com.br', 'premium', 'ativo', NOW())
ON CONFLICT DO NOTHING;

-- Criar 3 motoristas com carretas silo
INSERT INTO public.motoristas (empresa_id, nome, categoria, placa_cavalo, placa_carreta, whatsapp, laudo_anual_vence, laudo_trimestral_vence, criado_em)
SELECT
  e.id,
  motorista,
  'FROTA',
  cavalo,
  carreta,
  wa,
  laudo_anual,
  laudo_trimestral,
  NOW()
FROM (VALUES
  ('MARCOS SILVA', 'ABC-1234', 'SLO-0001', '+55 41 99111-1111', '2026-08-15'::date, '2026-07-20'::date),
  ('RODRIGO COSTA', 'ABC-5678', 'SLO-0002', '+55 41 99222-2222', '2026-09-10'::date, '2026-07-15'::date),
  ('FELIPE SANTOS', 'ABC-9999', 'SLO-0003', '+55 41 99333-3333', '2026-07-25'::date, '2026-08-05'::date)
) AS motoristas(motorista, cavalo, carreta, wa, laudo_anual, laudo_trimestral),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- Fábricas
INSERT INTO public.fabrica (empresa_id, nome, criado_em)
SELECT e.id, fabrica, NOW()
FROM (VALUES
  ('Fábrica São Paulo'),
  ('Fábrica Minas Gerais'),
  ('Fábrica Paraná')
) AS fabricas(fabrica),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- Clientes
INSERT INTO public.cliente (empresa_id, nome, criado_em)
SELECT e.id, cliente, NOW()
FROM (VALUES
  ('Construtora ABC - São Paulo'),
  ('Empreendimento XYZ - Minas'),
  ('Obra JKL - Paraná'),
  ('Construção DEF - Rio'),
  ('Projeto MNO - Brasília')
) AS clientes(cliente),
public.empresas e
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

-- Pedidos (12 fictícios)
INSERT INTO public.pedidos (empresa_id, numero_pedido, motorista_id, fabrica_id, cliente_id, qtd_ton, programado_de, programado_ate, valor_frete, status, criado_em)
SELECT
  e.id,
  'PED-' || LPAD((ROW_NUMBER() OVER (ORDER BY i))::text, 6, '0'),
  m.id,
  f.id,
  c.id,
  30.0 + (ROW_NUMBER() OVER (ORDER BY i) * 5),
  (CURRENT_DATE + (ROW_NUMBER() OVER (ORDER BY i) - 1))::date,
  (CURRENT_DATE + (ROW_NUMBER() OVER (ORDER BY i) + 2))::date,
  4500.00 + (ROW_NUMBER() OVER (ORDER BY i) * 250),
  CASE
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 3 THEN 'VIAGEM'
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 6 THEN 'ENTREGUE'
    WHEN ROW_NUMBER() OVER (ORDER BY i) <= 8 THEN 'CARREG'
    ELSE 'PROG'
  END,
  NOW() - INTERVAL '1 day' * (ROW_NUMBER() OVER (ORDER BY i))
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

-- Laudos vencendo
INSERT INTO public.motoristas_laudos (motorista_id, tipo_laudo, vencimento, criado_em)
SELECT m.id, 'ANUAL', (CURRENT_DATE + INTERVAL '15 days')::date, NOW()
FROM public.motoristas m
CROSS JOIN public.empresas e ON m.empresa_id = e.id
WHERE e.nome = 'Demo Transportes'
ON CONFLICT DO NOTHING;

COMMIT;
```

---

### Passo 3: Testar Login (1 minuto)

1. Abra: **https://logflux.vercel.app/sistema**
2. Faça login:
   - Email: `demo@siloflux.com.br`
   - Senha: `Siloflux2026`
3. Você deve ver:
   - ✅ Painel com "Demo Transportes" no topo
   - ✅ 3 Carretas silo (SLO-0001, SLO-0002, SLO-0003)
   - ✅ Pedidos em viagem/entregue
   - ✅ Alguns laudos com alerta de vencimento

---

## ✅ Checklist

- [ ] Usuário `demo@siloflux.com.br` criado em Auth
- [ ] Script SQL executado com sucesso
- [ ] Consegui fazer login no painel
- [ ] Vejo os dados demo (carretas, pedidos, etc)
- [ ] Laudos com alerta de vencimento aparecem

---

**Pronto! Conta demo operacional em 5 minutos! 🚀**

Se algo der erro, consulte o arquivo completo: `criar-demo-siloflux.sql`
