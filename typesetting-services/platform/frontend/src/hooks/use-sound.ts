'use client';

import { useCallback, useRef, useEffect } from 'react';

interface UseSoundOptions {
  volume?: number;
  playbackRate?: number;
  interrupt?: boolean;
  soundEnabled?: boolean;
  onend?: () => void;
}

export function useSound(
  url: string,
  {
    volume = 1,
    playbackRate = 1,
    interrupt = false,
    soundEnabled = true,
    onend,
  }: UseSoundOptions = {}
) {
  const audioRef = useRef<HTMLAudioElement | null>(null);

  useEffect(() => {
    if (typeof window !== 'undefined' && soundEnabled) {
      audioRef.current = new Audio(url);
      audioRef.current.volume = volume;
      audioRef.current.playbackRate = playbackRate;
      
      if (onend) {
        audioRef.current.addEventListener('ended', onend);
      }

      return () => {
        if (audioRef.current) {
          audioRef.current.pause();
          audioRef.current.src = '';
          if (onend) {
            audioRef.current.removeEventListener('ended', onend);
          }
          audioRef.current = null;
        }
      };
    }
  }, [url, volume, playbackRate, soundEnabled, onend]);

  const play = useCallback(() => {
    if (audioRef.current && soundEnabled) {
      if (interrupt) {
        audioRef.current.currentTime = 0;
      }
      
      const playPromise = audioRef.current.play();
      
      if (playPromise !== undefined) {
        playPromise.catch(error => {
          console.log('Audio play failed:', error);
        });
      }
    }
  }, [interrupt, soundEnabled]);

  const stop = useCallback(() => {
    if (audioRef.current) {
      audioRef.current.pause();
      audioRef.current.currentTime = 0;
    }
  }, []);

  const pause = useCallback(() => {
    if (audioRef.current) {
      audioRef.current.pause();
    }
  }, []);

  return { play, stop, pause };
}