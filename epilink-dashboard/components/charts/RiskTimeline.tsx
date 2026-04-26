'use client';

import React, { useState, useEffect } from 'react';
import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  ReferenceLine,
  Legend,
  AreaChart,
  Area
} from 'recharts';
import { format, parseISO } from 'date-fns';

interface TimelineProps {
  wardId?: string;
  wardName: string;
}

export default function RiskTimeline({ wardId, wardName }: TimelineProps) {
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      try {
        const url = wardId ? `/api/timeline?wardId=${wardId}` : '/api/timeline';
        const res = await fetch(url);
        const json = await res.json();
        setData(json);
      } catch (err) {
        console.error('Failed to fetch timeline:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, [wardId]);

  if (loading) {
    return <div className="w-full h-[300px] bg-white rounded-2xl border border-slate-200 animate-pulse flex items-center justify-center text-slate-400 font-medium">Loading analysis...</div>;
  }

  return (
    <div className="bg-white p-8 rounded-2xl border border-slate-200 shadow-sm">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h3 className="text-xl font-black text-slate-900 tracking-tight">Risk & Case Prediction Trend</h3>
          <p className="text-sm font-bold text-slate-400 uppercase tracking-widest">{wardName}</p>
        </div>
        <div className="flex gap-4">
          <div className="flex items-center gap-2">
            <div className="w-3 h-3 rounded-full bg-emerald-500"></div>
            <span className="text-xs font-bold text-slate-600">Risk Score</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-3 h-3 rounded-full border-2 border-slate-300 border-dashed bg-transparent"></div>
            <span className="text-xs font-bold text-slate-600">Predicted Cases</span>
          </div>
        </div>
      </div>

      <div className="h-[300px] w-full">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data}>
            <defs>
              <linearGradient id="colorRisk" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor="#10b981" stopOpacity={0.3}/>
                <stop offset="95%" stopColor="#10b981" stopOpacity={0}/>
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
            <XAxis 
              dataKey="date" 
              axisLine={false}
              tickLine={false}
              tick={{ fontSize: 10, fontWeight: 700, fill: '#94a3b8' }}
              tickFormatter={(str) => format(parseISO(str), 'MMM dd')}
              minTickGap={30}
            />
            <YAxis 
              yAxisId="left"
              domain={[0, 1.1]} 
              axisLine={false}
              tickLine={false}
              tick={{ fontSize: 10, fontWeight: 700, fill: '#94a3b8' }}
            />
            <YAxis 
              yAxisId="right"
              orientation="right"
              axisLine={false}
              tickLine={false}
              tick={{ fontSize: 10, fontWeight: 700, fill: '#94a3b8' }}
            />
            <Tooltip 
              contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)', padding: '12px' }}
              labelStyle={{ fontWeight: 800, marginBottom: '4px', color: '#1e293b' }}
              labelFormatter={(label) => format(parseISO(label), 'MMMM dd, yyyy')}
            />
            <ReferenceLine 
              yAxisId="left"
              y={0.8} 
              stroke="#ef4444" 
              strokeDasharray="5 5" 
              label={{ position: 'right', value: 'CRITICAL', fill: '#ef4444', fontSize: 10, fontWeight: 900 }} 
            />
            <Area
              yAxisId="left"
              type="monotone"
              dataKey="riskScore"
              stroke="#10b981"
              strokeWidth={4}
              fillOpacity={1}
              fill="url(#colorRisk)"
              dot={false}
              activeDot={{ r: 6, strokeWidth: 0, fill: '#10b981' }}
              name="Risk Score"
            />
            <Line
              yAxisId="right"
              type="monotone"
              dataKey="cases"
              stroke="#cbd5e1"
              strokeWidth={2}
              strokeDasharray="5 5"
              dot={false}
              name="Predicted Cases"
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
