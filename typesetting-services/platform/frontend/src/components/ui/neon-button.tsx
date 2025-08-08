'use client';

import { motion } from 'framer-motion';
import { ReactNode, useState } from 'react';
import { cn } from '@/lib/utils';

interface NeonButtonProps {
  children: ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  variant?: 'primary' | 'secondary' | 'danger' | 'success';
  className?: string;
  glowIntensity?: 'low' | 'medium' | 'high';
  pulseAnimation?: boolean;
}

export function NeonButton({
  children,
  onClick,
  disabled = false,
  size = 'md',
  variant = 'primary',
  className,
  glowIntensity = 'medium',
  pulseAnimation = true,
}: NeonButtonProps) {
  const [isPressed, setIsPressed] = useState(false);

  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg',
    xl: 'px-10 py-5 text-xl',
  };

  const variantColors = {
    primary: {
      bg: 'from-purple-600 to-blue-600',
      glow: 'rgba(139, 92, 246, 0.8)',
      shadow: 'rgba(139, 92, 246, 0.5)',
      border: 'from-purple-400 to-blue-400',
      text: 'from-purple-100 to-blue-100',
    },
    secondary: {
      bg: 'from-cyan-600 to-teal-600',
      glow: 'rgba(6, 182, 212, 0.8)',
      shadow: 'rgba(6, 182, 212, 0.5)',
      border: 'from-cyan-400 to-teal-400',
      text: 'from-cyan-100 to-teal-100',
    },
    danger: {
      bg: 'from-red-600 to-pink-600',
      glow: 'rgba(239, 68, 68, 0.8)',
      shadow: 'rgba(239, 68, 68, 0.5)',
      border: 'from-red-400 to-pink-400',
      text: 'from-red-100 to-pink-100',
    },
    success: {
      bg: 'from-green-600 to-emerald-600',
      glow: 'rgba(34, 197, 94, 0.8)',
      shadow: 'rgba(34, 197, 94, 0.5)',
      border: 'from-green-400 to-emerald-400',
      text: 'from-green-100 to-emerald-100',
    },
  };

  const glowIntensityValues = {
    low: '10px',
    medium: '20px',
    high: '30px',
  };

  const colors = variantColors[variant];
  const glowSize = glowIntensityValues[glowIntensity];

  return (
    <motion.button
      onClick={onClick}
      disabled={disabled}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      onMouseLeave={() => setIsPressed(false)}
      className={cn(
        'relative group font-bold uppercase tracking-wider transition-all duration-300',
        'transform-gpu perspective-1000',
        sizeClasses[size],
        disabled && 'opacity-50 cursor-not-allowed',
        className
      )}
      style={{
        transformStyle: 'preserve-3d',
      }}
      whileHover={!disabled ? { scale: 1.05 } : {}}
      whileTap={!disabled ? { scale: 0.95 } : {}}
      animate={
        pulseAnimation && !disabled
          ? {
              boxShadow: [
                `0 0 ${glowSize} ${colors.shadow}`,
                `0 0 ${parseInt(glowSize) * 1.5}px ${colors.glow}`,
                `0 0 ${glowSize} ${colors.shadow}`,
              ],
            }
          : {}
      }
      transition={{
        boxShadow: {
          duration: 2,
          repeat: Infinity,
          ease: 'easeInOut',
        },
      }}
    >
      <span className="absolute inset-0 rounded-lg bg-gradient-to-r opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur-xl"
        style={{
          background: `linear-gradient(135deg, ${colors.glow}, ${colors.shadow})`,
        }}
      />

      <span
        className={cn(
          'absolute -inset-[2px] rounded-lg opacity-75 blur-sm transition-all duration-300',
          'group-hover:opacity-100 group-hover:blur-md',
          isPressed && 'blur-lg'
        )}
        style={{
          background: `linear-gradient(135deg, ${colors.border})`,
          animation: pulseAnimation ? 'gradient-shift 3s ease infinite' : undefined,
        }}
      />

      <span className="absolute -inset-[1px] rounded-lg bg-gradient-to-r opacity-50"
        style={{
          background: `linear-gradient(135deg, ${colors.border})`,
        }}
      />

      <span className="relative flex items-center justify-center gap-2 rounded-lg bg-black/90 backdrop-blur-xl px-6 py-3 transition-all duration-300 group-hover:bg-black/70">
        <span className="absolute inset-0 rounded-lg bg-gradient-to-br opacity-20"
          style={{
            backgroundImage: `linear-gradient(135deg, ${colors.bg})`,
          }}
        />
        
        <motion.span
          className="relative z-10 bg-gradient-to-r bg-clip-text text-transparent"
          style={{
            backgroundImage: `linear-gradient(135deg, ${colors.text})`,
          }}
          animate={
            !disabled
              ? {
                  textShadow: [
                    `0 0 10px ${colors.glow}`,
                    `0 0 20px ${colors.glow}`,
                    `0 0 10px ${colors.glow}`,
                  ],
                }
              : {}
          }
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        >
          {children}
        </motion.span>

        <motion.span
          className="absolute inset-0 rounded-lg pointer-events-none"
          initial={{ opacity: 0 }}
          animate={isPressed ? { opacity: 1 } : { opacity: 0 }}
          transition={{ duration: 0.3 }}
        >
          <span className="absolute inset-0 rounded-lg bg-white/20" />
        </motion.span>
      </span>

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
    </motion.button>
  );
}