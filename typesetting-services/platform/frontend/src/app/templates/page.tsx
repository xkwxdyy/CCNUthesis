"use client";

import MainLayout from "@/components/layout/MainLayout";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Download } from "lucide-react";

export default function TemplatesPage() {
  const files = [
    { name: "CCNUthesis LaTeX 模板（最新）", size: "~2MB", href: "/file.svg" },
    { name: "示例文档与参考样式", size: "~1MB", href: "/file.svg" },
  ];
  return (
    <MainLayout>
      <section className="py-16">
        <div className="container mx-auto px-4 max-w-3xl">
          <h1 className="text-4xl font-bold mb-6">模板下载</h1>
          <div className="space-y-4">
            {files.map((f) => (
              <Card key={f.name}>
                <CardHeader>
                  <CardTitle className="text-lg">{f.name}</CardTitle>
                  <CardDescription>{f.size}</CardDescription>
                </CardHeader>
                <CardContent>
                  <a href={f.href} download>
                    <Button>
                      <Download className="h-4 w-4 mr-2" /> 下载
                    </Button>
                  </a>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>
    </MainLayout>
  );
}


