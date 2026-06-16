# LogFlux SaaS — Sistema de Gestão Logística

Sistema multi-cliente de gestão logística hospedado como SaaS.

## Como usar

1. **Abra** `index.html` no navegador
2. **Primeira vez?** Clique em "Criar conta" e informe:
   - Nome da sua empresa
   - E-mail
   - Senha (mín. 6 caracteres)
3. **Espere** a liberação (você libera no Supabase — veja em `SETUP-SAAS.md`)
4. Quando ativo, **entre** com e-mail + senha e use normalmente

## Configuração (primeiro acesso)

Veja `SETUP-SAAS.md` para:
- Como criar o projeto no Supabase
- Como rodar o SQL de segurança
- Como liberar clientes novos

## Documentação

- `SETUP-SAAS.md` — guia passo a passo (o que você faz)
- `SUPABASE-SAAS.sql` — script de banco (tabelas + segurança)
- `../LogFlux-Comercial/PLANO-TECNICO-SAAS.md` — arquitetura completa

## Deploy

O sistema foi feito para rodar na **Vercel**:

```bash
git init
git add .
git commit -m "Initial commit: LogFlux SaaS system"
git remote add origin https://github.com/euariane2102/logflux-sistema.git
git push -u origin main
```

Depois importa em `vercel.com` como um projeto Next.js / Static.

---

**Desenvolvido com:** Supabase (autenticação + banco) + HTML/CSS/JS vanilla.

**Nota:** O sistema da RCBMIX permanece **separado e intocado** em seu projeto original.
