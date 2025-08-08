"use client";

import MainLayout from "@/components/layout/MainLayout";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  const onSubmit = async () => {
    setError(null);
    const res = await fetch("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();
    if (!res.ok) return setError(data.error || "登录失败");
    router.push("/pricing");
  };

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-16 max-w-md">
        <h1 className="text-3xl font-bold mb-6">登录</h1>
        <div className="space-y-4">
          <Input placeholder="邮箱" value={email} onChange={(e) => setEmail(e.target.value)} />
          <Input type="password" placeholder="密码" value={password} onChange={(e) => setPassword(e.target.value)} />
          {error && <div className="text-sm text-red-500">{error}</div>}
          <Button onClick={onSubmit}>登录</Button>
        </div>
      </div>
    </MainLayout>
  );
}


