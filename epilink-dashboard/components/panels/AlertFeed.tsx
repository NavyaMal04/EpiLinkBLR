'use client';

import React from 'react';
import { AlertCircle, CheckCircle2, MapPin, Syringe, Wind, Droplets } from 'lucide-react';
import { getRiskLabel, getRiskTextColor, getRiskBgColor } from '@/lib/riskColors';

interface AlertFeedProps {
  riskScores: any[];
  selectedDate: string;
}

export default function AlertFeed({ riskScores, selectedDate }: AlertFeedProps) {
  const criticalWards = riskScores.filter(s => s.risk_level === 'critical' || s.risk_score >= 0.8);

  const getSuggestedAction = (wardName: string) => {
    // Hardcoded logic as per disease pattern in prompt
    if (wardName === 'Whitefield' || wardName === 'Bellandur') {
      return { 
        action: "Deploy fogging units immediately", 
        icon: <Wind size={16} />,
        subtext: "High stagnant water reports & rainfall spike detected."
      };
    }
    return { 
      action: "Increase CHW survey frequency", 
      icon: <AlertCircle size={16} />,
      subtext: "Monitor for upward symptom trends in next 72h."
    };
  };

  return (
    <div className="bg-white rounded-2xl border border-slate-200 shadow-sm h-full flex flex-col overflow-hidden">
      <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
        <div>
          <h3 className="text-sm font-black text-slate-900 uppercase tracking-widest">Active Intervention Feed</h3>
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-1">Status as of {selectedDate}</p>
        </div>
        <div className="flex items-center gap-2 px-3 py-1 bg-red-50 text-red-600 rounded-full text-xs font-black">
          <AlertCircle size={14} />
          <span>{criticalWards.length} CRITICAL</span>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {criticalWards.length === 0 ? (
          <div className="h-full flex flex-col items-center justify-center text-center p-8">
            <div className="w-16 h-16 bg-emerald-50 text-emerald-500 rounded-full flex items-center justify-center mb-4">
              <CheckCircle2 size={32} />
            </div>
            <h4 className="font-bold text-slate-800">No Critical Alerts</h4>
            <p className="text-sm text-slate-500 mt-1">All ward parameters within baseline thresholds.</p>
          </div>
        ) : (
          criticalWards.map((ward, i) => {
            const suggestion = getSuggestedAction(ward.ward_name);
            return (
              <div key={i} className="group border border-slate-100 rounded-xl p-4 hover:border-red-200 hover:shadow-md transition-all border-l-4 border-l-red-500">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex items-center gap-2">
                    <MapPin size={14} className="text-slate-400" />
                    <span className="font-extrabold text-slate-800">{ward.ward_name}</span>
                  </div>
                  <div className={`px-2 py-0.5 rounded text-[10px] font-black uppercase tracking-widest ${getRiskBgColor(ward.risk_score)} ${getRiskTextColor(ward.risk_score)}`}>
                    {(ward.risk_score * 100).toFixed(0)}% Risk
                  </div>
                </div>

                <div className="bg-red-50/50 rounded-lg p-3 border border-red-100/50">
                  <div className="flex items-center gap-2 text-red-700 font-bold text-xs mb-1">
                    {suggestion.icon}
                    <span>Recommended Action</span>
                  </div>
                  <p className="text-sm font-black text-red-600 leading-tight">
                    {suggestion.action}
                  </p>
                  <p className="text-[10px] font-medium text-red-400 mt-2 italic leading-relaxed">
                    {suggestion.subtext}
                  </p>
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}
