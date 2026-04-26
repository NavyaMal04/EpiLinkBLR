'use client';

import React, { useState, useEffect, useCallback } from 'react';
import { Play, Pause, RotateCcw, Calendar } from 'lucide-react';
import { format, addDays, startOfToday, parseISO } from 'date-fns';

interface DateSliderProps {
  onDateChange: (date: string) => void;
}

export default function DateSlider({ onDateChange }: DateSliderProps) {
  const startDate = new Date('2023-09-01');
  const [daysOffset, setDaysOffset] = useState(49); // Start at Oct 20 peak
  const [isPlaying, setIsPlaying] = useState(false);

  const currentDate = addDays(startDate, daysOffset);
  const dateStr = format(currentDate, 'yyyy-MM-dd');

  useEffect(() => {
    onDateChange(dateStr);
  }, [dateStr, onDateChange]);

  useEffect(() => {
    let interval: any;
    if (isPlaying) {
      interval = setInterval(() => {
        setDaysOffset((prev) => {
          if (prev >= 90) {
            setIsPlaying(false);
            return prev;
          }
          return prev + 1;
        });
      }, 300);
    }
    return () => clearInterval(interval);
  }, [isPlaying]);

  return (
    <div className="bg-slate-900 p-6 rounded-2xl border border-slate-800 shadow-2xl">
      <div className="flex items-center gap-6">
        {/* Controls */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => setIsPlaying(!isPlaying)}
            className={`w-12 h-12 flex items-center justify-center rounded-xl transition-all shadow-lg ${
              isPlaying ? 'bg-amber-500 text-white' : 'bg-emerald-600 text-white hover:bg-emerald-700'
            }`}
          >
            {isPlaying ? <Pause size={24} fill="currentColor" /> : <Play size={24} fill="currentColor" className="ml-1" />}
          </button>
          <button
            onClick={() => { setDaysOffset(0); setIsPlaying(false); }}
            className="w-12 h-12 flex items-center justify-center bg-slate-800 text-slate-400 hover:text-white rounded-xl transition-colors"
          >
            <RotateCcw size={20} />
          </button>
        </div>

        {/* Date Display */}
        <div className="min-w-[200px]">
          <div className="flex items-center gap-2 text-emerald-400 font-black text-xs uppercase tracking-[0.2em] mb-1">
            <Calendar size={12} />
            Target Analysis Period
          </div>
          <div className="text-2xl font-black text-white tracking-tight">
            {format(currentDate, 'MMMM d, yyyy')}
          </div>
        </div>

        {/* Slider */}
        <div className="flex-1 px-4 group">
          <input
            type="range"
            min="0"
            max="90"
            value={daysOffset}
            onChange={(e) => setDaysOffset(parseInt(e.target.value))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-emerald-500 group-hover:bg-slate-700 transition-colors"
          />
          <div className="flex justify-between mt-3 text-[10px] font-black text-slate-500 uppercase tracking-widest">
            <span>Sept 01</span>
            <span className={daysOffset > 30 && daysOffset < 60 ? 'text-amber-500' : ''}>Outbreak Peak (Oct 20)</span>
            <span>Nov 30</span>
          </div>
        </div>
      </div>
    </div>
  );
}
