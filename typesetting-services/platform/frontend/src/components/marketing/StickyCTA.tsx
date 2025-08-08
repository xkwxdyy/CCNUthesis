"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Rocket, MessageCircle } from "lucide-react";

export default function StickyCTA() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const onScroll = () => {
      setVisible(window.scrollY > 300);
    };
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <div
      className={`fixed bottom-5 left-0 right-0 z-50 transition-transform ${
        visible ? "translate-y-0" : "translate-y-24"
      }`}
    >
      <div className="container mx-auto px-4">
        <div className="mx-auto max-w-3xl rounded-2xl border bg-card/90 backdrop-blur p-3 shadow-lg flex items-center justify-between gap-3">
          <div className="text-sm text-muted-foreground">
            不确定从哪开始？试试 AI 即时报价，或联系人工顾问
          </div>
          <div className="flex gap-2">
            <Link href="/pricing">
              <Button size="sm">
                <Rocket className="h-4 w-4 mr-1" /> 即时报价
              </Button>
            </Link>
            <Link href="/pricing">
              <Button size="sm" variant="outline">
                <MessageCircle className="h-4 w-4 mr-1" /> 咨询
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}


