sub handle_region {
  set req.backend = F_api_fpjs_io;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = F_eu_api_fpjs_io;
  }
  if (querystring.get(req.url, "region") == "ap") {
    set req.backend = F_ap_api_fpjs_io;
  }
}
