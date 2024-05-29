sub proxy_agent_download_recv {
  declare local var.apikey STRING;
  set var.apikey = if (std.strlen(querystring.get(req.url, "apiKey")) > 0, querystring.get(req.url, "apiKey"), "");
  declare local var.version STRING;
  set var.version = if (std.strlen(querystring.get(req.url, "version")) > 0, querystring.get(req.url, "version"), "3");
  declare local var.loaderversion STRING;
  set var.loaderversion = if (std.strlen(querystring.get(req.url, "loaderVersion")) > 0, "/loader_v" + querystring.get(req.url, "loaderVersion") + ".js", "");

  set req.url = querystring.add(req.url, "ii", "fingerprint-pro-fastly-vcl/__integration_version__/procdn");

  unset req.http.cookie;

  set req.url = "/v" + var.version + "/" + var.apikey + var.loaderversion + "?" + req.url.qs;
  set req.backend = __cdn_backend__;
  return(lookup);
}

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
  set req.backend = __ingress_backend__;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = __ingress_backend_europe__;
  }
  if(querystring.get(req.url, "region") == "ap") {
    set req.backend = __ingress_backend_asia__;
  }
  return(pass);
}

sub proxy_browser_cache_recv {
  if (req.url.path ~ "^/__behavior_path__/([^/]+)(/.*)$") {
    set req.url = re.group.2 + "?" + req.url.qs;

    unset req.http.cookie;
    set req.backend = __ingress_backend__;
    return(pass);
  }
}

sub proxy_status_page_error {
    declare local var.style_nonce STRING;
    set var.style_nonce = randomstr(16, "1234567890abcdef");

    set req.http.Content-Security-Policy = {"default-src 'none'; img-src https://fingerprint.com; style-src 'nonce-"}var.style_nonce{"'"};

    declare local var.status_page_response STRING;
    set var.status_page_response = {"
    <!DOCTYPE html>
    <html>
        <head>
            <title>Fingerprint Pro Fastly VCL Integration</title>
            <link rel='icon' type='image/x-icon' href='https://fingerprint.com/img/favicon.ico'>
            <style nonce='"} var.style_nonce {"'>
              h1, span {
                display: block;
                padding-top: 1em;
                padding-bottom: 1em;
                text-align: center;
              }
            </style>
        </head>
        <body>
            <h1>Fingerprint Pro Fastly VCL Integration</h1>
            <span>Your Fastly VCL Integration is deployed</span>
            <span>
                Integration version: __integration_version__
            </span>
            <span>
                Please reach out our support via <a href='mailto:support@fingerprint.com'>support@fingerprint.com</a> if you have any issues
            </span>
        </body>
    </html>
    "};

    set obj.http.content-type = "text/html; charset=utf-8";
    synthetic var.status_page_response;

    return (deliver);
}

sub vcl_recv {
#FASTLY recv
    declare local var.target_path STRING;
    set var.target_path = "/__behavior_path__/" table.lookup(__config_table_name__, "AGENT_SCRIPT_DOWNLOAD_PATH");
    if (req.method == "GET" && req.url.path == var.target_path) {
      call proxy_agent_download_recv;
    }

    set var.target_path = "/__behavior_path__/" table.lookup(__config_table_name__, "GET_RESULT_PATH");
    if (req.method == "POST" && req.url.path == var.target_path){
      call proxy_identification_request;
    }

    if (req.method == "GET" && req.url.path ~ "^/__behavior_path__/([^/]+)") {
      if (re.group.1 == table.lookup(__config_table_name__, "GET_RESULT_PATH")) {
        call proxy_browser_cache_recv;
      }
    }

    if (req.method == "GET" && req.url.path ~ "^/__behavior_path__/status") {
        error 600;
    }
}

sub vcl_error {
#FASTLY error
    if (obj.status == 600) {
        call proxy_status_page_error;
    }
}
