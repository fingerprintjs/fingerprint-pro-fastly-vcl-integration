sub handle_traffic_monitoring {
  set req.url = querystring.add(req.url, "ii", "fingerprint-pro-fastly-vcl/__integration_version__/ingress");
}
