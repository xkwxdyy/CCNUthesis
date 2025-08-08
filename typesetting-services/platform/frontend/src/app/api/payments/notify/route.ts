import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

// 支付宝/微信回调统一入口（示例：JSON 模式）
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { paymentId, success } = body as { paymentId: string; success: boolean };
    if (!paymentId) return NextResponse.json({ error: 'paymentId required' }, { status: 400 });

    const payment = await prisma.payment.update({
      where: { id: paymentId },
      data: {
        status: success ? 'completed' : 'failed',
        paidAt: success ? new Date() : null,
      },
    });

    // 同步订单状态
    if (success) {
      await prisma.order.update({
        where: { id: payment.orderId },
        data: {
          depositPaid: payment.type === 'deposit' ? true : undefined,
          finalPaid: payment.type === 'final' ? true : undefined,
          status: payment.type === 'deposit' ? 'processing' : 'completed',
        },
      });
    }

    return NextResponse.json({ ok: true });
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}


