"use client";

import { motion } from "framer-motion";
import { Card, CardContent } from "@/components/ui/card";
import { Star, Quote, ShieldCheck } from "lucide-react";

const testimonials = [
  {
    name: "计算机学院 · 李同学",
    quote:
      "交付很快，特别是公式和参考文献的细节处理很到位，教务处一次通过。",
  },
  {
    name: "数学学院 · 周同学",
    quote:
      "原来担心Word转LaTeX会乱，这里转换后老师直接认可，省了很多时间。",
  },
  {
    name: "教育信息化 · 王同学",
    quote: "按学校规范逐条检查，避免了返工，售后响应也很快。",
  },
];

export function SocialProof() {
  return (
    <section className="py-16">
      <div className="container mx-auto px-4">
        <div className="text-center mb-10">
          <h2 className="text-3xl md:text-4xl font-bold mb-3">口碑与保障</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            超过 150+ 位同学选择，严格保密，按规范交付
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          {testimonials.map((t, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, y: 10 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.05 }}
            >
              <Card className="h-full">
                <CardContent className="p-6">
                  <Quote className="h-6 w-6 text-primary mb-4" />
                  <p className="text-sm text-muted-foreground mb-4">{t.quote}</p>
                  <div className="text-sm font-medium">{t.name}</div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>

        <div className="mt-8 flex flex-wrap justify-center gap-4 text-sm text-muted-foreground">
          <div className="inline-flex items-center gap-2 px-3 py-2 rounded-full border bg-card/60">
            <Star className="h-4 w-4 text-yellow-500" />
            98% 好评率
          </div>
          <div className="inline-flex items-center gap-2 px-3 py-2 rounded-full border bg-card/60">
            <ShieldCheck className="h-4 w-4 text-green-500" />
            保密与交付保障
          </div>
        </div>
      </div>
    </section>
  );
}

export default SocialProof;


