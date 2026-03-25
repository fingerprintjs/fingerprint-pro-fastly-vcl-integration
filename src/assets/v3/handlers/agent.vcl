sub proxy_agent_download_recv {

  unset req.http.cookie;

  set req.backend = F_fpcdn_io;
  declare local var.apikey STRING;
  set var.apikey = if (std.strlen(querystring.get(req.url, "apiKey")) > 0, querystring.get(req.url, "apiKey"), "");
  declare local var.version STRING;
  set var.version = if (std.strlen(querystring.get(req.url, "version")) > 0, querystring.get(req.url, "version"), "3");
  declare local var.loaderversion STRING;
  set var.loaderversion = if (std.strlen(querystring.get(req.url, "loaderVersion")) > 0, "/loader_v" + querystring.get(req.url, "loaderVersion") + ".js", "");
  set req.url = "/v" + var.version + "/" + var.apikey + var.loaderversion + "?" + req.url.qs;

  unset req.http.X-FPJS-REQUEST; # Remove the X-FPJS-REQUEST header

  return(lookup);
}
