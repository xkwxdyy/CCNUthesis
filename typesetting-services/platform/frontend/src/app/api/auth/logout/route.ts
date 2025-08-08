import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(req: NextRequest) {
  const token = req.cookies.get('session')?.value;
  if (token) {
    await prisma.session.deleteMany({ where: { token } });
  }
  const res = NextResponse.json({ ok: true });
  res.cookies.set('session', '', { path: '/', expires: new Date(0) });
  return res;
}


