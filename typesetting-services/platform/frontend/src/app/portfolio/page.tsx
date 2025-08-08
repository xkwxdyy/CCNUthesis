"use client";

import MainLayout from "@/components/layout/MainLayout";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { motion } from "framer-motion";
import { FileText, Image as ImageIcon } from "lucide-react";

export default function PortfolioPage() {
  const cases = [
    {
      title: "教育硕士论文",
      desc: "Word 转 LaTeX + 规范校对，3天交付",
    },
    {
      title: "理工科开题报告",
      desc: "复杂公式与图表排版，分章节交付",
    },
    {
      title: "人文社科毕业论文",
      desc: "批注对照修改，提交前快速迭代",
    },
  ];

  return (
    <MainLayout>
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="text-center mb-10">
            <h1 className="text-4xl font-bold mb-3">案例展示</h1>
            <p className="text-muted-foreground">展示典型场景与交付效果</p>
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            {cases.map((c, i) => (
              <motion.div
                key={c.title}
                initial={{ opacity: 0, y: 10 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.05 }}
              >
                <Card className="h-full">
                  <CardHeader>
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center mb-3">
                      <FileText className="h-6 w-6 text-primary" />
                    </div>
                    <CardTitle className="text-lg">{c.title}</CardTitle>
                    <CardDescription>{c.desc}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="aspect-[16/9] w-full rounded-lg border border-dashed flex items-center justify-center text-muted-foreground">
                      <ImageIcon className="h-5 w-5 mr-2" /> 预览占位
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>
    </MainLayout>
  );
}


