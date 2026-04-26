export interface WardBoundary {
  wardId: string;
  wardName: string;
  center: { lat: number; lng: number };
  bounds: {
    north: number;
    south: number;
    east: number;
    west: number;
  };
}

const DELTA = 0.02;

export const WARD_BOUNDARIES: WardBoundary[] = [
  {
    wardId: 'ward_001',
    wardName: 'Yelahanka',
    center: { lat: 13.1007, lng: 77.5963 },
    bounds: { north: 13.1207, south: 13.0807, east: 77.6163, west: 77.5763 },
  },
  {
    wardId: 'ward_002',
    wardName: 'KR Puram',
    center: { lat: 13.0, lng: 77.695 },
    bounds: { north: 13.02, south: 12.98, east: 77.715, west: 77.675 },
  },
  {
    wardId: 'ward_003',
    wardName: 'Whitefield',
    center: { lat: 12.9698, lng: 77.7499 },
    bounds: { north: 12.9898, south: 12.9498, east: 77.7699, west: 77.7299 },
  },
  {
    wardId: 'ward_004',
    wardName: 'Hebbal',
    center: { lat: 13.035, lng: 77.597 },
    bounds: { north: 13.055, south: 13.015, east: 77.617, west: 77.577 },
  },
  {
    wardId: 'ward_005',
    wardName: 'Bommanahalli',
    center: { lat: 12.895, lng: 77.624 },
    bounds: { north: 12.915, south: 12.875, east: 77.644, west: 77.604 },
  },
  {
    wardId: 'ward_006',
    wardName: 'Koramangala',
    center: { lat: 12.935, lng: 77.624 },
    bounds: { north: 12.955, south: 12.915, east: 77.644, west: 77.604 },
  },
  {
    wardId: 'ward_007',
    wardName: 'HSR Layout',
    center: { lat: 12.911, lng: 77.640 },
    bounds: { north: 12.931, south: 12.891, east: 77.660, west: 77.620 },
  },
  {
    wardId: 'ward_008',
    wardName: 'Bellandur',
    center: { lat: 12.926, lng: 77.678 },
    bounds: { north: 12.946, south: 12.906, east: 77.698, west: 77.658 },
  },
  {
    wardId: 'ward_009',
    wardName: 'Mahadevapura',
    center: { lat: 12.990, lng: 77.714 },
    bounds: { north: 13.010, south: 12.970, east: 77.734, west: 77.694 },
  },
  {
    wardId: 'ward_010',
    wardName: 'Rajajinagar',
    center: { lat: 12.991, lng: 77.552 },
    bounds: { north: 13.011, south: 12.971, east: 77.572, west: 77.532 },
  },
];
