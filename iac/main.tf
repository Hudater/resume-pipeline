terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  cloud {
    hostname     = "app.terraform.io"
    organization = "homelab_hudater"
    workspaces {
      name = "resume-pipeline"
    }
  }
}

provider "cloudflare" {
  api_token = var.cf_edit_all_api_token
}

resource "cloudflare_workers_kv_namespace" "resume" {
  account_id = var.cloudflare_account_id
  title      = "resume-kv"
}

resource "cloudflare_worker_script" "resume" {
  account_id = var.cloudflare_account_id
  name       = "resume-worker"
  module     = true
  content    = <<-EOF
    const PDF_KEY = "Censored_Harshit_SRE_Infrastructure_DevOps_Resume.pdf";

    export default {
      async fetch(request, env) {
        const url = new URL(request.url);

        if (url.pathname === "/" || url.pathname === "/" + PDF_KEY) {
          const pdf = await env.RESUME_KV.get(PDF_KEY, { type: "arrayBuffer" });

          if (!pdf) return new Response("Resume not found", { status: 404 });

          return new Response(pdf, {
            headers: {
              "Content-Type": "application/pdf",
              "Content-Disposition": "inline; filename=" + PDF_KEY,
              "Cache-Control": "public, max-age=3600",
            },
          });
        }

        return new Response("Not found", { status: 404 });
      },
    };
  EOF

  kv_namespace_binding {
    name         = "RESUME_KV"
    namespace_id = cloudflare_workers_kv_namespace.resume.id
  }
}

resource "cloudflare_worker_domain" "resume" {
  account_id = var.cloudflare_account_id
  hostname   = "resume.hudater.dev"
  service    = cloudflare_worker_script.resume.name
  zone_id    = var.zone_id_hudater_dev
  # override_existing_dns_record = true
}

resource "cloudflare_ruleset" "resume_redirect" {
  zone_id = var.zone_id_hudater_dev
  name    = "resume-redirect"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules {
    action = "redirect"
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = "https://resume.hudater.dev"
        }
        preserve_query_string = false
      }
    }
    expression  = "(http.host eq \"links.hudater.dev\" and http.request.uri.path eq \"/assets/Censored_Harshit_SRE_Infrastructure_DevOps_Resume.pdf\")"
    description = "Redirect old resume path"
    enabled     = true
  }
}