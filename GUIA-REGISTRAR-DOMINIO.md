# 📋 Guia: Registrar siloflux.com.br e Apontar para Vercel

## Parte 1️⃣: Registrar Domínio no HostGator

### Passo 1: Acessar HostGator
1. Abra: **https://cliente.hostgator.com.br/dominios**
2. Clique no botão azul **"Novo domínio"** (canto superior direito)

### Passo 2: Procurar disponibilidade
1. Campo de texto: Digite **`siloflux.com.br`**
2. Clique em **"Procurar"** ou **"Buscar"**
3. Aguarde resultado de disponibilidade

### Passo 3: Verificar disponibilidade
Se aparecer:
- ✅ **"Domínio disponível"** → Continue para o próximo passo
- ❌ **"Domínio indisponível"** → Tente variações:
  - `siloflux.com.br` (primeira opção)
  - `meusiloflu.com.br`
  - `silofluxtransportes.com.br`

### Passo 4: Adicionar ao carrinho
1. Clique em **"Adicionar ao carrinho"** ou **"Comprar"**
2. Verifique preço anual (deve estar em torno de R$ 40-60)
3. Período: Selecione **1 ano** (mínimo)

### Passo 5: Checkout
1. Clique em **"Ir para carrinho"** ou **"Finalizar compra"**
2. Revise os dados de cobrança
3. Escolha método de pagamento:
   - Boleto
   - PIX
   - Cartão de crédito
4. Clique em **"Confirmar pagamento"**

### Passo 6: Ativar automático
Após pagamento confirmado, o domínio ficará ativo em até 24 horas.

---

## Parte 2️⃣: Apontar Domínio para Vercel

### Localização: HostGator → Gerenciar Domínio

1. Acesse: **https://cliente.hostgator.com.br/dominios**
2. Clique no domínio **`siloflux.com.br`** da lista
3. Clique em **"Configurar domínio"** ou **"Gerenciar DNS"**

### Configurar DNS (2 opções)

#### **OPÇÃO 1: Apontar direto para Vercel** ⭐ RECOMENDADO

1. Acesse **Vercel Dashboard**: https://vercel.com
2. Vá até o projeto **logflux** (ou crie um novo)
3. **Settings** → **Domains**
4. Adicione: `siloflux.com.br`
5. Vercel mostrará 2 nameservers:
   ```
   ns1.vercel-dns.com
   ns2.vercel-dns.com
   ```

6. **Volte ao HostGator** → Gerenciar Domínio
7. Procure por **"Nameservers"** ou **"Servidores DNS"**
8. Substitua pelos do Vercel:
   - NS1: `ns1.vercel-dns.com`
   - NS2: `ns2.vercel-dns.com`
9. Clique em **"Salvar"**

**Tempo:** 15 minutos a 48 horas para ativar

#### **OPÇÃO 2: Apontar via Registros DNS**

Se preferir manter nameservers do HostGator:

1. **Em Vercel**, copie o **CNAME record** oferecido
2. **Em HostGator**, vá a **Registros DNS** ou **DNS Management**
3. Adicione registro CNAME:
   - Nome: `siloflux`
   - Valor: (o CNAME do Vercel)
   - TTL: 3600

---

## Parte 3️⃣: Validar Apontamento

### Verificar se está funcionando

Após 15 minutos a 48 horas, teste:

```bash
# No terminal:
nslookup siloflux.com.br
```

Deve retornar nameservers do Vercel.

### Testar no navegador

1. Abra: **https://siloflux.com.br** (HTTPS!)
2. Deve carregar a landing page com "Siloflux"
3. Abra: **https://siloflux.com.br/sistema**
4. Deve carregar o painel operacional

---

## ✅ Checklist Final

- [ ] Domínio `siloflux.com.br` registrado no HostGator
- [ ] Pagamento confirmado
- [ ] DNS apontando para Vercel
- [ ] `https://siloflux.com.br` carregando a landing
- [ ] `https://siloflux.com.br/sistema` carregando o painel
- [ ] Login funciona com conta demo (se criada)

---

## 🆘 Troubleshooting

### "Domínio ainda não está ativo"
- Aguarde 24 horas
- DNS pode levar 48 horas para propagar
- Limpe cache do navegador (Ctrl+Shift+Del)

### "Abre a página do HostGator ao invés de Siloflux"
- DNS ainda não atualizou
- Tente acessar direto: `https://logflux.vercel.app` (antigo domínio, funciona)

### "HTTPS dá erro"
- Vercel emite certificado SSL automaticamente
- Aguarde 24 horas

### "DNS não está atualizando"
- Verifique se salvou corretamente em Nameservers
- Tente ferramenta online: https://mxtoolbox.com/nslookup/
- Entre em contato com suporte HostGator

---

## 🔗 Links Úteis

| Recurso | URL |
|---------|-----|
| HostGator Painel | https://cliente.hostgator.com.br/dominios |
| Vercel Dashboard | https://vercel.com |
| Verificar DNS | https://mxtoolbox.com |
| Site atual (antigo) | https://logflux.vercel.app |
| Novo domínio (quando ativo) | https://siloflux.com.br |

---

**Pronto! Após ativar, todo tráfego de siloflux.com.br → logflux.vercel.app 🚀**
