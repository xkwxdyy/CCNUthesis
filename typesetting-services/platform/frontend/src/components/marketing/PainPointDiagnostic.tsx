"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import { HelpCircle, Timer, FileWarning, FileText, Zap, ArrowRight } from "lucide-react";

type PainPointKey = "spec" | "convert" | "format" | "deadline" | "budget";

interface PainPointOption {
  key: PainPointKey;
  title: string;
  desc: string;
  icon: React.ComponentType<{ className?: string }>;
  color: string;
}

const painPoints: PainPointOption[] = [
  {
    key: "spec",
    title: "不熟悉校规模板",
    desc: "不知道哪里不合规，担心返工",
    icon: HelpCircle,
    color: "from-blue-500 to-cyan-400",
  },
  {
    key: "convert",
    title: "Word 转 LaTeX 困难",
    desc: "图片、公式、参考文献乱套",
    icon: FileWarning,
    color: "from-purple-500 to-pink-500",
  },
  {
    key: "format",
    title: "格式检查耗时",
    desc: "标题、目录、页码反复调",
    icon: FileText,
    color: "from-emerald-500 to-teal-400",
  },
  {
    key: "deadline",
    title: "时间很紧",
    desc: "临近提交，需要加急",
    icon: Timer,
    color: "from-orange-500 to-amber-400",
  },
  {
    key: "budget",
    title: "预算拿不准",
    desc: "先想知道大概多少钱",
    icon: Zap,
    color: "from-yellow-500 to-rose-400",
  },
];

const recommendations: Record<
  PainPointKey,
  { title: string; desc: string; actions: { label: string; href: string }[] }
> = {
  spec: {
    title: "三步自查 + 免费模板",
    desc: "按指南自查80%常见错误，下载官方模板立即套用。",
    actions: [
      { label: "查看指南", href: "/guide" },
      { label: "模板下载", href: "/templates" },
    ],
  },
  convert: {
    title: "一键转换 + 人工兜底",
    desc: "先由系统转换，难点由专家校对，保证准确。",
    actions: [
      { label: "去定价上传", href: "/pricing" },
      { label: "了解服务", href: "/services" },
    ],
  },
  format: {
    title: "规范对照清单",
    desc: "提供逐条对照清单，避免遗漏细节。",
    actions: [
      { label: "常见问题", href: "/faq" },
      { label: "查看指南", href: "/guide" },
    ],
  },
  deadline: {
    title: "加急绿色通道",
    desc: "最快三天交付，支持先排版后微调。",
    actions: [
      { label: "加急下单", href: "/pricing" },
      { label: "联系客服", href: "/pricing" },
    ],
  },
  budget: {
    title: "AI 即时报价",
    desc: "上传文档或手动输入数据，即刻得到估价。",
    actions: [
      { label: "立即估价", href: "/pricing" },
      { label: "服务范围", href: "/services" },
    ],
  },
};

export function PainPointDiagnostic() {
  const [selected, setSelected] = useState<PainPointKey | null>(null);

  return (
    <section className="py-16">
      <div className="container mx-auto px-4">
        <div className="text-center mb-10">
          <h2 className="text-3xl md:text-4xl font-bold mb-3">你的难点，我们来解</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            选择最贴近你当前状况的一项，获取定制化解决路线
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4 mb-8">
          {painPoints.map((p) => {
            const Icon = p.icon;
            const isActive = selected === p.key;
            return (
              <button
                key={p.key}
                onClick={() => setSelected(p.key)}
                className={`group rounded-xl border bg-card/60 hover:bg-card transition-all p-4 text-left ${
                  isActive ? "border-primary/40 shadow" : ""
                }`}
              >
                <div
                  className={`w-10 h-10 rounded-lg bg-gradient-to-br ${p.color} opacity-90 flex items-center justify-center mb-3`}
                >
                  <Icon className="h-5 w-5 text-white" />
                </div>
                <div className="font-semibold">{p.title}</div>
                <div className="text-sm text-muted-foreground">{p.desc}</div>
              </button>
            );
          })}
        </div>

        <AnimatePresence mode="wait">
          {selected && (
            <motion.div
              key={selected}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 10 }}
              transition={{ duration: 0.25 }}
            >
              <Card className="border-primary/20">
                <CardHeader className="flex flex-row items-center justify-between">
                  <div>
                    <CardTitle>{recommendations[selected].title}</CardTitle>
                    <CardDescription>{recommendations[selected].desc}</CardDescription>
                  </div>
                  <Badge variant="secondary">智能建议</Badge>
                </CardHeader>
                <CardContent>
                  <div className="flex flex-col sm:flex-row gap-3">
                    {recommendations[selected].actions.map((a) => (
                      <Link key={a.href} href={a.href}>
                        <Button>
                          {a.label}
                          <ArrowRight className="h-4 w-4 ml-2" />
                        </Button>
                      </Link>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </section>
  );
}

export default PainPointDiagnostic;


