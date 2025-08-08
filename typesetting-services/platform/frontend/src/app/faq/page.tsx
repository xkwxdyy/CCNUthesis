"use client";

import MainLayout from "@/components/layout/MainLayout";
import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { ChevronDown } from "lucide-react";

const qa = [
  {
    q: "需要多长时间交付？",
    a: "常规3-5天，加急最快3天，可分批交付以便先行审阅。",
  },
  {
    q: "是否保密？",
    a: "全程加密传输，项目完成后按需删除存档，签署保密协议。",
  },
  {
    q: "支持哪些格式？",
    a: "Word、Markdown、LaTeX、图片（OCR）等，具体以文档结构而定。",
  },
];

export default function FAQPage() {
  const [open, setOpen] = useState<number | null>(0);
  return (
    <MainLayout>
      <section className="py-16">
        <div className="container mx-auto px-4 max-w-3xl">
          <div className="text-center mb-10">
            <h1 className="text-4xl font-bold mb-3">常见问题</h1>
            <p className="text-muted-foreground">关于时效、保密、格式与售后</p>
          </div>
          <div className="space-y-3">
            {qa.map((item, i) => {
              const isOpen = open === i;
              return (
                <div key={i} className="border rounded-xl overflow-hidden">
                  <button
                    className="w-full flex items-center justify-between p-4 text-left"
                    onClick={() => setOpen(isOpen ? null : i)}
                  >
                    <span className="font-medium">{item.q}</span>
                    <ChevronDown className={`h-4 w-4 transition-transform ${isOpen ? "rotate-180" : ""}`} />
                  </button>
                  <AnimatePresence initial={false}>
                    {isOpen && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: "auto", opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        className="px-4 pb-4 text-sm text-muted-foreground"
                      >
                        {item.a}
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              );
            })}
          </div>
        </div>
      </section>
    </MainLayout>
  );
}


