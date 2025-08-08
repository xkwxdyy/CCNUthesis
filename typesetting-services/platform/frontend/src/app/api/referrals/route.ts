import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(req: NextRequest) {
  try {
    const { referrerId, referredId, orderId } = await req.json();
    if (!referrerId || !referredId) {
      return NextResponse.json({ error: 'referrerId and referredId required' }, { status: 400 });
    }
    const referral = await prisma.referral.create({
      data: { referrerId, referredId, orderId: orderId || null },
    });
    return NextResponse.json(referral);
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

export async function GET(req: NextRequest) {
  const userId = req.nextUrl.searchParams.get('userId');
  if (!userId) return NextResponse.json({ error: 'userId required' }, { status: 400 });
  const items = await prisma.referral.findMany({
    where: { OR: [{ referrerId: userId }, { referredId: userId }] },
    orderBy: { createdAt: 'desc' },
  });
  return NextResponse.json(items);
}


