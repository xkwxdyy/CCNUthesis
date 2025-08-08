import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(req: NextRequest) {
  const token = req.cookies.get('session')?.value;
  if (!token) return NextResponse.json({ user: null });
  const session = await prisma.session.findUnique({ where: { token } });
  if (!session || session.expiresAt < new Date()) return NextResponse.json({ user: null });
  const user = await prisma.user.findUnique({ where: { id: session.userId }, select: { id: true, email: true, name: true, referralCode: true } });
  return NextResponse.json({ user });
}


