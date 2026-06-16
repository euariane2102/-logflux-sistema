-- ============================================================
-- LogFlux + Asaas — Tabelas de assinatura e pagamento
-- Rode no SQL Editor do projeto logflux-saas no Supabase
-- ============================================================

-- 1) ASSINATURAS (controle de plano + parcelamento)
create table if not exists public.logflux_assinaturas (
  user_id uuid primary key references auth.users(id) on delete cascade,
  plano text not null, -- 'essencial', 'profissional', 'sob_medida'
  parcelas int not null, -- 1, 2, 3, 4
  valor_entrada decimal not null,
  valor_mensal decimal not null,
  metodo_pagamento text not null, -- 'pix', 'boleto', 'cartao'
  cpf_cnpj text,
  assinatura_entrada_id text, -- ID da assinatura entrada no Asaas
  assinatura_mensal_id text, -- ID da assinatura mensal no Asaas
  status text not null default 'pendente_pagamento', -- pendente_pagamento, ativo, suspenso
  data_inicio timestamp,
  atualizado_em timestamp default now(),
  criado_em timestamp default now()
);

-- 2) PAGAMENTOS (log do webhook do Asaas)
create table if not exists public.logflux_pagamentos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  assinatura_id text, -- ID da assinatura no Asaas
  tipo text, -- 'entrada' ou 'mensal'
  valor decimal,
  status text, -- 'CONFIRMED', 'PENDING', 'OVERDUE', 'CANCELLED'
  data_vencimento date,
  data_pagamento date,
  webhook_id text unique, -- ID único do webhook pra não duplicar
  criado_em timestamp default now()
);

-- 3) RLS — segurança por linha
alter table public.logflux_assinaturas enable row level security;
alter table public.logflux_pagamentos enable row level security;

-- 4) POLÍTICAS DE ACESSO
-- Cada usuário acessa só seus dados
create policy "assinaturas_select_proprio" on public.logflux_assinaturas
  for select using (auth.uid() = user_id);
create policy "assinaturas_insert_proprio" on public.logflux_assinaturas
  for insert with check (auth.uid() = user_id);
create policy "assinaturas_update_proprio" on public.logflux_assinaturas
  for update using (auth.uid() = user_id);

create policy "pagamentos_select_proprio" on public.logflux_pagamentos
  for select using (auth.uid() = user_id);
create policy "pagamentos_insert_proprio" on public.logflux_pagamentos
  for insert with check (auth.uid() = user_id);

-- ============================================================
-- Pronto! Agora o banco está preparado pra Asaas.
-- ============================================================
