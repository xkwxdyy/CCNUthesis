'use client';

import { useEffect, useRef, useState } from 'react';
import { motion, useAnimation, useInView } from 'framer-motion';

interface AnimatedCounterProps {
  value: number;
  duration?: number;
  prefix?: string;
  suffix?: string;
  decimals?: number;
  className?: string;
  startAnimation?: boolean;
  onComplete?: () => void;
}

export function AnimatedCounter({
  value,
  duration = 2,
  prefix = '',
  suffix = '',
  decimals = 0,
  className = '',
  startAnimation = true,
  onComplete,
}: AnimatedCounterProps) {
  const [displayValue, setDisplayValue] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);
  const ref = useRef<HTMLSpanElement>(null);
  const isInView = useInView(ref, { once: true });
  const controls = useAnimation();
  const prevValueRef = useRef(0);

  useEffect(() => {
    if (!startAnimation || !isInView) return;

    setIsAnimating(true);
    const startValue = prevValueRef.current;
    const endValue = value;
    const startTime = Date.now();
    const animationDuration = duration * 1000;

    const easeOutQuint = (t: number) => 1 - Math.pow(1 - t, 5);

    const updateValue = () => {
      const now = Date.now();
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / animationDuration, 1);
      
      const easedProgress = easeOutQuint(progress);
      const currentValue = startValue + (endValue - startValue) * easedProgress;
      
      setDisplayValue(currentValue);

      if (progress < 1) {
        requestAnimationFrame(updateValue);
      } else {
        setIsAnimating(false);
        prevValueRef.current = endValue;
        onComplete?.();
      }
    };

    requestAnimationFrame(updateValue);
  }, [value, duration, startAnimation, isInView, onComplete]);

  const formattedValue = displayValue.toFixed(decimals);
  const [integerPart, decimalPart] = formattedValue.split('.');
  const formattedInteger = integerPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  const finalDisplay = decimalPart ? `${formattedInteger}.${decimalPart}` : formattedInteger;

  return (
    <motion.span
      ref={ref}
      className={className}
      initial={{ opacity: 0, scale: 0.5 }}
      animate={isInView ? { opacity: 1, scale: 1 } : {}}
      transition={{ duration: 0.5, ease: 'easeOut' }}
    >
      <span className="relative inline-block">
        <motion.span
          className="relative z-10"
          animate={
            isAnimating
              ? {
                  textShadow: [
                    '0 0 20px rgba(139, 92, 246, 0.8)',
                    '0 0 40px rgba(139, 92, 246, 1)',
                    '0 0 20px rgba(139, 92, 246, 0.8)',
                  ],
                }
              : {}
          }
          transition={{
            duration: 0.5,
            repeat: isAnimating ? Infinity : 0,
            ease: 'easeInOut',
          }}
        >
          {prefix}
          <span className="tabular-nums">
            {finalDisplay.split('').map((char, index) => (
              <motion.span
                key={index}
                className="inline-block"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{
                  duration: 0.3,
                  delay: index * 0.02,
                  ease: 'easeOut',
                }}
              >
                {char}
              </motion.span>
            ))}
          </span>
          {suffix}
        </motion.span>

        {isAnimating && (
          <motion.span
            className="absolute inset-0 flex items-center justify-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: [0, 0.5, 0] }}
            transition={{
              duration: 1,
              repeat: Infinity,
              ease: 'easeInOut',
            }}
          >
            <span className="absolute inset-0 bg-gradient-to-r from-purple-600/20 to-blue-600/20 blur-xl" />
          </motion.span>
        )}
      </span>

      {isAnimating && (
        <motion.div
          className="absolute -inset-4 pointer-events-none"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          {[...Array(3)].map((_, i) => (
            <motion.div
              key={i}
              className="absolute inset-0"
              style={{
                border: '1px solid',
                borderColor: 'rgba(139, 92, 246, 0.3)',
                borderRadius: '8px',
              }}
              animate={{
                scale: [1, 1.2, 1.4],
                opacity: [0.5, 0.2, 0],
              }}
              transition={{
                duration: 1.5,
                delay: i * 0.2,
                repeat: Infinity,
                ease: 'easeOut',
              }}
            />
          ))}
        </motion.div>
      )}
    </motion.span>
  );
}