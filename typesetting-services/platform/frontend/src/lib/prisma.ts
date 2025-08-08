import { PrismaClient } from '@prisma/client';

declare global {
  // eslint-disable-next-line no-var, @typescript-eslint/naming-convention
  var __PRISMA__: PrismaClient | undefined;
}

export const prisma: PrismaClient = globalThis.__PRISMA__ || new PrismaClient({});

if (process.env.NODE_ENV !== 'production') globalThis.__PRISMA__ = prisma;


