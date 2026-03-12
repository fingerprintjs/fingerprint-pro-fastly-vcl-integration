sub proxy_browser_cache_recv {
  set req.url = std.replace(req.url, "/" + table.lookup(__config_table_name__, "GET_RESULT_PATH") + "/", "/");
  unset req.http.cookie;
  set req.backend = F_api_fpjs_io;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = F_eu_api_fpjs_io;
  }
  if(querystring.get(req.url, "region") == "ap") {
    set req.backend = F_ap_api_fpjs_io;
  }

  unset req.http.X-FPJS-REQUEST; # Remove the X-FPJS-REQUEST header

  return(pass);
}
