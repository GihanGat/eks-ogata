data "aws_acm_certificate" "cert" {
  domain      = "spring-petclinic.ogata.ca"
  statuses    = ["ISSUED"]
  most_recent = true
}

locals {
  ogata_ci = "ogata.ca"
}

data "aws_route53_zone" "ogata_ca" {
  name = local.ogata_ci
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.ogata_ca.zone_id
  name    = "spring-petclinic.ogata.ca"
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_ingress_v1.myapp_ingress.status.0.load_balancer.0.ingress.0.hostname]
}

resource "kubernetes_ingress_v1" "myapp_ingress" {
  wait_for_load_balancer = true

  metadata {
    name      = "spring-petclinic-ingress"
    namespace = var.kubernetes_namespace
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.cert.arn
      "alb.ingress.kubernetes.io/listen-ports"    = <<JSON
[
	{
		"HTTPS": 443
	}
]
JSON
    }
  }

  spec {
    rule {
      host = "spring-petclinic.ogata.ca"
      http {
        path {
          backend {
            service {
              name = "spring-petclinic-todo-app-helm"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
