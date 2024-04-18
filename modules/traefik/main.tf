# Install traefik helm_chart
resource "helm_release" "traefik" {
  namespace        = var.namespace
  name             = "traefik"
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"
  create_namespace = true
  # If default_values == "" then apply default values from the chart if its anything else 
  # then apply values file using the values_file input variable
  values = [
    templatefile("${path.module}/traefik.yaml.tmpl", {
      use_nlb         = var.use_alb
}