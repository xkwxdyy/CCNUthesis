"use client";

import MainLayout from "@/components/layout/MainLayout";
import { useUser } from "@/hooks/use-user";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { useEffect, useState } from "react";

interface OrderItem {
  id: string;
  status: string;
  totalPrice: number;
  pageCount: number;
  formulaCount: number;
  tableCount: number;
  refCount: number;
  createdAt: string;
  depositPaid: boolean;
  finalPaid: boolean;
}

export default function OrdersPage() {
  const { user } = useUser();
  const [orders, setOrders] = useState<OrderItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;
    fetch(`/api/orders/list?userId=${user.id}`)
      .then((r) => r.json())
      .then(setOrders)
      .finally(() => setLoading(false));
  }, [user]);

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-6">我的订单</h1>
        {(!user || loading) && <div>加载中...</div>}
        {user && !loading && (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {orders.map((o) => (
              <Link key={o.id} href={`/orders/${o.id}`}>
                <Card className="hover:shadow-md transition-shadow">
                  <CardHeader>
                    <CardTitle className="text-lg">订单 #{o.id.slice(0, 8)}</CardTitle>
                    <CardDescription className="flex items-center gap-2">
                      <Badge>{o.status}</Badge>
                      {o.depositPaid && <Badge variant="secondary">已付订金</Badge>}
                      {o.finalPaid && <Badge variant="secondary">已付尾款</Badge>}
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="text-sm text-muted-foreground">
                      创建：{new Date(o.createdAt).toLocaleString()}
                    </div>
                    <div className="mt-2 text-sm grid grid-cols-2 gap-2">
                      <div>总价：¥{o.totalPrice}</div>
                      <div>页数：{o.pageCount}</div>
                      <div>公式：{o.formulaCount}</div>
                      <div>表格：{o.tableCount}</div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
            {orders.length === 0 && (
              <Card>
                <CardHeader>
                  <CardTitle>暂无订单</CardTitle>
                  <CardDescription>去试试 AI 即时报价，快速创建订单</CardDescription>
                </CardHeader>
                <CardContent>
                  <Link href="/pricing" className="text-primary">前往定价</Link>
                </CardContent>
              </Card>
            )}
          </div>
        )}
      </div>
    </MainLayout>
  );
}


