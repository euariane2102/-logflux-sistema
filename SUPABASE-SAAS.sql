-- ============================================================
-- LogFlux SaaS — Tabelas e Segurança (RLS)
-- Rode este script no SQL Editor do projeto Supabase do SaaS
-- (o projeto NOVO, separado da RCBMIX)
-- ============================================================

-- 1) DADOS DE CADA EMPRESA
-- Um registro por "chave" (frota, pedidos, etc.) por usuário.
create table if not exists public.logflux_dados (
  user_id uuid not null references auth.users(id) on delete cascade,
  chave text not null,
  dados jsonb,
  atualizado_em timestamptz default now(),
  primary key (user_id, chave)
);

-- 2) CADASTRO DE ASSINANTES (controle de liberação)
-- status: 'pendente' (acabou de se cadastrar) | 'ativo' (liberado por você) | 'suspenso'
create table if not exists public.logflux_assinantes (
  user_id uuid primary key references auth.users(id) on delete cascade,
  empresa text,
  email text,
  status text not null default 'pendente',
  criado_em timestamptz default now()
);

-- 3) LIGAR A SEGURANÇA POR LINHA (Row Level Security)
alter table public.logflux_dados enable row level security;
alter table public.logflux_assinantes enable row level security;

-- 4) POLÍTICAS DE ACESSO
-- ---- logflux_dados: cada usuário só acessa os PRÓPRIOS dados ----
create policy "dados_select_proprio" on public.logflux_dados
  for select using (auth.uid() = user_id);
create policy "dados_insert_proprio" on public.logflux_dados
  for insert with check (auth.uid() = user_id);
create policy "dados_update_proprio" on public.logflux_dados
  for update using (auth.uid() = user_id);
create policy "dados_delete_proprio" on public.logflux_dados
  for delete using (auth.uid() = user_id);

-- ---- logflux_assinantes ----
-- lê só a própria linha:
create policy "assinante_select_proprio" on public.logflux_assinantes
  for select using (auth.uid() = user_id);
-- cria a própria linha no cadastro, SEMPRE como 'pendente'
-- (impede o cliente de se auto-liberar colocando status 'ativo'):
create policy "assinante_insert_pendente" on public.logflux_assinantes
  for insert with check (auth.uid() = user_id and status = 'pendente');
-- (Repare: NÃO existe política de UPDATE aqui de propósito.
--  Só VOCÊ muda o status, pelo painel do Supabase, que ignora o RLS.)

-- ============================================================
-- COMO LIBERAR UM CLIENTE (depois que ele se cadastrar):
--   No Supabase → Table Editor → logflux_assinantes →
--   troque o status da empresa de 'pendente' para 'ativo'.
-- COMO SUSPENDER (não pagou):
--   troque para 'suspenso'.
-- ============================================================
