-- ============================================================
-- LogFlux — Criação automática do assinante no cadastro
-- Rode este script no SQL Editor do projeto Supabase do SaaS.
--
-- POR QUÊ: com a confirmação de e-mail LIGADA, logo após o
-- cadastro o usuário ainda não tem sessão ativa, então o
-- aplicativo não consegue gravar a linha em logflux_assinantes
-- (o RLS bloqueia, pois auth.uid() é nulo).
--
-- Este trigger roda no servidor com privilégio elevado
-- (SECURITY DEFINER) e cria a linha 'pendente' automaticamente
-- assim que a conta é criada — independente de confirmação.
-- ============================================================

create or replace function public.criar_assinante_no_signup()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.logflux_assinantes (user_id, empresa, email, status)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'empresa', 'Sem nome'),
    new.email,
    'pendente'
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists trg_criar_assinante on auth.users;
create trigger trg_criar_assinante
  after insert on auth.users
  for each row execute function public.criar_assinante_no_signup();

-- ============================================================
-- Depois de rodar: todo novo cadastro cria automaticamente
-- a empresa em logflux_assinantes com status 'pendente'.
-- Você libera trocando o status para 'ativo' no Table Editor.
-- ============================================================
