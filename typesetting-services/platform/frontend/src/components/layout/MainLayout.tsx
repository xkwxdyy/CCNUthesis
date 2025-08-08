'use client';

import AppHeader from './Header';
import { motion } from 'framer-motion';
import { Mail, MessageCircle, Github } from 'lucide-react';
import Link from 'next/link';

export default function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-background via-background to-secondary/20">
      <AppHeader />
      
      {/* Main Content with padding for fixed header */}
      <main className="pt-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          {children}
        </motion.div>
      </main>

      {/* Footer */}
      <footer className="mt-20 border-t bg-card/50 backdrop-blur-sm">
        <div className="container mx-auto px-4 py-12">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            {/* Brand */}
            <div className="space-y-4">
              <h3 className="text-lg font-bold">CCNUthesis 代排服务</h3>
              <p className="text-sm text-muted-foreground">
                专业的 LaTeX 论文排版服务
                <br />
                让你专注于内容创作
              </p>
              <div className="flex space-x-4">
                <Link href="https://github.com" className="text-muted-foreground hover:text-primary transition-colors">
                  <Github className="h-5 w-5" />
                </Link>
              </div>
            </div>

            {/* Quick Links */}
            <div className="space-y-4">
              <h4 className="text-sm font-semibold">快速链接</h4>
              <ul className="space-y-2 text-sm">
                <li>
                  <Link href="/services" className="text-muted-foreground hover:text-primary transition-colors">
                    服务介绍
                  </Link>
                </li>
                <li>
                  <Link href="/pricing" className="text-muted-foreground hover:text-primary transition-colors">
                    价格计算
                  </Link>
                </li>
                <li>
                  <Link href="/portfolio" className="text-muted-foreground hover:text-primary transition-colors">
                    案例展示
                  </Link>
                </li>
              </ul>
            </div>

            {/* Resources */}
            <div className="space-y-4">
              <h4 className="text-sm font-semibold">资源</h4>
              <ul className="space-y-2 text-sm">
                <li>
                  <Link href="/faq" className="text-muted-foreground hover:text-primary transition-colors">
                    常见问题
                  </Link>
                </li>
                <li>
                  <Link href="/guide" className="text-muted-foreground hover:text-primary transition-colors">
                    使用指南
                  </Link>
                </li>
                <li>
                  <Link href="/templates" className="text-muted-foreground hover:text-primary transition-colors">
                    模板下载
                  </Link>
                </li>
              </ul>
            </div>

            {/* Contact */}
            <div className="space-y-4">
              <h4 className="text-sm font-semibold">联系方式</h4>
              <ul className="space-y-2 text-sm">
                <li className="flex items-center space-x-2 text-muted-foreground">
                  <MessageCircle className="h-4 w-4" />
                  <span>QQ: 617315571</span>
                </li>
                <li className="flex items-center space-x-2 text-muted-foreground">
                  <MessageCircle className="h-4 w-4" />
                  <span>微信: xiakangwei001</span>
                </li>
                <li className="flex items-center space-x-2 text-muted-foreground">
                  <Mail className="h-4 w-4" />
                  <span>support@ccnuthesis.com</span>
                </li>
              </ul>
            </div>
          </div>

          <div className="mt-8 pt-8 border-t text-center text-sm text-muted-foreground">
            <p>© 2021-{new Date().getFullYear()} CCNUthesis 代排服务. All rights reserved.</p>
            <p className="mt-2">
              Powered by Next.js • Designed with 💙 for Academic Excellence
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}