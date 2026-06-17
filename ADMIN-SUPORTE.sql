-- ============================================================
-- LogFlux — Permissão de ADMIN para a Central de Suporte
-- Rode este script no SQL Editor do projeto Supabase do SaaS.
--
-- O QUE FAZ: permite que o e-mail do administrador
-- (admin@logflux.com) VEJA e ALTERE o status de TODOS os
-- clientes na tabela logflux_assinantes — o que faz os botões
-- "Liberar / Suspender" da página suporte.html funcionarem.
--
-- Clientes comuns continuam só enxergando a própria linha.
-- ============================================================

-- ADMIN pode VER todos os assinantes:
create policy "admin_select_todos" on public.logflux_assinantes
  for select
  using ( (auth.jwt() ->> 'email') = 'admin@logflux.com' );

-- ADMIN pode ALTERAR o status de qualquer assinante:
create policy "admin_update_todos" on public.logflux_assinantes
  for update
  using ( (auth.jwt() ->> 'email') = 'admin@logflux.com' )
  with check ( (auth.jwt() ->> 'email') = 'admin@logflux.com' );

-- ============================================================
-- IMPORTANTE — criar o login do admin:
--   No Supabase → Authentication → Users → "Add user" →
--   e-mail: admin@logflux.com  |  defina uma senha.
--   (marque "Auto Confirm User" para não precisar confirmar e-mail)
--
-- Depois acesse a central pela landing (rodapé → "Suporte")
-- ou direto em /suporte.html e entre com esse login.
-- ============================================================
