'use client';

import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';

interface TypewriterTextProps {
  text: string;
  delay?: number;
  speed?: number;
  className?: string;
  cursor?: boolean;
  cursorChar?: string;
  onComplete?: () => void;
  startAnimation?: boolean;
}

export function TypewriterText({
  text,
  delay = 0,
  speed = 50,
  className = '',
  cursor = true,
  cursorChar = '|',
  onComplete,
  startAnimation = true,
}: TypewriterTextProps) {
  const [displayText, setDisplayText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [showCursor, setShowCursor] = useState(cursor);

  useEffect(() => {
    if (!startAnimation) return;

    setIsTyping(true);
    let index = 0;
    const timeout = setTimeout(() => {
      const interval = setInterval(() => {
        if (index <= text.length) {
          setDisplayText(text.slice(0, index));
          index++;
        } else {
          clearInterval(interval);
          setIsTyping(false);
          onComplete?.();
          
          if (cursor) {
            setTimeout(() => setShowCursor(false), 2000);
          }
        }
      }, speed);

      return () => clearInterval(interval);
    }, delay);

    return () => clearTimeout(timeout);
  }, [text, delay, speed, cursor, onComplete, startAnimation]);

  return (
    <span className={className}>
      <span className="relative">
        {displayText.split('').map((char, index) => (
          <motion.span
            key={index}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{
              duration: 0.1,
              ease: 'easeOut',
            }}
            className="inline-block"
            style={{
              whiteSpace: char === ' ' ? 'pre' : 'normal',
            }}
          >
            {char}
          </motion.span>
        ))}
        {showCursor && (
          <motion.span
            className="inline-block ml-0.5"
            animate={{
              opacity: [1, 1, 0, 0],
            }}
            transition={{
              duration: 1,
              repeat: Infinity,
              ease: 'linear',
              times: [0, 0.5, 0.5, 1],
            }}
            style={{
              color: 'currentColor',
              textShadow: '0 0 10px currentColor',
            }}
          >
            {cursorChar}
          </motion.span>
        )}
      </span>
      {isTyping && (
        <motion.span
          className="absolute -inset-1 pointer-events-none"
          initial={{ opacity: 0 }}
          animate={{ opacity: [0, 0.1, 0] }}
          transition={{
            duration: 0.5,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        >
          <span className="absolute inset-0 bg-gradient-to-r from-purple-600/10 to-blue-600/10 blur-sm" />
        </motion.span>
      )}
    </span>
  );
}