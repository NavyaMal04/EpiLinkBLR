'use client';

import React, { useState, useEffect } from 'react';
import { 
  FileText, 
  Activity, 
  AlertTriangle, 
  Users,
  Zap
} from 'lucide-react';
import StatCard from '@/components/panels/StatCard';
import EpiLinkMap from '@/components/map/EpiLinkMap';
import RiskTimeline from '@/components/charts/RiskTimeline';
import GeminiPanel from '@/components/panels/GeminiPanel';
import AlertFeed from '@/components/panels/AlertFeed';
import DateSlider from '@/components/ui/DateSlider';

export default function DashboardPage() {
  const [selectedDate, setSelectedDate] = useState('2023-10-20');
  const [selectedWard, setSelectedWard] = useState<{id: string, name: string}>({ id: '', name: 'Bengaluru Average' });
  const [riskScores, setRiskScores] = useState<any[]>([]);
  const [summaryStats, setSummaryStats] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchDashboardData() {
      setLoading(true);
      try {
        const [scoresRes, statsRes] = await Promise.all([
          fetch(`/api/risk-scores?date=${selectedDate}`),
          fetch('/api/summary-stats')
        ]);
        
        const scores = await scoresRes.json();
        const stats = await statsRes.json();
        
        setRiskScores(scores);
        setSummaryStats(stats);
      } catch (err) {
        console.error('Dashboard Fetch Error:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchDashboardData();
  }, [selectedDate]);

  const handleWardClick = (wardId: string) => {
    const ward = riskScores.find(s => s.ward_id === wardId);
    if (ward) {
      setSelectedWard({ id: wardId, name: ward.ward_name });
    }
  };

  return (
    <div className="space-y-8 max-w-[1600px] mx-auto">
      {/* Top Row: Stats and AI */}
      <div className="grid grid-cols-12 gap-8 items-stretch">
        <div className="col-span-12 lg:col-span-8 grid grid-cols-1 sm:grid-cols-2 gap-6">
          <StatCard 
            title="Total Reports Filed" 
            value={summaryStats?.totalReports?.toLocaleString() || '0'} 
            subtitle="+12% from previous month"
            icon={<FileText size={20} />}
            trend="up"
            loading={loading}
          />
          <StatCard 
            title="Critical Wards" 
            value={riskScores.filter(s => s.risk_level === 'critical').length} 
            subtitle="Immediate intervention needed"
            icon={<AlertTriangle size={20} />}
            critical={riskScores.some(s => s.risk_level === 'critical')}
            loading={loading}
          />
          <StatCard 
            title="Avg Risk Score" 
            value={`${((summaryStats?.avgRiskScore || 0) * 100).toFixed(0)}%`} 
            subtitle="City-wide baseline"
            icon={<Activity size={20} />}
            trend={summaryStats?.avgRiskScore > 0.5 ? 'up' : 'neutral'}
            loading={loading}
          />
          <StatCard 
            title="Pending Alerts" 
            value={summaryStats?.pendingAlerts || '0'} 
            subtitle="Awaiting deployment confirmation"
            icon={<Zap size={20} />}
            loading={loading}
          />
        </div>

        <div className="col-span-12 lg:col-span-4 h-[400px] lg:h-auto">
          <GeminiPanel context={{ riskScores, summaryStats }} />
        </div>
      </div>

      {/* Date Control */}
      <div className="w-full">
        <DateSlider onDateChange={setSelectedDate} />
      </div>

      {/* Map and Alerts */}
      <div className="grid grid-cols-12 gap-8 h-[600px] items-stretch">
        <div className="col-span-12 lg:col-span-8 h-full">
          <EpiLinkMap riskScores={riskScores} onWardClick={handleWardClick} />
        </div>
        <div className="col-span-12 lg:col-span-4 h-full">
          <AlertFeed riskScores={riskScores} selectedDate={selectedDate} />
        </div>
      </div>

      {/* Timeline Chart */}
      <div className="w-full pb-8">
        <RiskTimeline wardId={selectedWard.id} wardName={selectedWard.name} />
      </div>
    </div>
  );
}
