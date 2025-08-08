import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { PaymentMethod, PaymentType, isAlipayConfigured, isWeChatConfigured } from '@/lib/payments';

export async function POST(req: NextRequest) {
  try {
    const { orderId, amount, method, type } = (await req.json()) as {
      orderId: string;
      amount: number;
      method: PaymentMethod;
      type: PaymentType;
    };
    if (!orderId || !amount || !method || !type) return NextResponse.json({ error: '缺少参数' }, { status: 400 });

    const order = await prisma.order.findUnique({ where: { id: orderId } });
    if (!order) return NextResponse.json({ error: '订单不存在' }, { status: 404 });

    const payment = await prisma.payment.create({
      data: { orderId, amount, type, method, status: 'pending' },
    });

    let payUrl = `/payments/mock?pid=${payment.id}`;

    if (method === 'alipay' && isAlipayConfigured()) {
      // 动态引入并显式类型
      type ExecFn = (method: string, opts: Record<string, unknown>) => Promise<string>;
      interface AlipayCtor { new (opts: Record<string, unknown>): { exec: ExecFn } }
      const mod = (await import('alipay-sdk')) as unknown as {
        default?: AlipayCtor;
        AlipaySdk?: AlipayCtor;
      };
      const AlipaySdkCtor: AlipayCtor = (mod.default ?? mod.AlipaySdk)!;
      const alipay = new AlipaySdkCtor({
        appId: process.env.ALIPAY_APP_ID!,
        privateKey: process.env.ALIPAY_PRIVATE_KEY!,
        alipayPublicKey: process.env.ALIPAY_PUBLIC_KEY,
      });
      const result = await alipay.exec('alipay.trade.page.pay', {
        method: 'GET',
        bizContent: {
          out_trade_no: payment.id,
          product_code: 'FAST_INSTANT_TRADE_PAY',
          total_amount: (amount / 100).toFixed(2),
          subject: `CCNUthesis-${type}`,
        },
        notifyUrl: `${process.env.NEXT_PUBLIC_BASE_URL}/api/payments/notify`,
        returnUrl: `${process.env.NEXT_PUBLIC_BASE_URL}/orders/${orderId}`,
      });
      payUrl = result as unknown as string;
    }

    if (method === 'wechat' && isWeChatConfigured()) {
      interface WechatClient {
        transactions_native: (
          data: Record<string, unknown>
        ) => Promise<{ code_url?: string }>;
      }
      interface WechatCtor { new (opts: Record<string, unknown>): WechatClient }
      const mod = (await import('wechatpay-node-v3')) as unknown as {
        default?: WechatCtor;
        Wechatpay?: WechatCtor;
      };
      const WechatpayCtor: WechatCtor = (mod.Wechatpay ?? mod.default)!;
      const wechatpay = new WechatpayCtor({
        mchid: process.env.WECHAT_MCH_ID!,
        serial: process.env.WECHAT_MCH_SERIAL!,
        privateKey: process.env.WECHAT_PRIVATE_KEY!,
        certs: {},
      });
      const resp = await wechatpay.transactions_native({
        appid: process.env.WECHAT_APP_ID!,
        mchid: process.env.WECHAT_MCH_ID!,
        description: `CCNUthesis-${type}`,
        out_trade_no: payment.id,
        notify_url: `${process.env.NEXT_PUBLIC_BASE_URL}/api/payments/notify`,
        amount: { total: amount },
      });
      if (resp && resp.code_url) {
        payUrl = resp.code_url;
      }
    }

    return NextResponse.json({ paymentId: payment.id, payUrl });
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}


