'use client';

import { motion } from 'framer-motion';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import MainLayout from '@/components/layout/MainLayout';
import PainPointDiagnostic from '@/components/marketing/PainPointDiagnostic';
import SocialProof from '@/components/marketing/SocialProof';
import ComparisonTable from '@/components/marketing/ComparisonTable';
import StickyCTA from '@/components/marketing/StickyCTA';
import Link from 'next/link';
import { 
  ArrowRight, 
  FileText, 
  Zap, 
  Shield, 
  Users, 
  Upload,
  CheckCircle,
  TrendingUp,
  Clock,
  Award,
  Sparkles
} from 'lucide-react';

const fadeInUp = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  transition: { duration: 0.5 }
};

const stagger = {
  animate: {
    transition: {
      staggerChildren: 0.1
    }
  }
};

export default function Home() {
  const features = [
    {
      icon: Upload,
      title: '智能文档分析',
      description: '自动识别Word文档结构，精准统计页数、公式、表格等元素',
      color: 'text-blue-500',
      bgColor: 'bg-blue-50 dark:bg-blue-950'
    },
    {
      icon: Zap,
      title: '快速转换',
      description: 'Word → Markdown → LaTeX 全自动转换流程，高效准确',
      color: 'text-purple-500',
      bgColor: 'bg-purple-50 dark:bg-purple-950'
    },
    {
      icon: Shield,
      title: '质量保证',
      description: '严格遵循华师论文规范，多重质量检查确保排版完美',
      color: 'text-green-500',
      bgColor: 'bg-green-50 dark:bg-green-950'
    },
    {
      icon: Users,
      title: '推广返利',
      description: '邀请好友成功下单，双方均可获得30元优惠',
      color: 'text-orange-500',
      bgColor: 'bg-orange-50 dark:bg-orange-950'
    }
  ];

  const stats = [
    { label: '累计服务', value: '150+', unit: '位客户' },
    { label: '平均完成', value: '3', unit: '天交付' },
    { label: '客户满意', value: '98%', unit: '好评率' },
    { label: '价格区间', value: '200-500', unit: '元/份' }
  ];

  const workflow = [
    { step: 1, title: '上传文档', description: '提供Word文档和基本信息' },
    { step: 2, title: '智能分析', description: '系统自动分析文档结构和定价' },
    { step: 3, title: '确认订单', description: '查看报价，支付订金开始排版' },
    { step: 4, title: '交付成果', description: '验收LaTeX成品，支付尾款' }
  ];

  return (
    <MainLayout>
      <StickyCTA />
      {/* Hero Section */}
      <section className="relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-primary/10 via-transparent to-secondary/10" />
        <div className="container mx-auto px-4 py-20 md:py-36">
          <motion.div 
            className="max-w-4xl mx-auto text-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <Badge className="mb-4 glass border-primary/30" variant="secondary">
              <Sparkles className="h-3 w-3 mr-1" />
              华中师范大学官方模板作者
            </Badge>
            
            <h1 className="text-5xl md:text-7xl font-extrabold mb-6 bg-gradient-to-r from-purple-400 via-blue-400 to-cyan-400 bg-clip-text text-transparent">
              专业 LaTeX 论文排版服务
            </h1>
            
            <p className="text-xl text-gray-300/90 mb-10 max-w-2xl mx-auto">
              将你的 Word 文档转换为精美的 LaTeX 排版，
              <br />
              让你专注于内容创作，我们负责完美呈现
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link href="/pricing">
                <Button size="xl" className="group shadow-lg shadow-primary/20">
                  立即体验
                  <ArrowRight className="ml-2 h-5 w-5 transition-transform group-hover:translate-x-1" />
                </Button>
              </Link>
              <Link href="/services">
                <Button size="xl" variant="outline" className="backdrop-blur border-white/20">
                  了解服务
                </Button>
              </Link>
            </div>

            {/* Trust Indicators */}
            <div className="mt-12 flex flex-wrap justify-center gap-6 text-sm text-muted-foreground">
              <div className="flex items-center gap-2">
                <CheckCircle className="h-4 w-4 text-green-500" />
                <span>2021年起服务至今</span>
              </div>
              <div className="flex items-center gap-2">
                <Award className="h-4 w-4 text-yellow-500" />
                <span>官方模板维护者</span>
              </div>
              <div className="flex items-center gap-2">
                <Users className="h-4 w-4 text-blue-500" />
                <span>150+ 满意客户</span>
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-card/50 glass">
        <div className="container mx-auto px-4">
          <motion.div 
            className="grid grid-cols-2 md:grid-cols-4 gap-6"
            variants={stagger}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
          >
            {stats.map((stat, index) => (
              <motion.div
                key={index}
                variants={fadeInUp}
                className="text-center"
              >
                <div className="text-3xl md:text-4xl font-bold text-primary">
                  {stat.value}
                </div>
                <div className="text-sm text-muted-foreground mt-1">
                  {stat.unit}
                </div>
                <div className="text-xs text-muted-foreground mt-2">
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Pain Point Diagnostic */}
      <PainPointDiagnostic />

      {/* Features Grid */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <motion.div 
            className="text-center mb-12"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              为什么选择我们
            </h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              专业、高效、可靠的论文排版服务，让你的学术成果完美呈现
            </p>
          </motion.div>

          <motion.div 
            className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
            variants={stagger}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
          >
            {features.map((feature, index) => (
              <motion.div key={index} variants={fadeInUp}>
                <Card className="h-full hover:shadow-lg transition-shadow">
                  <CardHeader>
                    <div className={`w-12 h-12 rounded-lg ${feature.bgColor} flex items-center justify-center mb-4`}>
                      <feature.icon className={`h-6 w-6 ${feature.color}`} />
                    </div>
                    <CardTitle className="text-lg">{feature.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription>{feature.description}</CardDescription>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Workflow Section */}
      <section className="py-20 bg-secondary/30">
        <div className="container mx-auto px-4">
          <motion.div 
            className="text-center mb-12"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              服务流程
            </h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              简单四步，轻松获得专业排版
            </p>
          </motion.div>

          <motion.div 
            className="max-w-4xl mx-auto"
            variants={stagger}
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
          >
            {workflow.map((item, index) => (
              <motion.div
                key={index}
                variants={fadeInUp}
                className="flex items-center mb-8 last:mb-0"
              >
                <div className="flex-shrink-0 w-12 h-12 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold">
                  {item.step}
                </div>
                <div className="ml-4 flex-1">
                  <h3 className="font-semibold mb-1">{item.title}</h3>
                  <p className="text-sm text-muted-foreground">{item.description}</p>
                </div>
                {index < workflow.length - 1 && (
                  <div className="hidden md:block ml-4">
                    <ArrowRight className="h-5 w-5 text-muted-foreground" />
                  </div>
                )}
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      {/* Social Proof */}
      <SocialProof />

      {/* Comparison Table */}
      <ComparisonTable />

      {/* CTA Section */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <motion.div 
            className="max-w-3xl mx-auto text-center"
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            <Card className="bg-gradient-to-br from-primary/10 via-primary/5 to-transparent border-primary/20">
              <CardHeader>
                <CardTitle className="text-3xl mb-4">
                  准备好开始了吗？
                </CardTitle>
                <CardDescription className="text-base">
                  上传你的 Word 文档，立即获取精准报价
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex flex-col sm:flex-row gap-4 justify-center">
                  <Link href="/pricing">
                    <Button size="lg" className="group">
                      <Upload className="mr-2 h-5 w-5" />
                      上传文档
                      <ArrowRight className="ml-2 h-5 w-5 transition-transform group-hover:translate-x-1" />
                    </Button>
                  </Link>
                  <Button size="lg" variant="outline">
                    <Clock className="mr-2 h-5 w-5" />
                    预约咨询
                  </Button>
                </div>

                <div className="mt-6 flex justify-center gap-6 text-sm text-muted-foreground">
                  <span>QQ: 617315571</span>
                  <span>•</span>
                  <span>微信: xiakangwei001</span>
                </div>
              </CardContent>
            </Card>
          </motion.div>
        </div>
      </section>
    </MainLayout>
  );
}