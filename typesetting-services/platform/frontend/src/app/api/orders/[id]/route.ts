import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(
  _req: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  const { id } = await context.params;
  if (!id) return NextResponse.json({ error: 'id required' }, { status: 400 });

  const order = await prisma.order.findUnique({
    where: { id },
    include: {
      files: true,
      revisions: { orderBy: { createdAt: 'desc' } },
      payments: true,
      referral: true,
      user: { select: { id: true, email: true, name: true } },
    },
  });

  if (!order) return NextResponse.json({ error: 'not found' }, { status: 404 });
  return NextResponse.json(order);
}


