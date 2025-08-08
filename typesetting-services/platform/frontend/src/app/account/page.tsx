"use client";

import MainLayout from "@/components/layout/MainLayout";
import { useUser } from "@/hooks/use-user";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";

export default function AccountPage() {
  const { user } = useUser();
  type Referral = { id: string; referredId: string; status: string; rewardAmount: number; orderId?: string | null };
  const [referrals, setReferrals] = useState<Referral[]>([]);

  useEffect(() => {
    if (!user) return;
    fetch(`/api/referrals?userId=${user.id}`)
      .then((r) => r.json())
      .then(setReferrals)
      .catch(() => setReferrals([]));
  }, [user]);

  const link = typeof window !== 'undefined' && user ? `${window.location.origin}/register?ref=${user.referralCode}` : '';

  const copy = async () => {
    if (link) await navigator.clipboard.writeText(link);
    alert('已复制邀请链接');
  };

  const logout = async () => {
    await fetch('/api/auth/logout', { method: 'POST' });
    window.location.href = '/';
  };

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-12">
        {!user ? (
          <div>请先登录</div>
        ) : (
          <div className="grid md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>账号信息</CardTitle>
                <CardDescription>{user.email}</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="text-sm text-muted-foreground mb-3">邀请码：{user.referralCode}</div>
                <div className="flex gap-2">
                  <Button onClick={copy}>复制邀请链接</Button>
                  <Button variant="outline" onClick={logout}>退出登录</Button>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>邀请记录</CardTitle>
                <CardDescription>成功下单后将自动发放奖励</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-2 text-sm">
                  {referrals.length === 0 && <div className="text-muted-foreground">暂无记录</div>}
                  {referrals.map((r) => (
                    <div key={r.id} className="rounded-md border p-3 flex items-center justify-between">
                      <div>
                        <div className="font-medium">{r.referredId.slice(0, 8)}</div>
                        <div className="text-muted-foreground">状态：{r.status} • ¥{r.rewardAmount}</div>
                      </div>
                      {r.orderId && <div className="text-xs text-muted-foreground">订单：{r.orderId.slice(0, 6)}</div>}
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </MainLayout>
  );
}


