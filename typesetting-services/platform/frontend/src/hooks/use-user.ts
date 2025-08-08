"use client";

import { useEffect, useState } from "react";

export function useUser() {
  const [user, setUser] = useState<{ id: string; email: string; name?: string } | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    fetch("/api/auth/me")
      .then((r) => r.json())
      .then((d) => {
        if (!mounted) return;
        setUser(d.user || null);
        setLoading(false);
      })
      .catch(() => setLoading(false));
    return () => {
      mounted = false;
    };
  }, []);

  return { user, loading };
}


