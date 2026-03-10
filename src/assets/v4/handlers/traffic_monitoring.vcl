sub handle_traffic_monitoring {
  declare local var.handler_type STRING;
  set var.handler_type = "ingress";
  if (req.url.path ~ "^/web") {
    set var.handler_type = "procdn";
  }
  set req.url = querystring.add(req.url, "ii", "fingerprint-pro-fastly-vcl/__integration_version__/" + var.handler_type);
}
