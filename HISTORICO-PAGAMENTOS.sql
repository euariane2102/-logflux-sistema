-- ============================================================
-- SiloFlux — Tabela de Histórico de Pagamentos
-- Rode no SQL Editor do Supabase (projeto do SaaS).
--
-- POR QUÊ: registrar detalhes de cada pagamento (data, valor
-- recebido, forma, observação) para auditoria, reconciliação
-- e análise de fluxo de caixa.
-- ============================================================

-- 1) Tabela de pagamentos registrados
create table if not exists public.logflux_pagamentos (
  id uuid primary key default gen_random_uuid(),
  cobranca_id uuid references public.logflux_cobrancas(id) on delete cascade,
  assinante_id uuid references public.logflux_assinantes(id) on delete cascade,
  empresa text,
  competencia text,                         -- ex: "2026-06"
  valor_cobrado numeric not null default 0,
  valor_recebido numeric not null default 0,
  data_pagamento date not null,
  forma_pagamento text not null default 'PIX',  -- PIX / Boleto / Transferência
  observacao text,
  registrado_em timestamp default now(),
  registrado_por text                       -- email do admin
);

-- 2) RLS: admin vê todos os pagamentos
alter table public.logflux_pagamentos enable row level security;

drop policy if exists "pag_admin_all" on public.logflux_pagamentos;
create policy "pag_admin_all" on public.logflux_pagamentos
  for all
  using ((auth.jwt() ->> 'email') = 'admin@logflux.com')
  with check ((auth.jwt() ->> 'email') = 'admin@logflux.com');

-- 3) Clientes veem os próprios pagamentos (opcional, para futura consulta)
drop policy if exists "pag_select_proprio" on public.logflux_pagamentos;
create policy "pag_select_proprio" on public.logflux_pagamentos
  for select
  using (auth.uid() = assinante_id);

-- ============================================================
-- PRONTO. Agora o painel admin pode:
--   • Registrar pagamento ao marcar cobrança como paga
--   • Ver histórico completo de pagamentos (data, valor, forma)
--   • Reconciliar valores cobrados vs recebidos
-- ============================================================
