-- ============================================================
-- SiloFlux — Controle de USO de carretas no painel admin
-- Rode no SQL Editor do Supabase (projeto do SaaS).
-- Admin = admin@logflux.com
--
-- POR QUÊ: o painel admin precisa LER a frota cadastrada por
-- cada cliente (tabela logflux_dados, chave 'frota') para contar
-- quantas carretas cada um usa de verdade e comparar com o
-- contratado. O RLS só deixa cada cliente ver os próprios dados;
-- esta policy dá ao admin acesso de LEITURA a todos.
-- ============================================================

-- 1) Admin pode LER os dados de todos os clientes (só leitura)
drop policy if exists "dados_admin_select" on public.logflux_dados;
create policy "dados_admin_select" on public.logflux_dados
  for select
  using ((auth.jwt() ->> 'email') = 'admin@logflux.com');

-- 2) Garante a coluna de carretas contratadas no cadastro
alter table public.logflux_assinantes
  add column if not exists qtd_carretas int default 0;

-- ============================================================
-- PRONTO. Agora o painel admin mostra, para cada cliente:
--   • carretas EM USO (lidas do sistema do cliente)
--   • carretas CONTRATADAS (você define)
--   • alerta quando o uso excede o contratado
--   • mensalidade calculada pelo uso real (carretas usadas x taxa)
-- ============================================================
