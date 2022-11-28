locals {
  alb_service_account_name      = "alb-ingress-controller"
  alb_service_account_namespace = "kube-system"
}

# See https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

data "http" "alb_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${trimprefix(var.oidc_issuer_url, "https://")}:sub"
      values   = ["system:serviceaccount:${local.alb_service_account_namespace}:${local.alb_service_account_name}"]
    }
  }
}

resource "aws_iam_role" "alb" {
  name               = "eks_alb"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

resource "aws_iam_policy" "alb" {
  name        = "eks_alb"
  path        = "/"
  description = "Application load balancer for EKS"

  policy = data.http.alb_iam_policy.body
}

resource "aws_iam_role_policy_attachment" "alb" {
  role       = aws_iam_role.alb.name
  policy_arn = aws_iam_policy.alb.arn
}

# See https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.8/docs/examples/rbac-role.yaml

resource "kubernetes_service_account" "alb" {
  metadata {
    name      = local.alb_service_account_name
    namespace = local.alb_service_account_namespace
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "Helm"

    }
    annotations = {
      "eks.amazonaws.com/role-arn"     = aws_iam_role.alb.arn
      "meta.helm.sh/release-name"      = "alb-ingress-controller"
      "meta.helm.sh/release-namespace" = "kube-system"
    }
  }
}

resource "kubernetes_cluster_role" "alb" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  rule {
    api_groups = ["", "extensions", "networking.k8s.io", "elbv2.k8s.aws"]
    resources = [
      "configmaps",
      "endpoints",
      "events",
      "ingresses",
      "ingresses/status",
      "services",
      "pods/status",
      "targetgroupbindings"
    ]
    verbs = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "alb" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.alb.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.alb.metadata[0].name
    namespace = "kube-system"
  }
}

// Instructions for installing alb-ingress : https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller

data "http" "TargetGroupBinding_crds" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"
}

data "kubectl_file_documents" "manifests" {
  content = data.http.TargetGroupBinding_crds.body
}

resource "kubectl_manifest" "TargetGroupBinding_crds" {
  count     = length(data.kubectl_file_documents.manifests.documents)
  yaml_body = element(data.kubectl_file_documents.manifests.documents, count.index)
}

resource "helm_release" "alb-ingress-controller" {
  name       = "alb-ingress-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb.metadata[0].name
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  set {
    name  = "region"
    value = var.region
  }

  depends_on = [kubectl_manifest.TargetGroupBinding_crds]
}


