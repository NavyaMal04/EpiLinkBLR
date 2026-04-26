import { GoogleGenerativeAI } from '@google/generative-ai';
import { NextResponse } from 'next/server';

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

export async function POST(req: Request) {
  try {
    const { message, context } = await req.json();

    const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });

    const systemPrompt = `
      You are EpiLink AI, a public health assistant for Bengaluru's disease 
      surveillance system. You have access to the following current outbreak 
      data: ${JSON.stringify(context)}. Answer questions concisely and 
      actionably. Focus on which wards need intervention and why. 
      Do not make up data not present in the context.
    `;

    const chat = model.startChat({
      history: [
        {
          role: 'user',
          parts: [{ text: systemPrompt }],
        },
        {
          role: 'model',
          parts: [{ text: 'Understood. I am ready to assist with the Bengaluru disease surveillance data.' }],
        },
      ],
    });

    const result = await chat.sendMessageStream(message);

    const stream = new ReadableStream({
      async start(controller) {
        for await (const chunk of result.stream) {
          const text = chunk.text();
          controller.enqueue(text);
        }
        controller.close();
      },
    });

    return new Response(stream);
  } catch (error: any) {
    console.error('Gemini API Error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
