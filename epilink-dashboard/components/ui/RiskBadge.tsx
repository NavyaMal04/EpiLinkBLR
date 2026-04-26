import React from 'react';
import { getRiskLabel, getRiskTextColor, getRiskBgColor } from '@/lib/riskColors';

interface RiskBadgeProps {
  score: number;
}

export default function RiskBadge({ score }: RiskBadgeProps) {
  return (
    <span className={`px-2 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border border-current opacity-80 ${getRiskBgColor(score)} ${getRiskTextColor(score)}`}>
      {getRiskLabel(score)}
    </span>
  );
}
