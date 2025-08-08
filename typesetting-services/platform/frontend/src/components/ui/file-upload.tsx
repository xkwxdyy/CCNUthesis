'use client';

import * as React from 'react';
import { useDropzone } from 'react-dropzone';
import { cn } from '@/lib/utils';
import { Upload, FileText, X } from 'lucide-react';
import { Button } from './button';
import { motion, AnimatePresence } from 'framer-motion';

export interface FileUploadProps {
  accept?: Record<string, string[]>;
  maxFiles?: number;
  maxSize?: number;
  onDrop?: (acceptedFiles: File[]) => void;
  onRemove?: (file: File) => void;
  files?: File[];
  className?: string;
  disabled?: boolean;
}

export function FileUpload({
  accept = {
    'application/msword': ['.doc'],
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': ['.docx']
  },
  maxFiles = 1,
  maxSize = 10485760, // 10MB
  onDrop,
  onRemove,
  files = [],
  className,
  disabled = false,
}: FileUploadProps) {
  const { getRootProps, getInputProps, isDragActive, isDragReject } = useDropzone({
    accept,
    maxFiles,
    maxSize,
    onDrop: (acceptedFiles) => {
      onDrop?.(acceptedFiles);
    },
    disabled,
  });

  return (
    <div className={cn('w-full', className)}>
      <div
        {...getRootProps()}
        className={cn(
          'relative rounded-lg border-2 border-dashed p-8 text-center transition-all cursor-pointer',
          isDragActive && !isDragReject && 'border-primary bg-primary/5',
          isDragReject && 'border-destructive bg-destructive/5',
          !isDragActive && !isDragReject && 'border-muted-foreground/25 hover:border-primary/50 hover:bg-accent/50',
          disabled && 'opacity-50 cursor-not-allowed'
        )}
      >
        <input {...getInputProps()} />
        
        <div className="flex flex-col items-center justify-center space-y-4">
          <div className={cn(
            'rounded-full p-4 transition-colors',
            isDragActive && !isDragReject && 'bg-primary/10',
            isDragReject && 'bg-destructive/10',
            !isDragActive && !isDragReject && 'bg-muted'
          )}>
            <Upload className={cn(
              'h-8 w-8',
              isDragActive && !isDragReject && 'text-primary',
              isDragReject && 'text-destructive',
              !isDragActive && !isDragReject && 'text-muted-foreground'
            )} />
          </div>
          
          <div>
            <p className="text-sm font-medium">
              {isDragActive && !isDragReject && '释放文件以上传'}
              {isDragReject && '不支持的文件类型'}
              {!isDragActive && !isDragReject && '点击或拖拽文件到此处上传'}
            </p>
            <p className="mt-1 text-xs text-muted-foreground">
              支持 .doc, .docx 格式，最大 10MB
            </p>
          </div>
        </div>
      </div>

      {/* File List */}
      <AnimatePresence>
        {files.length > 0 && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="mt-4 space-y-2"
          >
            {files.map((file, index) => (
              <motion.div
                key={`${file.name}-${index}`}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                className="flex items-center justify-between rounded-lg border bg-card p-3"
              >
                <div className="flex items-center space-x-3">
                  <FileText className="h-5 w-5 text-primary" />
                  <div>
                    <p className="text-sm font-medium">{file.name}</p>
                    <p className="text-xs text-muted-foreground">
                      {(file.size / 1024 / 1024).toFixed(2)} MB
                    </p>
                  </div>
                </div>
                {onRemove && (
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => onRemove(file)}
                    className="h-8 w-8"
                  >
                    <X className="h-4 w-4" />
                  </Button>
                )}
              </motion.div>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}