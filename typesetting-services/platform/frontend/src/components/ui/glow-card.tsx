'use client';

import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion';
import { ReactNode, useRef } from 'react';
import { cn } from '@/lib/utils';

interface GlowCardProps {
  children: ReactNode;
  className?: string;
  glowColor?: string;
  borderGradient?: string;
}

export function GlowCard({ 
  children, 
  className,
  glowColor = 'rgba(139, 92, 246, 0.5)',
  borderGradient = 'linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #6366f1 75%, #667eea 100%)'
}: GlowCardProps) {
  const ref = useRef<HTMLDivElement>(null);
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);

  const damping = 20;
  const stiffness = 200;

  const springX = useSpring(mouseX, { damping, stiffness });
  const springY = useSpring(mouseY, { damping, stiffness });

  const rotateX = useTransform(springY, [-0.5, 0.5], ['7.5deg', '-7.5deg']);
  const rotateY = useTransform(springX, [-0.5, 0.5], ['-7.5deg', '7.5deg']);

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!ref.current) return;

    const rect = ref.current.getBoundingClientRect();
    const width = rect.width;
    const height = rect.height;

    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const xPct = (x - width / 2) / (width / 2);
    const yPct = (y - height / 2) / (height / 2);

    mouseX.set(xPct);
    mouseY.set(yPct);
  };

  const handleMouseLeave = () => {
    mouseX.set(0);
    mouseY.set(0);
  };

  return (
    <motion.div
      ref={ref}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      style={{
        rotateX,
        rotateY,
        transformStyle: 'preserve-3d',
      }}
      className={cn(
        'relative group',
        className
      )}
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.5, ease: [0.21, 0.47, 0.32, 0.98] }}
    >
      <div
        className="absolute -inset-[1px] rounded-xl opacity-75 blur-lg transition-all duration-500 group-hover:opacity-100 group-hover:-inset-[2px] group-hover:blur-xl"
        style={{
          background: borderGradient,
          backgroundSize: '200% 200%',
          animation: 'gradient-shift 3s ease infinite',
        }}
      />
      
      <div className="absolute -inset-[1px] rounded-xl opacity-0 transition-opacity duration-500 group-hover:opacity-100">
        <div
          className="absolute inset-0 rounded-xl"
          style={{
            background: borderGradient,
            backgroundSize: '200% 200%',
            animation: 'gradient-shift 2s ease infinite',
          }}
        />
      </div>

      <motion.div
        className="absolute inset-0 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
        style={{
          background: `radial-gradient(600px circle at ${springX.get() * 100 + 50}% ${springY.get() * 100 + 50}%, ${glowColor}, transparent 40%)`,
        }}
      />

      <div className="relative bg-black/90 backdrop-blur-xl rounded-xl border border-white/10 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-purple-500/5 via-transparent to-cyan-500/5" />
        
        <div className="absolute top-0 left-0 w-40 h-40 bg-purple-500/20 rounded-full filter blur-3xl animate-pulse" />
        <div className="absolute bottom-0 right-0 w-40 h-40 bg-cyan-500/20 rounded-full filter blur-3xl animate-pulse animation-delay-2000" />
        
        <div className="relative z-10">
          {children}
        </div>

        <div className="absolute inset-0 pointer-events-none">
          <div className="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-white/20 to-transparent" />
          <div className="absolute bottom-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-white/20 to-transparent" />
        </div>
      </div>

      <style jsx>{`
        @keyframes gradient-shift {
          0%, 100% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
        }
        
        .animation-delay-2000 {
          animation-delay: 2s;
        }
      `}</style>
    </motion.div>
  );
}