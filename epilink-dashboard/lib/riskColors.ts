export function getRiskColor(score: number): string {
  if (score < 0.3) return '#22c55e'; // green
  if (score < 0.6) return '#f59e0b'; // amber
  if (score < 0.8) return '#f97316'; // orange
  return '#ef4444'; // red
}

export function getRiskOpacity(score: number): number {
  if (score < 0.3) return 0.35;
  if (score < 0.6) return 0.50;
  if (score < 0.8) return 0.65;
  return 0.80;
}

export function getRiskLabel(score: number): 'Low' | 'Medium' | 'High' | 'Critical' {
  if (score < 0.3) return 'Low';
  if (score < 0.6) return 'Medium';
  if (score < 0.8) return 'High';
  return 'Critical';
}

export function getRiskTextColor(score: number): string {
  if (score < 0.3) return 'text-green-600';
  if (score < 0.6) return 'text-amber-600';
  if (score < 0.8) return 'text-orange-600';
  return 'text-red-600';
}

export function getRiskBgColor(score: number): string {
  if (score < 0.3) return 'bg-green-100';
  if (score < 0.6) return 'bg-amber-100';
  if (score < 0.8) return 'bg-orange-100';
  return 'bg-red-100';
}
