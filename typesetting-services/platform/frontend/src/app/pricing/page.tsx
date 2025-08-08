'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import MainLayout from '@/components/layout/MainLayout';
import { ParticleBackground } from '@/components/ui/particle-background';
import { GlowCard } from '@/components/ui/glow-card';
import { NeonButton } from '@/components/ui/neon-button';
import { AnimatedCounter } from '@/components/ui/animated-counter';
import { TypewriterText } from '@/components/ui/typewriter-text';
import { HolographicPreview } from '@/components/ui/holographic-preview';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { FileUpload } from '@/components/ui/file-upload';
import { useUser } from '@/hooks/use-user';
import { 
  Calculator, 
  Sparkles,
  Zap,
  ChevronRight,
  TrendingUp,
  Award,
  Shield,
  Rocket,
  Star,
  ArrowUpRight,
  Brain,
  Cpu,
  Layers,
  GitBranch
} from 'lucide-react';

interface PriceCalculation {
  basePrice: number;
  pagePrice: number;
  formulaPrice: number;
  tablePrice: number;
  refPrice: number;
  complexityFactor: number;
  totalPrice: number;
}

interface FormValues {
  pageCount: number;
  formulaCount: number;
  tableCount: number;
  refCount: number;
}

export default function PricingPage() {
  const { user } = useUser();
  const [files, setFiles] = useState<File[]>([]);
  const [formValues, setFormValues] = useState<FormValues>({
    pageCount: 0,
    formulaCount: 0,
    tableCount: 0,
    refCount: 0,
  });
  const [calculation, setCalculation] = useState<PriceCalculation | null>(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [showPriceBreakdown, setShowPriceBreakdown] = useState(false);

  const calculatePrice = (values: FormValues) => {
    const basePrice = 200;
    const pagePrice = 5 * values.pageCount;
    const formulaPrice = 3 * values.formulaCount;
    const tablePrice = 10 * values.tableCount;
    const refPrice = 2 * values.refCount;
    
    const totalElements = values.formulaCount + values.tableCount;
    let complexityFactor = 1;
    if (totalElements > 50) complexityFactor = 1.2;
    if (totalElements > 100) complexityFactor = 1.5;
    
    const totalPrice = Math.round(
      (basePrice + pagePrice + formulaPrice + tablePrice + refPrice) * complexityFactor
    );

    setCalculation({
      basePrice,
      pagePrice,
      formulaPrice,
      tablePrice,
      refPrice,
      complexityFactor,
      totalPrice,
    });
    setShowPriceBreakdown(true);
  };

  const handleFileUpload = async (acceptedFiles: File[]) => {
    setFiles(acceptedFiles);
    setIsAnalyzing(true);
    try {
      const form = new FormData();
      form.append('file', acceptedFiles[0]);
      const res = await fetch('/api/analyze', { method: 'POST', body: form });
      const data = await res.json();
      if (!res.ok) throw new Error(data?.error || '分析失败');
      const values = {
        pageCount: data?.statistics?.page_count ?? 0,
        formulaCount: data?.statistics?.formula_count ?? 0,
        tableCount: data?.statistics?.table_count ?? 0,
        refCount: data?.statistics?.reference_count ?? 0,
      };
      setFormValues(values);
      calculatePrice(values);
    } catch (e) {
      console.error(e);
    } finally {
      setIsAnalyzing(false);
    }
  };

  const handleInputChange = (field: keyof FormValues, value: string) => {
    const numValue = parseInt(value) || 0;
    const newValues = { ...formValues, [field]: numValue };
    setFormValues(newValues);
  };

  const handleCalculate = () => {
    calculatePrice(formValues);
  };

  const handleCreateOrder = async () => {
    if (!calculation) return;
    if (!user) {
      window.location.href = '/login';
      return;
    }
    const res = await fetch('/api/orders', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        userId: user.id,
        pageCount: formValues.pageCount,
        formulaCount: formValues.formulaCount,
        tableCount: formValues.tableCount,
        refCount: formValues.refCount,
        totalPrice: calculation.totalPrice,
      }),
    });
    const data = await res.json();
    if (res.ok) alert('订单创建成功，ID: ' + data.id);
    else alert('下单失败: ' + (data.error || '未知错误'));
  };

  return (
    <MainLayout>
      <ParticleBackground />
      
      <div className="relative z-10 min-h-screen">
        <div className="container mx-auto px-4 py-12 max-w-7xl">
          {/* Hero Section */}
          <motion.div 
            className="text-center mb-16"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, ease: 'easeOut' }}
          >
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, type: 'spring', stiffness: 200 }}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-gradient-to-r from-purple-600/20 to-blue-600/20 border border-purple-500/30 backdrop-blur-sm mb-6"
            >
              <Sparkles className="h-4 w-4 text-purple-400" />
              <span className="text-sm font-medium bg-gradient-to-r from-purple-400 to-blue-400 bg-clip-text text-transparent">
                AI 智能定价系统
              </span>
              <Badge className="bg-gradient-to-r from-green-600 to-emerald-600 text-white border-0">
                NEW
              </Badge>
            </motion.div>

            <h1 className="text-6xl md:text-7xl font-black mb-6">
              <span className="bg-gradient-to-br from-purple-400 via-pink-400 to-cyan-400 bg-clip-text text-transparent">
                <TypewriterText text="极速定价" speed={100} />
              </span>
              <br />
              <span className="bg-gradient-to-br from-cyan-400 via-blue-400 to-purple-400 bg-clip-text text-transparent">
                <TypewriterText text="智能分析" delay={800} speed={100} />
              </span>
            </h1>

            <motion.p 
              className="text-xl text-gray-400 max-w-3xl mx-auto mb-8"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.6, duration: 0.8 }}
            >
              基于深度学习的文档分析系统，毫秒级精准报价
            </motion.p>

            <motion.div 
              className="flex flex-wrap justify-center gap-6 text-sm"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 2, duration: 0.6 }}
            >
              {[
                { icon: Zap, text: '极速分析', color: 'from-yellow-400 to-orange-400' },
                { icon: Shield, text: '安全加密', color: 'from-green-400 to-emerald-400' },
                { icon: Award, text: '精准定价', color: 'from-blue-400 to-cyan-400' },
                { icon: Rocket, text: '即时报价', color: 'from-purple-400 to-pink-400' },
              ].map((item, index) => (
                <motion.div
                  key={index}
                  className="flex items-center gap-2 px-4 py-2 rounded-full bg-black/30 backdrop-blur-sm border border-white/10"
                  whileHover={{ scale: 1.05, borderColor: 'rgba(255,255,255,0.3)' }}
                  transition={{ type: 'spring', stiffness: 400 }}
                >
                  <item.icon className={`h-4 w-4 bg-gradient-to-r ${item.color} bg-clip-text`} style={{ WebkitTextFillColor: 'transparent' }} />
                  <span className="text-gray-300">{item.text}</span>
                </motion.div>
              ))}
            </motion.div>
          </motion.div>

          <div className="grid lg:grid-cols-2 gap-8 mb-12">
            {/* Left Column - Input */}
            <motion.div
              initial={{ opacity: 0, x: -50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4, duration: 0.6 }}
            >
              <GlowCard className="h-full">
                <div className="p-8">
                  <div className="flex items-center gap-3 mb-6">
                    <div className="p-3 rounded-xl bg-gradient-to-br from-purple-600/20 to-blue-600/20 border border-purple-500/30">
                      <Brain className="h-6 w-6 text-purple-400" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold bg-gradient-to-r from-purple-400 to-blue-400 bg-clip-text text-transparent">
                        智能分析
                      </h2>
                      <p className="text-sm text-gray-400">上传文档或手动输入</p>
                    </div>
                  </div>

                  {/* File Upload */}
                  <div className="mb-8">
                    <Label className="text-gray-300 mb-3 block flex items-center gap-2">
                      <Cpu className="h-4 w-4 text-cyan-400" />
                      文档上传
                    </Label>
                    <FileUpload 
                      files={files}
                      onDrop={handleFileUpload}
                      onRemove={() => setFiles([])}
                      disabled={isAnalyzing}
                    />
                    
                    {(files.length > 0 || isAnalyzing) && (
                      <div className="mt-6">
                        <HolographicPreview
                          file={files[0]}
                          isAnalyzing={isAnalyzing}
                          analysisResult={!isAnalyzing && formValues.pageCount > 0 ? formValues : undefined}
                        />
                      </div>
                    )}
                  </div>

                  <div className="relative mb-8">
                    <div className="absolute inset-0 flex items-center">
                      <div className="w-full border-t border-gray-700"></div>
                    </div>
                    <div className="relative flex justify-center">
                      <span className="px-4 bg-black text-sm text-gray-400">或手动输入</span>
                    </div>
                  </div>

                  {/* Manual Input */}
                  <div className="grid grid-cols-2 gap-4 mb-6">
                    {[
                      { label: '页数', field: 'pageCount', icon: Layers, color: 'text-cyan-400' },
                      { label: '公式数量', field: 'formulaCount', icon: GitBranch, color: 'text-purple-400' },
                      { label: '表格数量', field: 'tableCount', icon: Layers, color: 'text-pink-400' },
                      { label: '参考文献', field: 'refCount', icon: GitBranch, color: 'text-yellow-400' },
                    ].map((item) => (
                      <motion.div 
                        key={item.field}
                        whileHover={{ scale: 1.02 }}
                        transition={{ type: 'spring', stiffness: 400 }}
                      >
                        <Label className="text-gray-400 text-sm mb-2 flex items-center gap-2">
                          <item.icon className={`h-3 w-3 ${item.color}`} />
                          {item.label}
                        </Label>
                        <div className="relative group">
                          <Input
                            type="number"
                            min="0"
                            placeholder="0"
                            value={formValues[item.field as keyof FormValues] || ''}
                            onChange={(e) => handleInputChange(item.field as keyof FormValues, e.target.value)}
                            className="bg-black/50 border-gray-700 text-white placeholder-gray-500 focus:border-purple-500 transition-all duration-300"
                          />
                          <div className="absolute inset-0 rounded-md bg-gradient-to-r from-purple-600/0 via-purple-600/20 to-purple-600/0 opacity-0 group-focus-within:opacity-100 pointer-events-none transition-opacity duration-300" />
                        </div>
                      </motion.div>
                    ))}
                  </div>

                  <NeonButton
                    onClick={handleCalculate}
                    disabled={isAnalyzing}
                    size="lg"
                    variant="primary"
                    className="w-full"
                    glowIntensity="high"
                  >
                    {isAnalyzing ? (
                      <>
                        <Cpu className="mr-2 h-5 w-5 animate-spin" />
                        AI 分析中...
                      </>
                    ) : (
                      <>
                        <Calculator className="mr-2 h-5 w-5" />
                        立即计算
                      </>
                    )}
                  </NeonButton>
                </div>
              </GlowCard>

              {/* Features */}
              <motion.div 
                className="mt-6 grid grid-cols-2 gap-4"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6, duration: 0.6 }}
              >
                {[
                  { icon: Zap, title: '毫秒响应', desc: '极速分析' },
                  { icon: Shield, title: '企业加密', desc: '数据安全' },
                  { icon: TrendingUp, title: '智能优化', desc: '精准报价' },
                  { icon: Star, title: '五星服务', desc: '专业团队' },
                ].map((feature, index) => (
                  <GlowCard key={index} glowColor="rgba(59, 130, 246, 0.3)">
                    <div className="p-4 flex items-start gap-3">
                      <div className="p-2 rounded-lg bg-gradient-to-br from-blue-600/20 to-cyan-600/20 border border-blue-500/30">
                        <feature.icon className="h-4 w-4 text-blue-400" />
                      </div>
                      <div>
                        <h3 className="text-sm font-semibold text-white">{feature.title}</h3>
                        <p className="text-xs text-gray-400">{feature.desc}</p>
                      </div>
                    </div>
                  </GlowCard>
                ))}
              </motion.div>
            </motion.div>

            {/* Right Column - Results */}
            <motion.div
              initial={{ opacity: 0, x: 50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.5, duration: 0.6 }}
            >
              <AnimatePresence mode="wait">
                {calculation ? (
                  <motion.div
                    key="result"
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.9 }}
                    transition={{ type: 'spring', stiffness: 200 }}
                  >
                    <GlowCard 
                      glowColor="rgba(236, 72, 153, 0.5)"
                      borderGradient="linear-gradient(135deg, #f093fb 0%, #f5576c 25%, #4facfe 50%, #00f2fe 75%, #f093fb 100%)"
                    >
                      <div className="p-8">
                        <div className="text-center mb-8">
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ type: 'spring', delay: 0.2 }}
                            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-gradient-to-r from-green-600/20 to-emerald-600/20 border border-green-500/30 mb-4"
                          >
                            <Star className="h-4 w-4 text-green-400" />
                            <span className="text-sm font-medium text-green-400">计算完成</span>
                          </motion.div>

                          <div className="relative">
                            <motion.div
                              className="absolute inset-0 blur-3xl"
                              animate={{
                                background: [
                                  'radial-gradient(circle, rgba(139, 92, 246, 0.3) 0%, transparent 70%)',
                                  'radial-gradient(circle, rgba(236, 72, 153, 0.3) 0%, transparent 70%)',
                                  'radial-gradient(circle, rgba(59, 130, 246, 0.3) 0%, transparent 70%)',
                                  'radial-gradient(circle, rgba(139, 92, 246, 0.3) 0%, transparent 70%)',
                                ],
                              }}
                              transition={{
                                duration: 4,
                                repeat: Infinity,
                                ease: 'linear',
                              }}
                            />
                            
                            <div className="relative">
                              <div className="text-7xl font-black mb-2">
                                <AnimatedCounter
                                  value={calculation.totalPrice}
                                  prefix="¥"
                                  duration={2}
                                  className="bg-gradient-to-r from-yellow-400 via-pink-400 to-purple-400 bg-clip-text text-transparent"
                                />
                              </div>
                              <p className="text-gray-400">预估总价</p>
                            </div>
                          </div>
                        </div>

                        {/* Price Breakdown */}
                        <motion.div
                          initial={{ height: 0, opacity: 0 }}
                          animate={showPriceBreakdown ? { height: 'auto', opacity: 1 } : {}}
                          transition={{ duration: 0.5, ease: 'easeOut' }}
                          className="overflow-hidden"
                        >
                          <div className="pt-6 border-t border-gray-800">
                            <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                              <TrendingUp className="h-5 w-5 text-cyan-400" />
                              <span className="bg-gradient-to-r from-cyan-400 to-blue-400 bg-clip-text text-transparent">
                                价格明细
                              </span>
                            </h3>
                            
                            <div className="space-y-3">
                              {[
                                { label: '基础费用', value: calculation.basePrice, color: 'from-blue-400 to-cyan-400' },
                                { label: '页数费用', value: calculation.pagePrice, color: 'from-purple-400 to-pink-400' },
                                { label: '公式处理', value: calculation.formulaPrice, color: 'from-green-400 to-emerald-400' },
                                { label: '表格处理', value: calculation.tablePrice, color: 'from-yellow-400 to-orange-400' },
                                { label: '参考文献', value: calculation.refPrice, color: 'from-pink-400 to-red-400' },
                              ].map((item, index) => (
                                <motion.div
                                  key={item.label}
                                  initial={{ opacity: 0, x: -20 }}
                                  animate={{ opacity: 1, x: 0 }}
                                  transition={{ delay: index * 0.1 }}
                                  className="flex items-center justify-between p-3 rounded-lg bg-gradient-to-r from-gray-900/50 to-gray-800/50 border border-gray-700/50"
                                >
                                  <span className="text-gray-400 text-sm">{item.label}</span>
                                  <div className="flex items-center gap-2">
                                    <span className={`text-lg font-semibold bg-gradient-to-r ${item.color} bg-clip-text text-transparent`}>
                                      ¥{item.value}
                                    </span>
                                    <ArrowUpRight className="h-4 w-4 text-gray-500" />
                                  </div>
                                </motion.div>
                              ))}
                              
                              {calculation.complexityFactor > 1 && (
                                <motion.div
                                  initial={{ opacity: 0, scale: 0.9 }}
                                  animate={{ opacity: 1, scale: 1 }}
                                  className="flex items-center justify-between p-3 rounded-lg bg-gradient-to-r from-purple-900/30 to-pink-900/30 border border-purple-500/30"
                                >
                                  <span className="text-purple-300 text-sm font-medium">复杂度系数</span>
                                  <Badge className="bg-gradient-to-r from-purple-600 to-pink-600 text-white border-0">
                                    ×{calculation.complexityFactor}
                                  </Badge>
                                </motion.div>
                              )}
                            </div>
                          </div>
                        </motion.div>

                        {/* CTA Buttons */}
                        <div className="mt-8 space-y-3">
                          <NeonButton
                            size="lg"
                            variant="success"
                            className="w-full"
                            glowIntensity="high"
                             onClick={handleCreateOrder}
                          >
                            <Rocket className="mr-2 h-5 w-5" />
                            立即下单
                            <ChevronRight className="ml-2 h-5 w-5" />
                          </NeonButton>
                          
                          <NeonButton
                            size="lg"
                            variant="secondary"
                            className="w-full"
                            glowIntensity="low"
                            onClick={() => {}}
                          >
                            联系客服
                          </NeonButton>
                        </div>

                        {/* Promo Badge */}
                        <motion.div
                          className="mt-6 p-4 rounded-xl bg-gradient-to-r from-purple-900/20 via-pink-900/20 to-orange-900/20 border border-purple-500/30"
                          initial={{ opacity: 0, y: 20 }}
                          animate={{ opacity: 1, y: 0 }}
                          transition={{ delay: 0.8 }}
                        >
                          <div className="flex items-center gap-3">
                            <div className="p-2 rounded-lg bg-gradient-to-br from-yellow-600/30 to-orange-600/30">
                              <Sparkles className="h-5 w-5 text-yellow-400" />
                            </div>
                            <div>
                              <h4 className="text-sm font-semibold text-yellow-400">限时优惠</h4>
                              <p className="text-xs text-gray-400">邀请好友下单，双方各得¥30优惠券</p>
                            </div>
                          </div>
                        </motion.div>
                      </div>
                    </GlowCard>
                  </motion.div>
                ) : (
                  <motion.div
                    key="empty"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                  >
                    <GlowCard className="h-full min-h-[600px] flex items-center justify-center">
                      <div className="text-center p-8">
                        <motion.div
                          className="w-32 h-32 mx-auto mb-6 relative"
                          animate={{
                            rotate: [0, 360],
                          }}
                          transition={{
                            duration: 20,
                            repeat: Infinity,
                            ease: 'linear',
                          }}
                        >
                          <div className="absolute inset-0 rounded-full bg-gradient-to-r from-purple-600/20 to-blue-600/20 blur-xl" />
                          <div className="relative w-full h-full rounded-full border-2 border-dashed border-gray-600 flex items-center justify-center">
                            <Calculator className="h-12 w-12 text-gray-500" />
                          </div>
                        </motion.div>
                        
                        <h3 className="text-2xl font-bold mb-3 bg-gradient-to-r from-gray-400 to-gray-500 bg-clip-text text-transparent">
                          等待计算
                        </h3>
                        <p className="text-gray-500 max-w-xs mx-auto">
                          上传文档或输入信息，AI 将为您智能分析并生成报价
                        </p>
                      </div>
                    </GlowCard>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          </div>

          {/* Bottom Stats */}
          <motion.div
            className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-6"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8, duration: 0.6 }}
          >
            {[
              { label: '处理文档', value: 10000, suffix: '+', icon: Calculator },
              { label: '满意度', value: 99.8, suffix: '%', icon: Star },
              { label: '平均耗时', value: 3, suffix: '秒', icon: Zap },
              { label: '活跃用户', value: 5000, suffix: '+', icon: TrendingUp },
            ].map((stat, index) => (
              <GlowCard key={index} glowColor="rgba(139, 92, 246, 0.2)">
                <div className="p-6 text-center">
                  <stat.icon className="h-8 w-8 mx-auto mb-3 text-purple-400" />
                  <div className="text-3xl font-bold mb-1">
                    <AnimatedCounter
                      value={stat.value}
                      suffix={stat.suffix}
                      decimals={stat.label === '满意度' ? 1 : 0}
                      className="bg-gradient-to-r from-purple-400 to-blue-400 bg-clip-text text-transparent"
                    />
                  </div>
                  <p className="text-sm text-gray-400">{stat.label}</p>
                </div>
              </GlowCard>
            ))}
          </motion.div>
        </div>
      </div>
    </MainLayout>
  );
}