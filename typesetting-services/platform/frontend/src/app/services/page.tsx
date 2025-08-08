"use client";

import MainLayout from "@/components/layout/MainLayout";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { motion } from "framer-motion";
import { Shield, Sparkles, Wrench, BookOpen } from "lucide-react";

export default function ServicesPage() {
  const services = [
    {
      title: "Word → LaTeX 转换",
      desc: "结构识别、图片表格、公式、参考文献一体化转换",
      icon: Sparkles,
    },
    {
      title: "规范校对",
      desc: "严格对照校规模板，目录、页码、图表规范化",
      icon: Shield,
    },
    {
      title: "个性化定制",
      desc: "附加宏包、排版优化、图表美化与配色",
      icon: Wrench,
    },
    {
      title: "投稿/答辩版本",
      desc: "不同场景导出方案与压缩、去水印处理",
      icon: BookOpen,
    },
  ];

  return (
    <MainLayout>
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="text-center mb-10">
            <h1 className="text-4xl font-bold mb-3 text-white">服务范围</h1>
            <p className="text-white/80">覆盖论文排版的全流程关键环节</p>
          </div>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {services.map((s, i) => (
              <motion.div
                key={s.title}
                initial={{ opacity: 0, y: 10 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.05 }}
              >
                <Card className="h-full">
                  <CardHeader>
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center mb-3">
                      <s.icon className="h-6 w-6 text-primary" />
                    </div>
                    <CardTitle className="text-lg">{s.title}</CardTitle>
                    <CardDescription>{s.desc}</CardDescription>
                  </CardHeader>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>
    </MainLayout>
  );
}


