import { NextResponse } from 'next/server';
import { runQuery } from '@/lib/bigquery';

export async function GET() {
  try {
    const queries = {
      totalReports: 'SELECT COUNT(*) as count FROM epilink-blr.epilink_blr.symptom_reports',
      activeWards: 'SELECT COUNT(DISTINCT ward_id) as count FROM epilink-blr.epilink_blr.ward_risk_scores WHERE risk_score > 0.5',
      criticalWards: "SELECT ward_name FROM epilink-blr.epilink_blr.ward_risk_scores WHERE risk_level = 'critical' AND score_date = '2023-10-20'",
      avgRiskScore: "SELECT AVG(risk_score) as avg FROM epilink-blr.epilink_blr.ward_risk_scores WHERE score_date = '2023-10-20'",
    };

    const [reports, active, critical, avg] = await Promise.all([
      runQuery(queries.totalReports),
      runQuery(queries.activeWards),
      runQuery(queries.criticalWards),
      runQuery(queries.avgRiskScore),
    ]);

    return NextResponse.json({
      totalReports: reports[0].count,
      activeWards: active[0].count,
      criticalWards: critical.map((r: any) => r.ward_name),
      avgRiskScore: avg[0].avg,
      pendingAlerts: critical.length,
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
