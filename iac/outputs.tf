output "kv_namespace_id" {
  description = "Resume KV namespace ID"
  value       = cloudflare_workers_kv_namespace.resume.id
}
