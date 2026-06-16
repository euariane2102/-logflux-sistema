// Vercel Serverless Function — Asaas Integration
// POST /api/asaas?action=criarAssinatura

const ASAAS_API = 'https://api.asaas.com/v3';
const ASAAS_KEY = process.env.ASAAS_API_KEY;

async function criarCustomer(email, cpfCnpj, nomeEmpresa) {
  const res = await fetch(`${ASAAS_API}/customers`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${ASAAS_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      name: nomeEmpresa,
      email: email,
      cpfCnpj: cpfCnpj.replace(/\D/g, ''), // remove formatação
      notificationDisable: false
    })
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.errors?.[0]?.detail || 'Erro ao criar cliente');
  return data.id;
}

async function criarAssinatura(customerId, valor, descricao, dataVencimento, metodo, parcelas) {
  const res = await fetch(`${ASAAS_API}/subscriptions`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${ASAAS_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      customer: customerId,
      value: valor,
      description: descricao,
      nextDueDate: dataVencimento, // YYYY-MM-DD
      billingType: metodo === 'pix' ? 'PIX' : metodo === 'boleto' ? 'BOLETO' : 'CREDIT_CARD',
      cycle: 'MONTHLY',
      maxDunningAttempts: 3,
      dueDateLimitDays: 3
    })
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.errors?.[0]?.detail || 'Erro ao criar assinatura');
  return data.id;
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ erro: 'Método não permitido' });
  }

  if (!ASAAS_KEY) {
    return res.status(500).json({ erro: 'ASAAS_API_KEY não configurada' });
  }

  const { action } = req.query;
  const { email, cpfCnpj, nomeEmpresa, plano, parcelas, metodo, dataVencimento } = req.body;

  try {
    if (action === 'criarAssinatura') {
      // 1. Cria cliente no Asaas
      const customerId = await criarCustomer(email, cpfCnpj, nomeEmpresa);

      // 2. Define valores por plano
      const config = {
        essencial: { entrada: 3000, mensal: 300 },
        profissional: { entrada: 5000, mensal: 400 },
        sob_medida: { entrada: 8000, mensal: 600 }
      }[plano] || { entrada: 3000, mensal: 300 };

      // 3. Calcula valor da parcela (entrada)
      const valorParcela = Math.round((config.entrada / parcelas) * 100) / 100;

      // 4. Cria assinatura da entrada (parcelada)
      const assinEntrada = await criarAssinatura(
        customerId,
        valorParcela,
        `Implantação LogFlux — Plano ${plano} (${parcelas}x)`,
        dataVencimento,
        metodo,
        1
      );

      // 5. Cria assinatura da mensalidade (começa próximo mês)
      const proximoMes = new Date(dataVencimento);
      proximoMes.setMonth(proximoMes.getMonth() + 1);
      const dataProximoMes = proximoMes.toISOString().split('T')[0];

      const assinMensal = await criarAssinatura(
        customerId,
        config.mensal,
        `Mensalidade LogFlux — Plano ${plano}`,
        dataProximoMes,
        metodo,
        1
      );

      return res.status(200).json({
        sucesso: true,
        assinatura_entrada_id: assinEntrada,
        assinatura_mensal_id: assinMensal,
        customer_id: customerId,
        valor_parcela: valorParcela,
        valor_mensal: config.mensal
      });
    }

    return res.status(400).json({ erro: 'Action não reconhecida' });
  } catch (error) {
    console.error('Erro Asaas:', error.message);
    return res.status(500).json({ erro: error.message });
  }
}
