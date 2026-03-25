sub handle_proxy_headers {
  if (is_authorized_request()) {
    set req.http.FPJS-Proxy-Secret = table.lookup(__config_table_name__, "PROXY_SECRET");
    set req.http.FPJS-Proxy-Client-IP = req.http.fastly-client-ip;
    set req.http.FPJS-Proxy-Forwarded-Host = req.http.host;
  }
}
