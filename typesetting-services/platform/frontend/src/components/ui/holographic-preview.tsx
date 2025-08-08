'use client';

import { motion } from 'framer-motion';
import { FileText, FileCheck, Loader2 } from 'lucide-react';
import { useState, useEffect } from 'react';

interface HolographicPreviewProps {
  file?: File;
  isAnalyzing?: boolean;
  analysisResult?: {
    pageCount: number;
    formulaCount: number;
    tableCount: number;
    refCount: number;
  };
}

export function HolographicPreview({ 
  file, 
  isAnalyzing = false,
  analysisResult 
}: HolographicPreviewProps) {
  const [scanProgress, setScanProgress] = useState(0);

  useEffect(() => {
    if (isAnalyzing) {
      setScanProgress(0);
      const interval = setInterval(() => {
        setScanProgress(prev => {
          if (prev >= 100) {
            clearInterval(interval);
            return 100;
          }
          return prev + 2;
        });
      }, 40);
      return () => clearInterval(interval);
    }
  }, [isAnalyzing]);

  if (!file && !isAnalyzing && !analysisResult) {
    return null;
  }

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.8 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.8 }}
      className="relative w-full h-64 rounded-xl overflow-hidden"
    >
      <div className="absolute inset-0 bg-gradient-to-br from-cyan-500/10 via-purple-500/10 to-pink-500/10 animate-pulse" />
      
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" />

      <div className="relative h-full flex items-center justify-center">
        {isAnalyzing ? (
          <div className="relative">
            <motion.div
              className="w-32 h-40 relative"
              animate={{
                rotateY: [0, 360],
              }}
              transition={{
                duration: 4,
                repeat: Infinity,
                ease: 'linear',
              }}
              style={{
                transformStyle: 'preserve-3d',
              }}
            >
              <div className="absolute inset-0 border-2 border-cyan-400/50 rounded-lg"
                style={{
                  transform: 'translateZ(20px)',
                  boxShadow: '0 0 30px rgba(6, 182, 212, 0.5)',
                }}
              />
              <div className="absolute inset-0 border-2 border-purple-400/50 rounded-lg"
                style={{
                  transform: 'translateZ(-20px)',
                  boxShadow: '0 0 30px rgba(139, 92, 246, 0.5)',
                }}
              />
              
              <div className="absolute inset-0 flex items-center justify-center">
                <FileText className="w-16 h-16 text-cyan-400" />
              </div>
            </motion.div>

            <div className="mt-8 text-center">
              <motion.div
                className="text-cyan-400 text-sm font-mono mb-2"
                animate={{ opacity: [0.5, 1, 0.5] }}
                transition={{ duration: 1.5, repeat: Infinity }}
              >
                扫描中... {scanProgress}%
              </motion.div>
              
              <div className="w-48 h-1 bg-black/50 rounded-full overflow-hidden">
                <motion.div
                  className="h-full bg-gradient-to-r from-cyan-400 to-purple-400"
                  style={{ width: `${scanProgress}%` }}
                  transition={{ duration: 0.3 }}
                />
              </div>

              <div className="mt-4 space-y-1">
                {['正在解析文档结构...', '识别公式和表格...', '分析参考文献...'].map((text, i) => (
                  <motion.div
                    key={i}
                    className="text-xs text-cyan-300/70"
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: scanProgress > i * 33 ? 1 : 0, x: 0 }}
                    transition={{ delay: i * 0.5 }}
                  >
                    {text}
                  </motion.div>
                ))}
              </div>
            </div>
          </div>
        ) : analysisResult ? (
          <motion.div
            className="text-center"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: 'spring', duration: 0.5 }}
          >
            <motion.div
              className="w-20 h-20 mx-auto mb-4 relative"
              animate={{
                rotate: [0, 5, -5, 0],
              }}
              transition={{
                duration: 4,
                repeat: Infinity,
                ease: 'easeInOut',
              }}
            >
              <FileCheck className="w-20 h-20 text-green-400" />
              <motion.div
                className="absolute inset-0"
                animate={{
                  boxShadow: [
                    '0 0 20px rgba(34, 197, 94, 0.5)',
                    '0 0 40px rgba(34, 197, 94, 0.8)',
                    '0 0 20px rgba(34, 197, 94, 0.5)',
                  ],
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                }}
                style={{
                  borderRadius: '50%',
                }}
              />
            </motion.div>

            <div className="text-green-400 font-bold mb-4">分析完成</div>

            <div className="grid grid-cols-2 gap-4 text-sm">
              {[
                { label: '页数', value: analysisResult.pageCount, color: 'text-cyan-400' },
                { label: '公式', value: analysisResult.formulaCount, color: 'text-purple-400' },
                { label: '表格', value: analysisResult.tableCount, color: 'text-pink-400' },
                { label: '参考文献', value: analysisResult.refCount, color: 'text-yellow-400' },
              ].map((item, index) => (
                <motion.div
                  key={item.label}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className="relative"
                >
                  <div className="text-gray-400 text-xs">{item.label}</div>
                  <div className={`text-2xl font-bold ${item.color}`}>
                    {item.value}
                  </div>
                  <motion.div
                    className="absolute -inset-2 rounded-lg"
                    style={{
                      background: `radial-gradient(circle, ${item.color.replace('text-', 'rgb(').replace('400', ' / 0.1)')}, transparent)`,
                    }}
                    animate={{
                      scale: [1, 1.2, 1],
                      opacity: [0.5, 0.2, 0.5],
                    }}
                    transition={{
                      duration: 2,
                      delay: index * 0.2,
                      repeat: Infinity,
                    }}
                  />
                </motion.div>
              ))}
            </div>
          </motion.div>
        ) : (
          <div className="text-center text-gray-400">
            <FileText className="w-16 h-16 mx-auto mb-2 opacity-50" />
            <div className="text-sm">{file?.name}</div>
          </div>
        )}
      </div>

      <div className="absolute inset-0 pointer-events-none">
        <svg className="w-full h-full">
          <defs>
            <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
              <path d="M 20 0 L 0 0 0 20" fill="none" stroke="rgba(6, 182, 212, 0.1)" strokeWidth="0.5" />
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#grid)" />
        </svg>
      </div>

      {isAnalyzing && (
        <motion.div
          className="absolute inset-0 pointer-events-none"
          animate={{
            background: [
              'linear-gradient(0deg, transparent, rgba(6, 182, 212, 0.2), transparent)',
              'linear-gradient(180deg, transparent, rgba(6, 182, 212, 0.2), transparent)',
            ],
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: 'linear',
          }}
          style={{
            backgroundSize: '100% 200%',
            backgroundPosition: '0% 0%',
          }}
        />
      )}
    </motion.div>
  );
}