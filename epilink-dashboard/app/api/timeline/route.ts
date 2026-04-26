import { NextResponse } from 'next/server';
import { runQuery } from '@/lib/bigquery';

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const wardId = searchParams.get('wardId');

  try {
    let sql = '';
    let params = {};

    if (wardId) {
      sql = `
        SELECT score_date as date, risk_score as riskScore, predicted_cases_14d as cases
        FROM epilink-blr.epilink_blr.ward_risk_scores
        WHERE ward_id = @wardId
        ORDER BY score_date ASC
      `;
      params = { wardId };
    } else {
      sql = `
        SELECT score_date as date, AVG(risk_score) as riskScore, SUM(predicted_cases_14d) as cases
        FROM epilink-blr.epilink_blr.ward_risk_scores
        GROUP BY score_date
        ORDER BY score_date ASC
      `;
    }

    const rows = await runQuery(sql, params);
    
    const formattedRows = rows.map(r => ({
      date: r.date.value,
      riskScore: r.riskScore,
      cases: r.cases
    }));

    return NextResponse.json(formattedRows);
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
