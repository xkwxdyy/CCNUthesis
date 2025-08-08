"use client";

import MainLayout from "@/components/layout/MainLayout";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { QRCodeCanvas } from 'qrcode.react';

interface OrderDetail {
  id: string;
  status: string;
  totalPrice: number;
  pageCount: number;
  formulaCount: number;
  tableCount: number;
  refCount: number;
  createdAt: string;
  user: { id: string; email: string; name?: string | null };
  revisions: { id: string; description: string; filePath?: string | null; status: string; createdAt: string }[];
}

export default function OrderDetailPage() {
  const params = useParams<{ id: string }>();
  const [order, setOrder] = useState<OrderDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [polling, setPolling] = useState(false);

  useEffect(() => {
    const id = params?.id;
    if (!id) return;
    fetch(`/api/orders/${id}`)
      .then((r) => r.json())
      .then((d) => setOrder(d))
      .finally(() => setLoading(false));
  }, [params?.id]);

  // 简单轮询支付状态（30s内每3s一次）
  const pollStatus = async () => {
    if (polling || !order) return;
    setPolling(true);
    const start = Date.now();
    const id = order.id;
    while (Date.now() - start < 30000) {
      // 等待3秒
      // eslint-disable-next-line no-await-in-loop
      await new Promise((r) => setTimeout(r, 3000));
      // eslint-disable-next-line no-await-in-loop
      const fresh = await fetch(`/api/orders/${id}`).then((r) => r.json());
      setOrder(fresh);
      if (fresh.depositPaid && fresh.finalPaid) break;
    }
    setPolling(false);
  };

  const [desc, setDesc] = useState("");
  const [file, setFile] = useState<File | null>(null);

  const submitRevision = async () => {
    if (!order) return;
    const form = new FormData();
    form.append("orderId", order.id);
    form.append("description", desc);
    if (file) form.append("file", file);
    const res = await fetch("/api/revisions", { method: "POST", body: form });
    if (res.ok) {
      const updated = await fetch(`/api/orders/${order.id}`).then((r) => r.json());
      setOrder(updated);
      setDesc("");
      setFile(null);
    }
  };

  const [wechatCodeUrl, setWechatCodeUrl] = useState<string | null>(null);

  const pay = async (type: 'deposit' | 'final', method: 'alipay' | 'wechat' | 'mock') => {
    if (!order) return;
    const amount = type === 'deposit' ? Math.round(order.totalPrice * 0.3) : Math.round(order.totalPrice - order.totalPrice * 0.3);
    const res = await fetch('/api/payments/create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ orderId: order.id, amount, method, type }),
    });
    const data = await res.json();
    if (res.ok) {
      if (method === 'wechat' && data.payUrl && data.payUrl.startsWith('weixin://wxpay/')) {
        // 部分网关返回 weixin:// 链接，不利于桌面扫码；实际生产建议服务端将 code_url 返回
        window.location.href = data.payUrl;
      } else if (method === 'wechat' && data.payUrl && !data.payUrl.startsWith('http')) {
        // code_url 可能是字符串，前端用二维码渲染
        setWechatCodeUrl(data.payUrl);
      } else {
        window.open(data.payUrl, '_blank');
      }
    } else {
      alert('下单支付失败: ' + (data.error || '未知错误'));
    }
  };

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-12">
        {loading && <div>加载中...</div>}
        {!loading && order && (
          <div className="grid md:grid-cols-3 gap-6">
            <Card className="md:col-span-2">
              <CardHeader>
                <CardTitle>订单 #{order.id.slice(0, 8)}</CardTitle>
                <CardDescription>
                  <Badge>{order.status}</Badge>
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                  <div>
                    <div className="text-muted-foreground">预估总价</div>
                    <div className="text-xl font-bold">¥{order.totalPrice}</div>
                  </div>
                  <div>
                    <div className="text-muted-foreground">页数</div>
                    <div className="font-medium">{order.pageCount}</div>
                  </div>
                  <div>
                    <div className="text-muted-foreground">公式</div>
                    <div className="font-medium">{order.formulaCount}</div>
                  </div>
                  <div>
                    <div className="text-muted-foreground">表格</div>
                    <div className="font-medium">{order.tableCount}</div>
                  </div>
                </div>

                <div className="mt-8">
                  <h3 className="text-lg font-semibold mb-3">改稿记录</h3>
                  <div className="space-y-3">
                    {order.revisions.map((r) => (
                      <div key={r.id} className="rounded-lg border p-3 text-sm flex items-center justify-between">
                        <div>
                          <div className="font-medium">{r.description || "无描述"}</div>
                          <div className="text-muted-foreground">{new Date(r.createdAt).toLocaleString()} • {r.status}</div>
                        </div>
                        {r.filePath && (
                          <a href="#" className="text-primary text-xs">附件</a>
                        )}
                      </div>
                    ))}
                  </div>
                </div>

                <div className="mt-8">
                  <h3 className="text-lg font-semibold mb-3">追加修改</h3>
                  <div className="grid gap-3 md:grid-cols-3">
                    <input className="md:col-span-2 rounded-md border bg-background px-3 py-2 text-sm" placeholder="说明内容" value={desc} onChange={(e) => setDesc(e.target.value)} />
                    <input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} />
                  </div>
                  <div className="mt-3">
                    <Button onClick={submitRevision}>提交</Button>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>联系人</CardTitle>
                <CardDescription>{order.user?.name || order.user?.email}</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="text-sm text-muted-foreground">
                  创建时间：{new Date(order.createdAt).toLocaleString()}
                </div>
                <div className="mt-6 space-y-3">
                  <div className="text-sm font-medium">支付</div>
                  <div className="grid grid-cols-2 gap-2">
                    <Button onClick={() => pay('deposit', 'alipay')}>支付宝订金</Button>
                    <Button onClick={() => pay('deposit', 'wechat')}>微信订金</Button>
                    <Button variant="outline" onClick={() => pay('final', 'alipay')}>支付宝尾款</Button>
                    <Button variant="outline" onClick={() => pay('final', 'wechat')}>微信尾款</Button>
                  </div>
                  <div className="text-xs text-muted-foreground">若未配置支付，将使用模拟链接。</div>
                  <div className="mt-2">
                    <Button variant="ghost" onClick={pollStatus} disabled={polling}>刷新支付状态</Button>
                  </div>
                  {wechatCodeUrl && (
                    <div className="mt-4 flex flex-col items-center gap-2">
                      <QRCodeCanvas value={wechatCodeUrl} size={180} />
                      <div className="text-xs text-muted-foreground">使用微信扫码完成支付</div>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </MainLayout>
  );
}


