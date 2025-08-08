import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import bcrypt from 'bcryptjs';

export async function POST(req: NextRequest) {
  try {
    const { email, password, name } = await req.json();
    if (!email || !password) return NextResponse.json({ error: '缺少邮箱或密码' }, { status: 400 });

    const hashed = await bcrypt.hash(password, 10);
    const referralCode = Math.random().toString(36).slice(2, 8);

    const user = await prisma.user.create({
      data: { email, password: hashed, name, referralCode },
    });
    return NextResponse.json({ id: user.id, email: user.email, name: user.name, referralCode: user.referralCode });
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}


