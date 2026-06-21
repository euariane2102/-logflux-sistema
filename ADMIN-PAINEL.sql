-- ============================================================
-- LogFlux SaaS — Painel ADMIN (liberar/bloquear clientes + cobranças)
-- Rode TUDO de uma vez no SQL Editor do Supabase.
-- Admin = admin@logflux.com
-- ============================================================

-- 1) Campos extras no cadastro de assinantes (plano + mensalidade + telefone)
alter table public.logflux_assinantes add column if not exists plano text;
alter table public.logflux_assinantes add column if not exists valor_mensal numeric default 0;
alter table public.logflux_assinantes add column if not exists vencimento_dia int default 10;
alter table public.logflux_assinantes add column if not exists telefone text;

-- 2) Permite clientes só para cobrança (sem login no sistema)
-- Remove FK para auth.users e adiciona default UUID automático
alter table public.logflux_assinantes drop constraint if exists logflux_assinantes_user_id_fkey;
alter table public.logflux_assinantes alter column user_id set default gen_random_uuid();

-- Campos completos do cadastro de cliente
alter table public.logflux_assinantes add column if not exists email_pessoal text;
alter table public.logflux_assinantes add column if not exists razao_social text;
alter table public.logflux_assinantes add column if not exists cnpj text;
alter table public.logflux_assinantes add column if not exists cep text;
alter table public.logflux_assinantes add column if not exists rua text;
alter table public.logflux_assinantes add column if not exists numero text;
alter table public.logflux_assinantes add column if not exists complemento text;
alter table public.logflux_assinantes add column if not exists bairro text;
alter table public.logflux_assinantes add column if not exists cidade text;
alter table public.logflux_assinantes add column if not exists estado text;
alter table public.logflux_assinantes add column if not exists contato_nome text;
alter table public.logflux_assinantes add column if not exists contato_cargo text;
alter table public.logflux_assinantes add column if not exists observacoes text;

-- 3) O ADMIN enxerga e gerencia TODOS os assinantes (liberar / bloquear)
drop policy if exists "assinante_admin_all" on public.logflux_assinantes;
create policy "assinante_admin_all" on public.logflux_assinantes
  for all
  using ((auth.jwt() ->> 'email') = 'admin@logflux.com')
  with check ((auth.jwt() ->> 'email') = 'admin@logflux.com');

-- 3) Tabela de COBRANÇAS / MENSALIDADES
create table if not exists public.logflux_cobrancas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  empresa text,
  competencia text,                         -- ex.: "2026-06"
  valor numeric not null default 0,
  vencimento date,
  status text not null default 'aberta',    -- aberta | paga | atrasada
  criado_em timestamptz default now()
);
alter table public.logflux_cobrancas enable row level security;

-- cliente vê as próprias cobranças
drop policy if exists "cobr_select_proprio" on public.logflux_cobrancas;
create policy "cobr_select_proprio" on public.logflux_cobrancas
  for select using (auth.uid() = user_id);

-- admin gerencia todas as cobranças
drop policy if exists "cobr_admin_all" on public.logflux_cobrancas;
create policy "cobr_admin_all" on public.logflux_cobrancas
  for all
  using ((auth.jwt() ->> 'email') = 'admin@logflux.com')
  with check ((auth.jwt() ->> 'email') = 'admin@logflux.com');

-- ============================================================
-- PRONTO. Agora o painel admin (/sistema/admin) consegue:
--   • listar todos os clientes
--   • liberar (ativo) / suspender (suspenso) / deixar pendente
--   • definir plano e valor da mensalidade
--   • gerar e controlar cobranças mensais
-- ============================================================
