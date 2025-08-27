import { NextRequest } from "next/server";

export async function POST(request: NextRequest) {
  console.log("RPC Proxy: Received POST request");
  try {
    const body = await request.json();
    console.log("RPC Proxy: Request body:", body);
    const response = await fetch("https://rpc2.paseo.mandalachain.io", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
    console.log("RPC Proxy: Response status:", response.status);
    if (!response.ok) {
      const errorText = await response.text();
      console.error("RPC Proxy: Error response:", errorText);
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log("RPC Proxy: Success, returning data");
    return new Response(JSON.stringify(data), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
      },
    });
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : "Unknown error";
    console.error("RPC proxy error:", error);
    return new Response(
      JSON.stringify({
        error: "RPC call failed",
        details: errorMessage,
      }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
        },
      },
    );
  }
}

export async function GET() {
  return new Response(JSON.stringify({ error: "Method not allowed, use POST" }), {
    status: 405,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
