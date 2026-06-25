-- ============================================================
-- SiloFlux — Conta Demo fora das métricas + corrigir faturamento
-- Rode no SQL Editor do Supabase (projeto do SaaS).
--
-- POR QUÊ:
--   1) A Transportadora Demo não é cliente pagante e estava
--      inflando faturamento, MRR, clientes ativos e margem.
--   2) O RCBMIX (único cliente real) deve ser R$ 1.200/mês
--      (30 carretas × R$ 40 no Plano Parceiro Fundador).
-- ============================================================

-- 1) Adicionar a coluna que marca contas de demonstração
alter table public.logflux_assinantes
add column if not exists conta_demo boolean default false;

comment on column public.logflux_assinantes.conta_demo is 'true = conta de demonstração; NÃO entra em faturamento, MRR nem contagem de clientes';

-- 2) Marcar a Transportadora Demo como conta demo
--    (cobre os dois e-mails usados em demonstração)
update public.logflux_assinantes
set conta_demo = true
where lower(email) in ('demo@logflux.com.br','demo@siloflux.com.br')
   or lower(coalesce(email_pessoal,'')) in ('demo@logflux.com.br','demo@siloflux.com.br')
   or empresa ilike '%demo%';

-- 3) Garantir que o RCBMIX NÃO seja demo e tenha o valor correto
update public.logflux_assinantes
set conta_demo   = false,
    tipo_plano   = 'parceiro',
    plano        = 'Media',
    qtd_carretas = 30,
    valor_mensal = 1200
where empresa ilike '%RCBMIX%'
   or lower(email) = 'sanderson.silva@outlook.com';

-- ============================================================
-- 4) (OPCIONAL) Corrigir cobrança de teste de R$ 1.800
--    Rode primeiro o SELECT para conferir o que existe:
--
--    select id, empresa, competencia, valor, status
--    from public.logflux_cobrancas
--    where valor = 1800;
--
--    Se confirmar que é teste antigo, apague com:
--
--    delete from public.logflux_cobrancas where valor = 1800;
-- ============================================================

-- 5) Conferir o resultado:
--    select empresa, status, conta_demo, valor_mensal
--    from public.logflux_assinantes
--    order by conta_demo, empresa;
-- ============================================================
-- PRONTO. Após rodar, a Visão geral deve mostrar:
--   • Clientes ativos: 1 (só RCBMIX)
--   • Entrada/MRR: R$ 1.200,00
--   • Conta demo: fora de todas as métricas
-- ============================================================
