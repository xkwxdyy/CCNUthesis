import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const {
      userId,
      pageCount = 0,
      formulaCount = 0,
      tableCount = 0,
      refCount = 0,
      totalPrice = 0,
      deadline,
    } = body || {};

    if (!userId) return NextResponse.json({ error: 'userId required' }, { status: 400 });

    const order = await prisma.order.create({
      data: {
        userId,
        totalPrice,
        pageCount,
        formulaCount,
        tableCount,
        refCount,
        deadline: deadline ? new Date(deadline) : null,
      },
    });

    return NextResponse.json(order);
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

export async function GET(req: NextRequest) {
  const userId = req.nextUrl.searchParams.get('userId');
  if (!userId) return NextResponse.json({ error: 'userId required' }, { status: 400 });
  const orders = await prisma.order.findMany({ where: { userId }, orderBy: { createdAt: 'desc' } });
  return NextResponse.json(orders);
}


