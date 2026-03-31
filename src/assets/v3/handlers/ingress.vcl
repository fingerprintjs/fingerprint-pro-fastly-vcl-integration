sub proxy_identification_request {
  set req.url = querystring.add(req.url, "ii", "fingerprint-pro-fastly-vcl/__integration_version__/ingress");

  declare local var.cookie_iidt STRING;
  set var.cookie_iidt = req.http.cookie:_iidt;

  unset req.http.cookie;
  if (std.strlen(var.cookie_iidt) > 0) {
    set req.http.cookie:_iidt = var.cookie_iidt;
  }

  set req.http.FPJS-Proxy-Secret = table.lookup(__config_table_name__, "PROXY_SECRET");
  set req.http.FPJS-Proxy-Client-IP = req.http.fastly-client-ip;
  set req.http.FPJS-Proxy-Forwarded-Host = req.http.host;
  set req.url = "/?" + req.url.qs;
  set req.backend = F_api_fpjs_io;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = F_eu_api_fpjs_io;
  }
  if(querystring.get(req.url, "region") == "ap") {
    set req.backend = F_ap_api_fpjs_io;
  }

  return(pass);
}
