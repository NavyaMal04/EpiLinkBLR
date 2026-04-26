import React from 'react';
import { 
  LayoutDashboard, 
  Bell, 
  FileText, 
  Settings,
  MapPin,
  Download
} from 'lucide-react';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const currentDate = new Date().toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  return (
    <div className="flex h-screen bg-slate-50 text-slate-900 overflow-hidden">
      {/* Sidebar */}
      <aside className="w-60 bg-slate-900 text-white flex flex-col shrink-0">
        <div className="p-6 flex items-center gap-3">
          <div className="w-8 h-8 bg-emerald-500 rounded-full flex items-center justify-center">
            <span className="text-white font-bold">E</span>
          </div>
          <h1 className="text-xl font-bold tracking-tight">EpiLink BLR</h1>
        </div>

        <nav className="flex-1 px-4 py-4 space-y-2">
          <NavItem icon={<LayoutDashboard size={20} />} label="Overview" active />
          <NavItem icon={<Bell size={20} />} label="Alerts" />
          <NavItem icon={<FileText size={20} />} label="Reports" />
          <NavItem icon={<Settings size={20} />} label="Settings" />
        </nav>

        <div className="p-6 border-t border-slate-800">
          <div className="flex items-center gap-2">
            <div className="relative">
              <div className="w-2 h-2 bg-emerald-500 rounded-full"></div>
              <div className="absolute inset-0 w-2 h-2 bg-emerald-500 rounded-full animate-ping opacity-75"></div>
            </div>
            <span className="text-sm font-medium text-slate-400 uppercase tracking-widest">Live</span>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0">
        {/* Header */}
        <header className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shrink-0">
          <h2 className="text-lg font-semibold text-slate-800">Outbreak Command Center</h2>
          
          <div className="flex items-center gap-6">
            <div className="flex items-center gap-2 px-3 py-1 bg-slate-100 rounded-full text-sm font-medium text-slate-600">
              <MapPin size={14} />
              <span>Bengaluru</span>
            </div>
            <span className="text-sm text-slate-500 font-medium">{currentDate}</span>
            <button className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-bold transition-colors">
              <Download size={16} />
              Export Report
            </button>
          </div>
        </header>

        {/* Page Content */}
        <div className="flex-1 overflow-y-auto p-8">
          {children}
        </div>
      </main>
    </div>
  );
}

function NavItem({ icon, label, active = false }: { icon: React.ReactNode, label: string, active?: boolean }) {
  return (
    <div className={`flex items-center gap-3 px-4 py-3 rounded-lg cursor-pointer transition-colors ${
      active ? 'bg-emerald-600 text-white' : 'hover:bg-slate-800 text-slate-400'
    }`}>
      {icon}
      <span className="font-semibold text-sm">{label}</span>
    </div>
  );
}
