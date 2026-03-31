sub handle_traffic_monitoring {
  if (is_authorized_request()) {
    set req.url = querystring.add(req.url, "ii", "fingerprint-pro-fastly-vcl/__integration_version__/ingress");
  }
}
