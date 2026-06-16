// Vercel Serverless — Webhook do Asaas
// POST /api/webhook-asaas
// Asaas notifica aqui quando há pagamentos

import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY // chave de servidor (segura)
);

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ erro: 'Método não permitido' });
  }

  const { event, data } = req.body;

  try {
    // Asaas notifica em 2 eventos principais
    if (event === 'PAYMENT_RECEIVED' || event === 'PAYMENT_CONFIRMED') {
      // Pagamento recebido
      const { subscription, value, status, dueDate, paymentDate } = data;

      // Registra na tabela de pagamentos
      const { error: errPag } = await supabase.from('logflux_pagamentos').insert({
        assinatura_id: subscription,
        valor: value,
        status: 'CONFIRMED',
        data_vencimento: dueDate,
        data_pagamento: paymentDate,
        webhook_id: `${subscription}_${paymentDate}`, // único
        tipo: 'entrada' // ou 'mensal' — você pode distinguir por descrição
      });

      if (errPag) {
        console.error('Erro ao registrar pagamento:', errPag);
        return res.status(500).json({ erro: 'Falha ao registrar' });
      }

      // Se é a última parcela da entrada, ativa a conta
      const { data: assinatura } = await supabase
        .from('logflux_assinaturas')
        .select('user_id, parcelas, status')
        .eq('assinatura_entrada_id', subscription)
        .single();

      if (assinatura) {
        // Conta quantas parcelas foram pagas
        const { count } = await supabase
          .from('logflux_pagamentos')
          .select('*', { count: 'exact', head: true })
          .eq('assinatura_id', subscription)
          .eq('status', 'CONFIRMED');

        // Se chegou ao número de parcelas, ativa
        if (count >= assinatura.parcelas) {
          await supabase
            .from('logflux_assinantes')
            .update({ status: 'ativo' })
            .eq('user_id', assinatura.user_id);
        }
      }

      return res.status(200).json({ processado: true });
    }

    if (event === 'PAYMENT_OVERDUE' || event === 'PAYMENT_FAILED') {
      // Pagamento atrasado ou falhou
      const { subscription, daysOverdue } = data;

      // Registra como atraso
      await supabase.from('logflux_pagamentos').upsert({
        assinatura_id: subscription,
        status: 'OVERDUE',
        webhook_id: `${subscription}_overdue`
      });

      // Após 3+ dias de atraso, suspende a conta
      if (daysOverdue >= 3) {
        const { data: assinatura } = await supabase
          .from('logflux_assinaturas')
          .select('user_id')
          .eq('assinatura_entrada_id', subscription)
          .single();

        if (assinatura) {
          await supabase
            .from('logflux_assinantes')
            .update({ status: 'suspenso' })
            .eq('user_id', assinatura.user_id);
        }
      }

      return res.status(200).json({ processado: true });
    }

    // Evento desconhecido, só confirma recebimento
    return res.status(200).json({ processado: true });
  } catch (error) {
    console.error('Erro webhook:', error.message);
    return res.status(500).json({ erro: error.message });
  }
}
