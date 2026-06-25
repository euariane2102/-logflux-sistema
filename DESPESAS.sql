-- ============================================================
-- SiloFlux — Tabela de Despesas Operacionais
-- Rode no SQL Editor do Supabase (projeto do SaaS).
--
-- Permite rastrear despesas (servidor, suporte, etc.) e calcular
-- lucro bruto (receita de cobranças - despesas).
-- ============================================================

-- 1) Tabela de despesas
create table if not exists public.logflux_despesas (
  id uuid primary key default gen_random_uuid(),
  competencia text not null,                 -- ex: "2026-06"
  descricao text not null,                   -- ex: "Servidor Supabase", "Suporte técnico"
  categoria text,                            -- ex: "Infra", "Suporte", "Marketing"
  valor numeric not null default 0,
  data_pagamento date,
  observacao text,
  criado_em timestamp default now(),
  criado_por text                            -- email do admin
);

-- 2) RLS: admin vê/gerencia todas as despesas
alter table public.logflux_despesas enable row level security;

drop policy if exists "desp_admin_all" on public.logflux_despesas;
create policy "desp_admin_all" on public.logflux_despesas
  for all
  using ((auth.jwt() ->> 'email') = 'admin@logflux.com')
  with check ((auth.jwt() ->> 'email') = 'admin@logflux.com');

-- ============================================================
-- PRONTO. Agora o painel admin tem:
--   • Seção "Despesas" no painel de cobranças
--   • Incluir/editar/remover despesas por competência
--   • Cálculo automático: Receita Total - Total Despesas = Lucro Bruto
-- ============================================================
