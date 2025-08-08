import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(req: NextRequest) {
  try {
    const contentType = req.headers.get('content-type') || '';
    if (!contentType.includes('multipart/form-data')) {
      return NextResponse.json({ error: 'Invalid content type' }, { status: 400 });
    }

    const form = await req.formData();
    const orderId = form.get('orderId')?.toString();
    const description = form.get('description')?.toString() || '';
    const file = form.get('file');

    if (!orderId) return NextResponse.json({ error: 'orderId required' }, { status: 400 });

    let filePath: string | null = null;
    if (file instanceof File) {
      const arrayBuffer = await file.arrayBuffer();
      const buffer = Buffer.from(arrayBuffer);
      const dir = `${process.cwd()}/.uploads/revisions/${orderId}`;
      await (await import('fs/promises')).mkdir(dir, { recursive: true });
      const p = `${dir}/${Date.now()}_${file.name}`;
      await (await import('fs/promises')).writeFile(p, buffer);
      filePath = p;
    }

    const rev = await prisma.revision.create({
      data: { orderId, description, filePath },
    });
    return NextResponse.json(rev);
  } catch (e: unknown) {
    const message = e instanceof Error ? e.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

export async function GET(req: NextRequest) {
  const orderId = req.nextUrl.searchParams.get('orderId');
  if (!orderId) return NextResponse.json({ error: 'orderId required' }, { status: 400 });
  const list = await prisma.revision.findMany({ where: { orderId }, orderBy: { createdAt: 'desc' } });
  return NextResponse.json(list);
}


