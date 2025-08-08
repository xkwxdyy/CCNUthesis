import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "CCNUthesis 代排服务平台",
  description: "专业的 LaTeX 论文排版服务，让你专注于内容创作",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN">
      <body className="antialiased" suppressHydrationWarning>
        {children}
      </body>
    </html>
  );
}
