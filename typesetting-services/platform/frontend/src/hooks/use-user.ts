"use client";

import { useEffect, useState, useCallback } from "react";
import { usePathname } from "next/navigation";

export function useUser() {
  // 保存当前登录用户的信息，未登录时为 null
  const [user, setUser] = useState<{ id: string; email: string; name?: string; referralCode?: string } | null>(null);
  // 表示是否正在加载用户信息，用于避免闪烁
  const [loading, setLoading] = useState(true);
  // 获取当前路由路径，用于在路由变化时重新获取用户信息
  const pathname = usePathname();

  // 抽取为函数，便于在多处触发重新拉取用户信息
  const fetchUser = useCallback(async () => {
    setLoading(true);
    try {
      const r = await fetch("/api/auth/me", {
        method: "GET",
        // 禁用缓存，确保拿到最新登录态
        cache: "no-store",
      });
      const d = await r.json();
      setUser(d.user || null);
    } catch {
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  // 首次挂载时拉取一次
  useEffect(() => {
    fetchUser();
  }, [fetchUser]);

  // 路由变化时再拉取，解决「登录后跳转但组件未卸载」不更新的问题
  useEffect(() => {
    fetchUser();
  }, [pathname, fetchUser]);

  // 页面重新获得焦点或从后台返回前台时，重新拉取，保证跨标签、返回场景的正确性
  useEffect(() => {
    const onFocus = () => fetchUser();
    const onVisibility = () => {
      if (document.visibilityState === "visible") fetchUser();
    };
    window.addEventListener("focus", onFocus);
    document.addEventListener("visibilitychange", onVisibility);
    return () => {
      window.removeEventListener("focus", onFocus);
      document.removeEventListener("visibilitychange", onVisibility);
    };
  }, [fetchUser]);

  return { user, loading };
}


