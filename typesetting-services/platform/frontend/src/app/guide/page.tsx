"use client";

import MainLayout from "@/components/layout/MainLayout";

export default function GuidePage() {
  const steps = [
    { title: "封面与摘要", desc: "校名、题名、作者、摘要与关键词格式统一" },
    { title: "目录与页码", desc: "目录生成、层级与页码连续性检查" },
    { title: "图表规范", desc: "图题表题、编号与引用对应" },
    { title: "公式与参考文献", desc: "编号规则、引用样式与参考文献格式" },
  ];

  return (
    <MainLayout>
      <section className="py-16">
        <div className="container mx-auto px-4 max-w-3xl">
          <h1 className="text-4xl font-bold mb-6 text-white">自查指南（精简版）</h1>
          <p className="text-white/80 mb-8">按以下清单自查，可减少80%常见返工</p>
          <ol className="list-decimal list-inside space-y-3">
            {steps.map((s) => (
              <li key={s.title}>
                <div className="font-medium">{s.title}</div>
                <div className="text-sm text-muted-foreground">{s.desc}</div>
              </li>
            ))}
          </ol>
        </div>
      </section>
    </MainLayout>
  );
}


