'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface Ripple {
  id: number;
  x: number;
  y: number;
  size: number;
}

interface RippleEffectProps {
  color?: string;
  duration?: number;
  maxSize?: number;
}

export function RippleEffect({ 
  color = 'rgba(139, 92, 246, 0.4)',
  duration = 0.6,
  maxSize = 300 
}: RippleEffectProps) {
  const [ripples, setRipples] = useState<Ripple[]>([]);

  const handleClick = (e: React.MouseEvent) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height) * 2;
    
    const newRipple: Ripple = {
      id: Date.now(),
      x: e.clientX - rect.left,
      y: e.clientY - rect.top,
      size: Math.min(size, maxSize),
    };

    setRipples(prev => [...prev, newRipple]);
  };

  useEffect(() => {
    const timer = setInterval(() => {
      setRipples(prev => prev.filter(ripple => 
        Date.now() - ripple.id < duration * 1000
      ));
    }, 100);

    return () => clearInterval(timer);
  }, [duration]);

  return (
    <div 
      className="absolute inset-0 overflow-hidden pointer-events-none"
      onMouseDown={handleClick as any}
      style={{ pointerEvents: 'auto' }}
    >
      <AnimatePresence>
        {ripples.map(ripple => (
          <motion.span
            key={ripple.id}
            className="absolute rounded-full"
            style={{
              left: ripple.x,
              top: ripple.y,
              backgroundColor: color,
            }}
            initial={{ 
              width: 0, 
              height: 0,
              x: 0,
              y: 0,
              opacity: 1 
            }}
            animate={{ 
              width: ripple.size, 
              height: ripple.size,
              x: -ripple.size / 2,
              y: -ripple.size / 2,
              opacity: 0
            }}
            exit={{ opacity: 0 }}
            transition={{ 
              duration,
              ease: 'easeOut'
            }}
          />
        ))}
      </AnimatePresence>
    </div>
  );
}