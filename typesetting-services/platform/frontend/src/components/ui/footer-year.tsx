'use client';

import { useState, useEffect } from 'react';

export function FooterYear() {
  const [year, setYear] = useState(2024);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setYear(new Date().getFullYear());
  }, []);

  // 在客户端加载前显示静态年份，避免 hydration mismatch
  if (!mounted) {
    return <span>2024</span>;
  }

  return <span>{year}</span>;
}