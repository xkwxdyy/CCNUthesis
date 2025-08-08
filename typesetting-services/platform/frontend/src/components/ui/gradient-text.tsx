'use client';

import { motion } from 'framer-motion';
import { ReactNode } from 'react';

interface GradientTextProps {
  children: ReactNode;
  gradient?: string;
  animateGradient?: boolean;
  className?: string;
  glowEffect?: boolean;
}

export function GradientText({
  children,
  gradient = 'from-purple-400 via-pink-400 to-cyan-400',
  animateGradient = true,
  className = '',
  glowEffect = true,
}: GradientTextProps) {
  return (
    <motion.span
      className={`relative inline-block ${className}`}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <span 
        className={`bg-gradient-to-r ${gradient} bg-clip-text text-transparent`}
        style={animateGradient ? {
          backgroundSize: '200% 200%',
          animation: 'gradient-shift 3s ease infinite',
        } : undefined}
      >
        {children}
      </span>
      
      {glowEffect && (
        <motion.span
          className="absolute inset-0 blur-2xl opacity-50 -z-10"
          style={{
            background: `linear-gradient(to right, var(--tw-gradient-stops))`,
          }}
          animate={{
            opacity: [0.3, 0.6, 0.3],
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        >
          <span className={`bg-gradient-to-r ${gradient} bg-clip-text text-transparent`}>
            {children}
          </span>
        </motion.span>
      )}

      <style jsx>{`
        @keyframes gradient-shift {
          0%, 100% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
        }
      `}</style>
    </motion.span>
  );
}