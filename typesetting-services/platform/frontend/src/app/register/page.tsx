"use client";

import MainLayout from "@/components/layout/MainLayout";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

export const dynamic = "force-dynamic";

export default function RegisterPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const [ref, setRef] = useState('');
  // Read referral code from URL on client to avoid suspense requirement
  // and potential pre-render errors
  useEffect(() => {
    const sp = new URLSearchParams(window.location.search);
    setRef(sp.get('ref') || '');
  }, []);

  const onSubmit = async () => {
    setError(null);
    const res = await fetch("/api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, name, referrerCode: ref }),
    });
    const data = await res.json();
    if (!res.ok) return setError(data.error || "注册失败");
    router.push("/login");
  };

  return (
    <MainLayout>
      <div className="container mx-auto px-4 py-16 max-w-md">
        <h1 className="text-3xl font-bold mb-6">注册</h1>
        <div className="space-y-4">
          <Input placeholder="邮箱" value={email} onChange={(e) => setEmail(e.target.value)} />
          <Input placeholder="姓名（可选）" value={name} onChange={(e) => setName(e.target.value)} />
          <Input type="password" placeholder="密码" value={password} onChange={(e) => setPassword(e.target.value)} />
          {error && <div className="text-sm text-red-500">{error}</div>}
          <Button onClick={onSubmit}>注册</Button>
        </div>
      </div>
    </MainLayout>
  );
}


