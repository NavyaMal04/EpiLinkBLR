import React from 'react';
import { ArrowUpRight, ArrowDownRight, Minus } from 'lucide-react';

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle: string;
  icon: React.ReactNode;
  trend?: 'up' | 'down' | 'neutral';
  critical?: boolean;
  loading?: boolean;
}

export default function StatCard({ 
  title, 
  value, 
  subtitle, 
  icon, 
  trend, 
  critical = false,
  loading = false
}: StatCardProps) {
  if (loading) {
    return (
      <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm animate-pulse">
        <div className="flex justify-between items-start mb-4">
          <div className="h-4 w-24 bg-slate-200 rounded"></div>
          <div className="w-10 h-10 bg-slate-200 rounded-full"></div>
        </div>
        <div className="h-8 w-16 bg-slate-200 rounded mb-2"></div>
        <div className="h-3 w-32 bg-slate-200 rounded"></div>
      </div>
    );
  }

  return (
    <div className={`bg-white p-6 rounded-xl border border-slate-200 shadow-sm transition-all hover:shadow-md ${
      critical ? 'border-l-4 border-l-red-500' : ''
    }`}>
      <div className="flex justify-between items-start mb-4">
        <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider">{title}</h3>
        <div className="p-2.5 bg-slate-50 rounded-xl text-slate-600 border border-slate-100">
          {icon}
        </div>
      </div>
      
      <div className="flex items-baseline gap-2 mb-1">
        <span className="text-3xl font-black text-slate-900">{value}</span>
        {trend && (
          <div className={`flex items-center text-xs font-bold ${
            trend === 'up' ? 'text-emerald-600' : trend === 'down' ? 'text-red-600' : 'text-slate-400'
          }`}>
            {trend === 'up' ? <ArrowUpRight size={14} /> : trend === 'down' ? <ArrowDownRight size={14} /> : <Minus size={14} />}
          </div>
        )}
      </div>
      
      <p className="text-sm font-semibold text-slate-400">{subtitle}</p>
    </div>
  );
}
