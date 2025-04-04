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
      # Note: headers must be in alphabetical order or you will have endless terraform plans changing state
      headers {
        name      = "Content-Security-Policy"
        value     = "img-src 'self' https://assets.tarkov.dev https://avatars.githubusercontent.com data: https://images.weserv.nl https://imagemagic.tarkov.dev; frame-src 'self' https://discord.com https://challenges.cloudflare.com; style-src 'self' https://tarkov.dev https://discord.com 'unsafe-inline'; font-src 'self' https://tarkov.dev https://discord.com; form-action 'self'; script-src 'self' *.cloudflareinsights.com https://challenges.cloudflare.com wombatstats.com discord.com js-agent.newrelic.com bam.nr-data.net bam-cell.nr-data.net 'unsafe-inline'; object-src 'none'; base-uri 'self'; "
        operation = "set"
      }
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
    }
    expression  = "(not http.host contains \"api\" and not http.host contains \"manager\" and not http.host contains \"status\" and not http.host contains \"player\")"
    enabled     = true
    description = "Sets security response headers"
  }

  rules {
    action = "rewrite"
    action_parameters {
      # Note: headers must be in alphabetical order or you will have endless terraform plans changing state
      headers {
        name      = "Access-Control-Allow-Origin"
        value     = "*"
        operation = "set"
      }
    }
    expression  = "(http.host eq \"player.tarkov.dev\")"
    enabled     = true
    description = "Add CORS header to player API"
  }
}
