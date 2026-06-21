# Setup da Conta Demo do Logflux

## Passo 1: Criar usuário no Supabase

1. Acesse o dashboard do Supabase: https://app.supabase.com
2. Selecione o projeto LogFlux
3. Vá para **Authentication → Users**
4. Clique em **Create new user** (ou invite)
5. Email: `demo@logflux.com.br`
6. Password: defina uma senha segura (será usada para login)
7. Clique em **Create user**
8. **Copie o User ID** da nova conta (será um UUID como `550e8400-e29b-41d4-a716-446655440000`)

## Passo 2: Executar o SQL de dados fictícios

1. No Supabase, vá para **SQL Editor**
2. Clique em **New Query**
3. Abra o arquivo `DEMO-DADOS.sql`
4. **Importante:** Substitua `{{DEMO_USER_ID}}` pelo ID copiado no Passo 1
   - Exemplo: Se o ID for `550e8400-e29b-41d4-a716-446655440000`, substitua:
   ```sql
   '{{DEMO_USER_ID}}'
   ```
   por
   ```sql
   '550e8400-e29b-41d4-a716-446655440000'
   ```
5. Clique em **Run** para executar o SQL

## Passo 3: Verificar a conta demo

1. Vá para **Table Editor → logflux_assinantes**
2. Procure pela linha `Transportadora Demo · Logflux`
3. Status deve estar como `ativo`
4. Se estiver como `pendente`, clique e altere para `ativo`

## Passo 4: Fazer login na conta demo

1. Acesse https://logflux-ariane-moura.vercel.app (ou o URL do seu Vercel)
2. Email: `demo@logflux.com.br`
3. Password: a senha criada no Passo 1
4. Você deve ver a frota de 5 carretas silo com dados fictícios

## Dados fictícios inclusos

### Frota (5 carretas silo)
- AAA-0001 | Carlos Silva | Disponível
- BBB-0002 | João Santos | Em viagem
- CCC-0003 | Pedro Oliveira | Entregue
- DDD-0004 | Marcos Ferreira | Aguard. descarga
- EEE-0005 | Ricardo Costa | Em manutenção

### Pedidos (20 pedidos)
- Números no formato Votorantim (90510000XX)
- Clientes: Supermix Demo, Polimix Demo, Concreteira Exemplo
- Tonelagem: 26t a 35t por viagem
- Status variados: Entregue, Em viagem, Aguardando descarga, Programado

### Abastecimentos
- 5 registros dos últimos 2 dias
- Postos: ESSO, BR, PETROBRAS
- Valores realistas (R$ 850–920)

### Estatísticas globais
- **Total de tonelagem:** ~590t
- **Total de pedidos:** 20
- **Faturamento estimado:** ~R$ 120k (baseado em R$200/t)

## Dicas para testes

- Tente mudar o status de um pedido (clique em uma viagem)
- Faça um abastecimento (aba Operação → Novo abastecimento)
- Veja o relatório (aba Relatórios)
- Teste o WhatsApp integrado (pedidos têm botão verde)

## Credenciais para suporte

- Email admin: `admin@logflux.com.br`
- Email demo: `demo@logflux.com.br`
- Suporte demo: WhatsApp (41) 99694-1970

---

**Nota:** Esta é uma conta de demonstração. Os dados são fictícios e podem ser reset a qualquer momento. Para usar em produção, crie uma conta real via `/sistema` no site.
