# LogFlux SaaS — Guia de configuração (o que VOCÊ faz)

Este guia cobre só as partes que dependem do seu login. A parte de código eu preparo.

---

## Passo 1 — Criar o projeto no Supabase (NOVO, separado da RCB)

1. Acesse [supabase.com](https://supabase.com) e entre na sua conta.
2. Clique em **New Project**.
3. Nome: `logflux-saas` (ou o que preferir).
4. Defina uma senha forte para o banco (guarde num lugar seguro).
5. Região: **South America (São Paulo)**.
6. Clique em **Create new project** e aguarde ~2 minutos.

> ⚠️ Importante: este é um projeto **separado** do que a RCBMIX usa. Não mexa no projeto da RCB.

---

## Passo 2 — Criar as tabelas e a segurança

1. No projeto novo → menu lateral → **SQL Editor**.
2. Clique em **New query**.
3. Abra o arquivo `SUPABASE-SAAS.sql` (está nesta pasta), copie tudo e cole.
4. Clique em **Run**.
5. Deve aparecer "Success". Pronto — tabelas e segurança criadas.

---

## Passo 3 — Pegar as chaves de conexão

1. No projeto → **Settings** (engrenagem) → **API**.
2. Copie estes dois valores e me mande:
   - **Project URL** (algo como `https://xxxx.supabase.co`)
   - **anon public** key (a chave pública)

> ✅ Pode me mandar esses dois sem medo — a chave **anon public** é feita pra ficar no site e é protegida pela segurança (RLS) que criamos.
> 🚫 **NUNCA** me mande (nem coloque no site) a chave **service_role** / **secret** — essa é a chave mestra e deve ficar só com você.

---

## Passo 4 — (faço eu) Ligar o login e a separação por cliente

Com a URL e a chave pública, eu:
- Coloco a tela de **login/cadastro** no sistema.
- Faço cada conta **enxergar só os próprios dados**.
- Crio a tela **"aguardando liberação"** para contas pendentes.

---

## Passo 5 — Publicar na Vercel

1. Subo o sistema no GitHub (repositório `logflux-sistema`).
2. Você importa na Vercel (igual fez com os outros) → **Deploy**.
3. Liga no domínio: `logflux.com.br/sistema` (ou `app.logflux.com.br`).

---

## Como liberar um cliente novo (no dia a dia)

Quando alguém se cadastrar, a conta nasce **pendente**. Para liberar:

1. Supabase → **Table Editor** → tabela `logflux_assinantes`.
2. Ache a empresa e troque o **status** de `pendente` para **`ativo`**.
3. Pronto — na próxima vez que o cliente entrar, o sistema abre normal.

Para suspender (não pagou): troque para `suspenso`.
