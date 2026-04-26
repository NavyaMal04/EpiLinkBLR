import { NextResponse } from 'next/server';
import { runQuery } from '@/lib/bigquery';

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  let date = searchParams.get('date');

  try {
    if (!date) {
      // Find peak date
      const peakDateQuery = `
        SELECT score_date, AVG(risk_score) as avg_risk
        FROM epilink-blr.epilink_blr.ward_risk_scores
        GROUP BY score_date
        ORDER BY avg_risk DESC
        LIMIT 1
      `;
      const peakRows = await runQuery(peakDateQuery);
      if (peakRows.length > 0) {
        date = peakRows[0].score_date.value;
      }
    }

    const query = `
      SELECT ward_id, ward_name, risk_score, risk_level,
             predicted_cases_14d, contributing_factors
      FROM epilink-blr.epilink_blr.ward_risk_scores
      WHERE score_date = @date
      ORDER BY risk_score DESC
    `;
    
    const rows = await runQuery(query, { date });
    return NextResponse.json(rows);
  } catch (error: any) {
    console.error('BigQuery Error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
