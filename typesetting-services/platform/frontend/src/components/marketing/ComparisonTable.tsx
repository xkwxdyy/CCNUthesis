"use client";

import { Card, CardContent } from "@/components/ui/card";

const rows = [
  { label: "模板匹配", us: "校级模板100%覆盖", others: "部分覆盖/需要自配" },
  { label: "转换准确率", us: "公式/图表高准确率", others: "易错位/丢样式" },
  { label: "交付时间", us: "最快3天", others: "不确定" },
  { label: "售后修改", us: "提交前不限次细调", others: "限制次数或额外收费" },
  { label: "保密与存档", us: "全程加密/分级访问", others: "无明确保障" },
];

export function ComparisonTable() {
  return (
    <section className="py-16">
      <div className="container mx-auto px-4">
        <div className="text-center mb-8">
          <h2 className="text-3xl md:text-4xl font-bold mb-3">为什么更适合你</h2>
          <p className="text-muted-foreground">与常规代排/自排的直观对比</p>
        </div>
        <Card>
          <CardContent className="p-0 overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b">
                  <th className="text-left p-4">维度</th>
                  <th className="text-left p-4">本平台</th>
                  <th className="text-left p-4">常规方案</th>
                </tr>
              </thead>
              <tbody>
                {rows.map((r, i) => (
                  <tr key={r.label} className={i % 2 ? "bg-muted/30" : ""}>
                    <td className="p-4 font-medium">{r.label}</td>
                    <td className="p-4 text-primary">{r.us}</td>
                    <td className="p-4 text-muted-foreground">{r.others}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </CardContent>
        </Card>
      </div>
    </section>
  );
}

export default ComparisonTable;


