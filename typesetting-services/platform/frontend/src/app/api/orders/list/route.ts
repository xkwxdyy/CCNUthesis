import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(req: NextRequest) {
  const userId = req.nextUrl.searchParams.get('userId');
  if (!userId) return NextResponse.json({ error: 'userId required' }, { status: 400 });
  const orders = await prisma.order.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
    select: {
      id: true,
      status: true,
      totalPrice: true,
      pageCount: true,
      formulaCount: true,
      tableCount: true,
      refCount: true,
      createdAt: true,
      depositPaid: true,
      finalPaid: true,
    },
  });
  return NextResponse.json(orders);
}


