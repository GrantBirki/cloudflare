# Change origin for an API route
resource "cloudflare_ruleset" "security_response_headers" {
  zone_id     = var.CLOUDFLARE_ZONE_ID
  name        = "Security Response Headers"
  description = "Sets security response headers"
  kind        = "zone"
  phase       = "http_response_headers_transform"

  rules {
    action = "rewrite"
    action_parameters {
      headers {
        name      = "X-Frame-Options"
        value     = "DENY"
        operation = "set"
      }
      headers {
        name      = "X-XSS-Protection"
        value     = "1; mode=block"
        operation = "set"
      }
      headers {
        name      = "Content-Security-Policy"
        value     = "img-src 'self' https://assets.tarkov.dev data: https://images.weserv.nl; style-src 'self' https://tarkov.dev https://discord.com 'unsafe-inline'; font-src 'self' https://tarkov.dev https://discord.com;"
        operation = "set"
      }
    }
    expression  = "(not http.host contains \"api\")"
    enabled     = true
    description = "Sets security response headers"
  }
}