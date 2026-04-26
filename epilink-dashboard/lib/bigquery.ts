import { BigQuery } from '@google-cloud/bigquery';

const bigqueryClient = new BigQuery({
  keyFilename: process.env.GOOGLE_APPLICATION_CREDENTIALS,
  projectId: process.env.GCP_PROJECT_ID,
});

export async function runQuery(sql: string, params: any = {}) {
  const options = {
    query: sql,
    params: params,
    location: 'asia-south1',
  };

  const [rows] = await bigqueryClient.query(options);
  return rows;
}

export { bigqueryClient };
