-- ============================================================
-- SiloFlux — Adicionar campos para MRR e Churn
-- Rode no SQL Editor do Supabase (projeto do SaaS).
--
-- POR QUÊ: rastrear quando clientes ficam ativos e quando
-- são cancelados/suspensos para calcular MRR novo, perdido
-- e taxa de churn.
-- ============================================================

-- 1) Adicionar colunas de data
alter table public.logflux_assinantes
add column if not exists data_ativacao date,
add column if not exists data_cancelamento date;

-- 2) Comentários para documentação
comment on column public.logflux_assinantes.data_ativacao is 'Data quando o cliente ficou ativo';
comment on column public.logflux_assinantes.data_cancelamento is 'Data quando foi suspenso/cancelado (null se ativo)';

-- ============================================================
-- PRONTO. Agora o painel admin pode:
--   • Calcular MRR Novo (clientes ativados este mês)
--   • Calcular MRR Perdido (clientes cancelados este mês)
--   • Calcular Taxa de Churn (%)
--   • Mostrar evolução do MRR nos últimos 6 meses
-- ============================================================
