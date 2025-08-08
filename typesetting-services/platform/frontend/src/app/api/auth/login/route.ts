import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import bcrypt from 'bcryptjs';
import { randomUUID } from 'crypto';

export async function POST(req: NextRequest) {
  try {
    const { email, password } = await req.json();
    if (!email || !password) return NextResponse.json({ error: '缺少邮箱或密码' }, { status: 400 });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return NextResponse.json({ error: '账号或密码错误' }, { status: 400 });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return NextResponse.json({ error: '账号或密码错误' }, { status: 400 });

    const token = randomUUID();
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 7);
    await prisma.session.create({ data: { userId: user.id, token, expiresAt } });

    const res = NextResponse.json({ id: user.id, email: user.email, name: user.name });
    res.cookies.set('session', token, { httpOnly: true, sameSite: 'lax', path: '/', expires: expiresAt });
    return res;
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}


