'use client';

import { useEffect, useRef } from 'react';
import { motion, useMotionValue, useSpring } from 'framer-motion';

interface CursorTrailProps {
  color?: string;
  size?: number;
  trailLength?: number;
}

export function CursorTrail({ 
  color = 'rgba(139, 92, 246, 0.5)',
  size = 20,
  trailLength = 8
}: CursorTrailProps) {
  const cursor = useRef<HTMLDivElement>(null);
  const cursorX = useMotionValue(0);
  const cursorY = useMotionValue(0);

  const springConfig = { damping: 25, stiffness: 700 };
  const cursorXSpring = useSpring(cursorX, springConfig);
  const cursorYSpring = useSpring(cursorY, springConfig);

  useEffect(() => {
    const moveCursor = (e: MouseEvent) => {
      cursorX.set(e.clientX - size / 2);
      cursorY.set(e.clientY - size / 2);
    };

    window.addEventListener('mousemove', moveCursor);

    return () => {
      window.removeEventListener('mousemove', moveCursor);
    };
  }, [cursorX, cursorY, size]);

  return (
    <>
      {Array.from({ length: trailLength }).map((_, index) => {
        const delay = index * 0.03;
        const opacity = 1 - (index / trailLength);
        const scale = 1 - (index / trailLength) * 0.5;
        
        return (
          <motion.div
            key={index}
            className="fixed pointer-events-none z-50"
            style={{
              left: cursorXSpring,
              top: cursorYSpring,
              width: size,
              height: size,
              x: '-50%',
              y: '-50%',
            }}
            animate={{
              scale: [scale, scale * 0.9, scale],
            }}
            transition={{
              scale: {
                duration: 1.5,
                repeat: Infinity,
                delay,
                ease: 'easeInOut',
              },
              default: {
                delay,
                type: 'spring',
                damping: 25 + index * 2,
                stiffness: 700 - index * 50,
              },
            }}
          >
            <div
              className="w-full h-full rounded-full"
              style={{
                background: `radial-gradient(circle, ${color.replace('0.5', String(opacity * 0.5))}, transparent)`,
                filter: `blur(${index * 0.5}px)`,
              }}
            />
          </motion.div>
        );
      })}
    </>
  );
}