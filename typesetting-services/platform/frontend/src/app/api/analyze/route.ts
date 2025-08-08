import { NextRequest, NextResponse } from 'next/server';
import { spawn } from 'child_process';
import { randomUUID } from 'crypto';
import { promises as fs } from 'fs';
import path from 'path';

export const runtime = 'nodejs';

export async function POST(req: NextRequest) {
  try {
    const contentType = req.headers.get('content-type') || '';
    if (!contentType.includes('multipart/form-data')) {
      return NextResponse.json({ error: 'Invalid content type' }, { status: 400 });
    }

    const formData = await req.formData();
    const file = formData.get('file');
    if (!(file instanceof File)) {
      return NextResponse.json({ error: 'No file uploaded' }, { status: 400 });
    }

    // Save to tmp
    const arrayBuffer = await file.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);
    const tmpDir = path.join(process.cwd(), '.tmp_uploads');
    await fs.mkdir(tmpDir, { recursive: true });
    const tmpPath = path.join(tmpDir, `${randomUUID()}.docx`);
    await fs.writeFile(tmpPath, buffer);

    // Call python analyzer
    const analyzerPath = path.resolve(process.cwd(), '../../processor/word_analyzer.py');
    const py = spawn('python3', [analyzerPath, tmpPath], { cwd: path.dirname(analyzerPath) });

    let stdout = '';
    let stderr = '';
    py.stdout.on('data', (d) => (stdout += d.toString()));
    py.stderr.on('data', (d) => (stderr += d.toString()));

    const exitCode: number = await new Promise((resolve) => {
      py.on('close', (code) => resolve(code ?? 1));
    });

    await fs.unlink(tmpPath).catch(() => {});

    if (exitCode !== 0) {
      return NextResponse.json({ error: 'Analyzer failed', detail: stderr.trim() }, { status: 500 });
    }

    const result = JSON.parse(stdout);
    return NextResponse.json(result);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Internal error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}


