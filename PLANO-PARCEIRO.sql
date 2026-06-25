-- ============================================================
-- SiloFlux — Adicionar Plano Parceiro Fundador
-- Rode no SQL Editor do Supabase (projeto do SaaS).
--
-- POR QUÊ: rastrear qual tipo de plano cada cliente possui
-- (Normal ou Plano Parceiro Fundador com 20% desconto).
-- Limite: apenas 5 clientes podem usar o plano parceiro.
-- ============================================================

-- 1) Adicionar coluna tipo_plano
alter table public.logflux_assinantes
add column if not exists tipo_plano text default 'normal';

-- 2) Comentário para documentação
comment on column public.logflux_assinantes.tipo_plano is 'Tipo de plano: normal (padrão) ou parceiro (desconto 20%, máx 5 clientes)';

-- 3) Tabela de preços do plano parceiro (para referência):
-- Micro: R$ 80 → R$ 64 (-20%)
-- Pequena: R$ 60 → R$ 48 (-20%)
-- Média: R$ 50 → R$ 40 (-20%)
-- Sob Medida: sob consulta (sem desconto automático)

-- ============================================================
-- PRONTO. Agora o painel admin pode:
--   • Criar novos clientes com "Plano Parceiro Fundador"
--   • Aplicar desconto de 20% automaticamente nos preços
--   • Contar vagas restantes (máximo 5)
--   • Mudar tipo de plano ao editar cliente
-- ============================================================
