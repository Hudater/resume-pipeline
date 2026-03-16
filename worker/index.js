const PDF_KEY = "Censored_Harshit_SRE_Infrastructure_DevOps_Resume.pdf";

export default {
    async fetch(request, env) {
        const pdf = await env.RESUME_KV.get(PDF_KEY, { type: "arrayBuffer" });

        if (!pdf) return new Response("Resume not found", { status: 404 });

        return new Response(pdf, {
            headers: {
                "Content-Type": "application/pdf",
                "Content-Disposition": `inline; filename="${PDF_KEY}"`,
                "Cache-Control": "public, max-age=3600",
            },
        });
    },
};