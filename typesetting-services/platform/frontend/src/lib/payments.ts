export type PaymentMethod = 'alipay' | 'wechat' | 'mock';
export type PaymentType = 'deposit' | 'final';

export interface CreatePaymentResult {
  paymentId: string;
  amount: number;
  method: PaymentMethod;
  type: PaymentType;
  payUrl: string;
}

export function isAlipayConfigured(): boolean {
  return !!(process.env.ALIPAY_APP_ID && process.env.ALIPAY_PRIVATE_KEY);
}

export function isWeChatConfigured(): boolean {
  return !!(process.env.WECHAT_MCH_ID && process.env.WECHAT_MCH_SERIAL && process.env.WECHAT_PRIVATE_KEY && process.env.WECHAT_APP_ID);
}


