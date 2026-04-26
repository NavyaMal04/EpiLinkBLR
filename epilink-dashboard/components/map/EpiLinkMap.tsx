'use client';

import React, { useEffect, useRef, useCallback } from 'react';
import { WARD_BOUNDARIES } from '@/lib/wardBoundaries';
import { getRiskColor, getRiskOpacity, getRiskLabel } from '@/lib/riskColors';

interface MapProps {
  riskScores: any[];
  onWardClick: (wardId: string) => void;
}

declare global {
  interface Window {
    google?: any;
    _epilinkMapInit?: () => void;
  }
}

const MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || '';

export default function EpiLinkMap({ riskScores, onWardClick }: MapProps) {
  const mapRef = useRef<HTMLDivElement>(null);
  const mapObjRef = useRef<any>(null);
  const rectanglesRef = useRef<{ [key: string]: any }>({});
  const infoWindowRef = useRef<any>(null);
  const initializedRef = useRef(false);

  const drawWards = useCallback(() => {
    const g = window.google;
    if (!g || !mapObjRef.current) return;

    // Clear existing rectangles
    Object.values(rectanglesRef.current).forEach((r: any) => r.setMap(null));
    rectanglesRef.current = {};

    WARD_BOUNDARIES.forEach(ward => {
      const scoreData = riskScores.find(s => s.ward_id === ward.wardId) || { risk_score: 0.1 };
      const score = scoreData.risk_score;

      const rect = new g.maps.Rectangle({
        bounds: ward.bounds,
        editable: false,
        draggable: false,
        fillColor: getRiskColor(score),
        fillOpacity: getRiskOpacity(score),
        strokeColor: '#FFFFFF',
        strokeOpacity: 0.8,
        strokeWeight: 1,
        map: mapObjRef.current,
      });

      rect.addListener('mouseover', () => {
        rect.setOptions({ fillOpacity: Math.min(getRiskOpacity(score) + 0.2, 1) });
        if (infoWindowRef.current) {
          infoWindowRef.current.setContent(`
            <div style="padding:12px;font-family:sans-serif;color:#1e293b;min-width:180px">
              <h3 style="margin:0 0 8px;font-weight:800;font-size:13px;text-transform:uppercase;color:#64748b">${ward.wardName}</h3>
              <div style="margin-bottom:4px"><span style="font-weight:600">Risk:</span> <span style="color:${getRiskColor(score)};font-weight:800">${getRiskLabel(score).toUpperCase()}</span></div>
              <div style="margin-bottom:4px"><span style="font-weight:600">Score:</span> ${(score * 100).toFixed(0)}%</div>
              <div style="margin-bottom:4px"><span style="font-weight:600">Predicted Cases (14d):</span> ${scoreData.predicted_cases_14d ?? 0}</div>
              ${scoreData.contributing_factors ? `<div style="font-size:11px;margin-top:8px;color:#94a3b8"><strong>Factors:</strong> ${scoreData.contributing_factors}</div>` : ''}
            </div>
          `);
          infoWindowRef.current.setPosition(ward.center);
          infoWindowRef.current.open(mapObjRef.current);
        }
      });

      rect.addListener('mouseout', () => {
        rect.setOptions({ fillOpacity: getRiskOpacity(score) });
        infoWindowRef.current?.close();
      });

      rect.addListener('click', () => onWardClick(ward.wardId));

      rectanglesRef.current[ward.wardId] = rect;
    });
  }, [riskScores, onWardClick]);

  // Initialize map once
  useEffect(() => {
    if (initializedRef.current) return;
    initializedRef.current = true;

    const initMap = () => {
      if (!mapRef.current || !window.google) return;
      const g = window.google;
      mapObjRef.current = new g.maps.Map(mapRef.current, {
        center: { lat: 12.97, lng: 77.59 },
        zoom: 11,
        styles: darkMapStyle,
        disableDefaultUI: true,
        zoomControl: true,
      });
      infoWindowRef.current = new g.maps.InfoWindow();
      drawWards();
    };

    if (window.google) {
      initMap();
    } else {
      // Load Maps JS API via script tag (the reliable way)
      const callbackName = '_epilinkMapInit';
      window[callbackName] = initMap;
      const script = document.createElement('script');
      script.src = `https://maps.googleapis.com/maps/api/js?key=${MAPS_API_KEY}&callback=${callbackName}&loading=async`;
      script.async = true;
      document.head.appendChild(script);
    }
  }, [drawWards]);

  // Re-draw when riskScores change (e.g. date slider)
  useEffect(() => {
    if (mapObjRef.current && window.google) {
      drawWards();
    }
  }, [drawWards]);

  return (
    <div className="relative w-full h-full rounded-2xl overflow-hidden border border-slate-200 shadow-inner bg-slate-800">
      <div ref={mapRef} className="w-full h-full" />

      {/* Legend */}
      <div className="absolute bottom-6 left-6 bg-white/90 backdrop-blur-sm p-4 rounded-xl border border-slate-200 shadow-lg pointer-events-none z-10">
        <h4 className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">Risk Legend</h4>
        <div className="space-y-2">
          {[['#ef4444', 'Critical'], ['#f97316', 'High'], ['#f59e0b', 'Medium'], ['#22c55e', 'Low']].map(([color, label]) => (
            <div key={label} className="flex items-center gap-3">
              <div className="w-4 h-4 rounded-sm" style={{ backgroundColor: color, opacity: 0.8 }} />
              <span className="text-xs font-bold text-slate-700">{label}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

const darkMapStyle = [
  { elementType: 'geometry', stylers: [{ color: '#212121' }] },
  { elementType: 'labels.icon', stylers: [{ visibility: 'off' }] },
  { elementType: 'labels.text.fill', stylers: [{ color: '#757575' }] },
  { elementType: 'labels.text.stroke', stylers: [{ color: '#212121' }] },
  { featureType: 'administrative.locality', elementType: 'labels.text.fill', stylers: [{ color: '#bdbdbd' }] },
  { featureType: 'poi', elementType: 'labels.text.fill', stylers: [{ color: '#757575' }] },
  { featureType: 'poi.park', elementType: 'geometry', stylers: [{ color: '#181818' }] },
  { featureType: 'road', elementType: 'geometry.fill', stylers: [{ color: '#2c2c2c' }] },
  { featureType: 'road', elementType: 'labels.text.fill', stylers: [{ color: '#8a8a8a' }] },
  { featureType: 'road.highway', elementType: 'geometry', stylers: [{ color: '#3c3c3c' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#000000' }] },
];
