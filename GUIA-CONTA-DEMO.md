# 📋 Guia: Criar Conta Demo SiloFlux

## Passo 1️⃣: Acessar Supabase Console

1. Abra: **https://app.supabase.com**
2. Faça login com sua conta
3. Selecione o projeto: **cizpxkjzvfyewnlqhjzf**

---

## Passo 2️⃣: Criar Usuário Demo (Authentication)

### Localização:
Menu esquerdo → **Authentication** → **Users** → Botão **Add User**

### Dados:
| Campo | Valor |
|-------|-------|
| Email | `demo@siloflux.com.br` |
| Password | `Siloflux2026` |
| Auto Confirm | ✅ SIM |

### Passos:
1. Clique em **Add User**
2. Preencha Email: `demo@siloflux.com.br`
3. Preencha Password: `Siloflux2026`
4. **Marque** checkbox: "Auto Confirm Email"
5. Clique **Save**

---

## Passo 3️⃣: Executar Script SQL

### Localização:
Menu esquerdo → **SQL Editor** → **New Query**

### Passos:
1. Copie o conteúdo do arquivo: `criar-demo-siloflux.sql`
2. Cole na editor do Supabase
3. Clique **RUN** (Ctrl+Enter)
4. Aguarde a mensagem: "Query executed successfully"

### O que será criado:
- ✅ Empresa: **Demo Transportes**
- ✅ 3 Motoristas com carretas silo
- ✅ 12+ Pedidos em diferentes status
- ✅ 3 Fábricas/origens
- ✅ 5 Clientes/destinos
- ✅ Laudos vencendo (alerta demo)

---

## Passo 4️⃣: Validar Criação

### No Supabase Console:
1. Acesse **Table Editor**
2. Verifique:
   - **auth.users**: deve conter `demo@siloflux.com.br`
   - **empresas**: deve conter "Demo Transportes"
   - **motoristas**: deve conter Marcos, Rodrigo, Felipe
   - **pedidos**: deve conter 12+ registros

### No Sistema SiloFlux:
1. Acesse: **https://[seu-dominio]/sistema** (ou localhost)
2. Faça login:
   - Email: `demo@siloflux.com.br`
   - Senha: `Siloflux2026`
3. Verifique painel com:
   - 3 Carretas silo visíveis
   - Pedidos em viagem
   - Alguns laudos com alerta de vencimento

---

## 🔗 URLs Importantes

| Recurso | URL |
|---------|-----|
| Supabase Console | https://app.supabase.com/projects/cizpxkjzvfyewnlqhjzf |
| SQL Editor | https://app.supabase.com/projects/cizpxkjzvfyewnlqhjzf/sql |
| Auth Users | https://app.supabase.com/projects/cizpxkjzvfyewnlqhjzf/auth/users |
| Sistema SiloFlux | https://[seu-dominio]/sistema |

---

## ⚠️ Troubleshooting

### Script não executa?
- [ ] Verifique se está no projeto correto: `cizpxkjzvfyewnlqhjzf`
- [ ] Verifique sintaxe SQL (sem erros de digitação)
- [ ] Tente executar linha por linha

### Login não funciona?
- [ ] Verifique se usuário foi criado em **Authentication > Users**
- [ ] Confirme se email está: `demo@siloflux.com.br`
- [ ] Confirme se senha está: `Siloflux2026`
- [ ] Limpe cache do navegador (Ctrl+Shift+Del)

### Dados não aparecem no painel?
- [ ] Recarregue a página do sistema (F5)
- [ ] Aguarde 5 segundos para sincronização
- [ ] Verifique console do navegador (F12) para erros

---

## ✅ Checklist Final

Após completar os passos, você deve ter:

- [ ] Usuário `demo@siloflux.com.br` criado em Auth
- [ ] Empresa "Demo Transportes" no banco de dados
- [ ] 3 motoristas com carretas silo (SLO-0001, SLO-0002, SLO-0003)
- [ ] 12+ pedidos em diferentes status
- [ ] Painel carregando sem erros
- [ ] Login funcionando com conta demo
- [ ] Laudos com alerta de vencimento visíveis

---

**Pronto para demonstração comercial! 🚀**
