'use client';

import React, { useState, useRef, useEffect } from 'react';
import { Send, Sparkles, User, Bot, Loader2 } from 'lucide-react';
import ReactMarkdown from 'react-markdown';

interface Message {
  role: 'user' | 'model';
  content: string;
}

interface GeminiPanelProps {
  context: any;
}

export default function GeminiPanel({ context }: GeminiPanelProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'model',
      content: "Hello. I have loaded today's outbreak data for Bengaluru. Ask me anything about current risk levels or recommended interventions."
    }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = async (text: string) => {
    if (!text.trim() || loading) return;

    const userMsg: Message = { role: 'user', content: text };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setLoading(true);

    try {
      const response = await fetch('/api/gemini', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text, context }),
      });

      if (!response.body) throw new Error('No response body');
      
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let done = false;
      let modelContent = '';

      const modelMsg: Message = { role: 'model', content: '' };
      setMessages(prev => [...prev, modelMsg]);

      while (!done) {
        const { value, done: doneReading } = await reader.read();
        done = doneReading;
        const chunkValue = decoder.decode(value);
        modelContent += chunkValue;
        
        setMessages(prev => {
          const last = prev[prev.length - 1];
          return [...prev.slice(0, -1), { ...last, content: modelContent }];
        });
      }
    } catch (err) {
      console.error('Chat Error:', err);
      setMessages(prev => [...prev, { role: 'model', content: 'Sorry, I encountered an error analyzing the data. Please try again.' }]);
    } finally {
      setLoading(false);
    }
  };

  const suggestions = [
    "Which wards need intervention this week?",
    "What's driving the Bellandur outbreak?",
    "Recommend resource deployment for next 14 days"
  ];

  return (
    <div className="flex flex-col h-full bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
      {/* Header */}
      <div className="p-4 bg-slate-900 text-white flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 bg-emerald-500 rounded-lg flex items-center justify-center">
            <Sparkles size={18} className="text-white" />
          </div>
          <span className="font-black tracking-tight">EpiLink AI</span>
        </div>
        <div className="flex items-center gap-1 px-2 py-0.5 bg-emerald-500/20 text-emerald-400 rounded text-[10px] font-bold uppercase tracking-widest border border-emerald-500/30">
          Gemini 2.0 Flash
        </div>
      </div>

      {/* Messages */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto p-4 space-y-6 scroll-smooth">
        {messages.map((m, i) => (
          <div key={i} className={`flex gap-3 ${m.role === 'user' ? 'flex-row-reverse' : ''}`}>
            <div className={`w-8 h-8 rounded-full flex shrink-0 items-center justify-center ${
              m.role === 'user' ? 'bg-emerald-100 text-emerald-600' : 'bg-slate-100 text-slate-600'
            }`}>
              {m.role === 'user' ? <User size={16} /> : <Bot size={16} />}
            </div>
            <div className={`max-w-[85%] p-4 rounded-2xl text-sm leading-relaxed ${
              m.role === 'user' 
                ? 'bg-emerald-600 text-white rounded-tr-none font-medium' 
                : 'bg-slate-50 text-slate-800 rounded-tl-none border border-slate-100 shadow-sm'
            }`}>
              <div className="prose prose-sm max-w-none prose-p:leading-relaxed prose-pre:bg-slate-800 prose-pre:text-white dark:prose-invert">
                <ReactMarkdown>
                  {m.content}
                </ReactMarkdown>
              </div>
            </div>
          </div>
        ))}
        {loading && (
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-slate-100 text-slate-600 flex shrink-0 items-center justify-center">
              <Bot size={16} />
            </div>
            <div className="bg-slate-50 p-4 rounded-2xl rounded-tl-none border border-slate-100 shadow-sm flex items-center gap-2">
              <Loader2 size={16} className="animate-spin text-slate-400" />
              <span className="text-xs font-bold text-slate-400 uppercase tracking-widest">Analyzing dataset...</span>
            </div>
          </div>
        )}
      </div>

      {/* Footer */}
      <div className="p-4 bg-white border-t border-slate-100">
        {messages.length === 1 && (
          <div className="mb-4 flex flex-wrap gap-2">
            {suggestions.map((s, i) => (
              <button
                key={i}
                onClick={() => handleSend(s)}
                className="text-[10px] font-bold text-slate-500 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-full border border-slate-200 transition-colors"
              >
                {s}
              </button>
            ))}
          </div>
        )}
        
        <div className="relative">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSend(input)}
            placeholder="Ask AI about outbreak risks..."
            className="w-full bg-slate-100 border-none rounded-xl py-3 pl-4 pr-12 text-sm font-medium placeholder:text-slate-400 focus:ring-2 focus:ring-emerald-500 focus:bg-white transition-all outline-none"
          />
          <button
            onClick={() => handleSend(input)}
            disabled={loading || !input.trim()}
            className="absolute right-2 top-1/2 -translate-y-1/2 p-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50 disabled:bg-slate-300 transition-colors shadow-sm"
          >
            <Send size={18} />
          </button>
        </div>
      </div>
    </div>
  );
}
