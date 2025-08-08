'use client';

import { useEffect, useRef } from 'react';
import { motion } from 'framer-motion';

export function ParticleBackground() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const mouseRef = useRef({ x: 0, y: 0 });
  const particlesRef = useRef<Particle[]>([]);

  class Particle {
    x: number;
    y: number;
    z: number;
    vx: number;
    vy: number;
    vz: number;
    size: number;
    color: string;
    pulse: number;

    constructor(width: number, height: number) {
      this.x = Math.random() * width;
      this.y = Math.random() * height;
      this.z = Math.random() * 1000;
      this.vx = (Math.random() - 0.5) * 0.5;
      this.vy = (Math.random() - 0.5) * 0.5;
      this.vz = (Math.random() - 0.5) * 2;
      this.size = Math.random() * 2 + 0.5;
      this.pulse = Math.random() * Math.PI * 2;
      
      const colors = ['#8b5cf6', '#3b82f6', '#06b6d4', '#ec4899', '#f97316'];
      this.color = colors[Math.floor(Math.random() * colors.length)];
    }

    update(width: number, height: number, mouseX: number, mouseY: number) {
      this.x += this.vx;
      this.y += this.vy;
      this.z += this.vz;
      this.pulse += 0.02;

      const dx = mouseX - this.x;
      const dy = mouseY - this.y;
      const distance = Math.sqrt(dx * dx + dy * dy);

      if (distance < 150) {
        const force = (150 - distance) / 150;
        this.vx -= (dx / distance) * force * 0.2;
        this.vy -= (dy / distance) * force * 0.2;
      }

      this.vx *= 0.99;
      this.vy *= 0.99;
      this.vz *= 0.99;

      if (this.x < 0 || this.x > width) this.vx *= -1;
      if (this.y < 0 || this.y > height) this.vy *= -1;
      if (this.z < 1 || this.z > 1000) {
        this.z = this.z < 1 ? 1000 : 1;
        this.x = Math.random() * width;
        this.y = Math.random() * height;
      }

      this.x = Math.max(0, Math.min(width, this.x));
      this.y = Math.max(0, Math.min(height, this.y));
    }

    draw(ctx: CanvasRenderingContext2D) {
      const scale = (1000 - this.z) / 1000;
      const opacity = scale * 0.8;
      const size = this.size * scale * (1 + Math.sin(this.pulse) * 0.2);

      ctx.save();
      ctx.globalAlpha = opacity;
      
      ctx.shadowBlur = 20 * scale;
      ctx.shadowColor = this.color;
      
      ctx.fillStyle = this.color;
      ctx.beginPath();
      ctx.arc(this.x, this.y, size, 0, Math.PI * 2);
      ctx.fill();

      ctx.shadowBlur = 40 * scale;
      ctx.globalAlpha = opacity * 0.3;
      ctx.beginPath();
      ctx.arc(this.x, this.y, size * 2, 0, Math.PI * 2);
      ctx.fill();

      ctx.restore();
    }
  }

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d', { alpha: true });
    if (!ctx) return;

    const handleResize = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
      
      const particleCount = Math.floor((canvas.width * canvas.height) / 15000);
      particlesRef.current = Array.from(
        { length: Math.min(particleCount, 150) },
        () => new Particle(canvas.width, canvas.height)
      );
    };

    const handleMouseMove = (e: MouseEvent) => {
      mouseRef.current = { x: e.clientX, y: e.clientY };
    };

    handleResize();
    window.addEventListener('resize', handleResize);
    window.addEventListener('mousemove', handleMouseMove);

    let animationFrameId: number;

    const animate = () => {
      if (!ctx || !canvas) return;
      
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const gradient = ctx.createRadialGradient(
        mouseRef.current.x,
        mouseRef.current.y,
        0,
        mouseRef.current.x,
        mouseRef.current.y,
        500
      );
      gradient.addColorStop(0, 'rgba(139, 92, 246, 0.05)');
      gradient.addColorStop(0.5, 'rgba(59, 130, 246, 0.02)');
      gradient.addColorStop(1, 'transparent');
      
      ctx.fillStyle = gradient;
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      particlesRef.current.forEach(particle => {
        particle.update(canvas.width, canvas.height, mouseRef.current.x, mouseRef.current.y);
        particle.draw(ctx);
      });

      for (let i = 0; i < particlesRef.current.length; i++) {
        for (let j = i + 1; j < particlesRef.current.length; j++) {
          const dx = particlesRef.current[i].x - particlesRef.current[j].x;
          const dy = particlesRef.current[i].y - particlesRef.current[j].y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < 100) {
            const opacity = (1 - distance / 100) * 0.15;
            ctx.strokeStyle = `rgba(139, 92, 246, ${opacity})`;
            ctx.lineWidth = 0.5;
            ctx.beginPath();
            ctx.moveTo(particlesRef.current[i].x, particlesRef.current[i].y);
            ctx.lineTo(particlesRef.current[j].x, particlesRef.current[j].y);
            ctx.stroke();
          }
        }
      }

      animationFrameId = requestAnimationFrame(animate);
    };

    animate();

    return () => {
      window.removeEventListener('resize', handleResize);
      window.removeEventListener('mousemove', handleMouseMove);
      cancelAnimationFrame(animationFrameId);
    };
  }, []);

  return (
    <>
      <canvas
        ref={canvasRef}
        className="fixed inset-0 pointer-events-none z-0"
        style={{ background: 'transparent' }}
      />
      <div className="fixed inset-0 pointer-events-none z-0">
        <div className="absolute inset-0 bg-gradient-to-br from-purple-900/20 via-blue-900/20 to-cyan-900/20 animate-gradient" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_left,_var(--tw-gradient-stops))] from-purple-600/10 via-transparent to-transparent" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_bottom_right,_var(--tw-gradient-stops))] from-cyan-600/10 via-transparent to-transparent" />
      </div>
      <motion.div
        className="fixed inset-0 pointer-events-none z-0"
        animate={{
          background: [
            'radial-gradient(circle at 20% 50%, rgba(139, 92, 246, 0.05) 0%, transparent 50%)',
            'radial-gradient(circle at 80% 50%, rgba(59, 130, 246, 0.05) 0%, transparent 50%)',
            'radial-gradient(circle at 50% 50%, rgba(236, 72, 153, 0.05) 0%, transparent 50%)',
            'radial-gradient(circle at 20% 50%, rgba(139, 92, 246, 0.05) 0%, transparent 50%)',
          ],
        }}
        transition={{
          duration: 10,
          repeat: Infinity,
          ease: 'linear',
        }}
      />
    </>
  );
}