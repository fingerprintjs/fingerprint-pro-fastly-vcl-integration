backend F_fpcdn_io {
    .always_use_host_header = true;
    .between_bytes_timeout = 10s;
    .connect_timeout = 1s;
    .dynamic = true;
    .first_byte_timeout = 15s;
    .host = "__fpcdn_domain__";
    .host_header = "__fpcdn_domain__";
    .max_connections = 200;
    .port = "443";
    .share_key = "__share_key__";
    .ssl = true;
    .ssl_cert_hostname = "__fpcdn_domain__";
    .ssl_check_cert = always;
    .ssl_sni_hostname = "__fpcdn_domain__";
    .probe = {
        .dummy = true;
        .initial = 5;
        .request = "HEAD / HTTP/1.1"  "Host: __fpcdn_domain__" "Connection: close";
        .threshold = 1;
        .timeout = 2s;
        .window = 5;
        .expected_response = 200;
      }
}
backend F_api_fpjs_io {
    .always_use_host_header = true;
    .between_bytes_timeout = 10s;
    .connect_timeout = 1s;
    .dynamic = true;
    .first_byte_timeout = 15s;
    .host = "__global_fpjs_domain__";
    .host_header = "__global_fpjs_domain__";
    .max_connections = 200;
    .port = "443";
    .share_key = "__share_key__";
    .ssl = true;
    .ssl_cert_hostname = "__global_fpjs_domain__";
    .ssl_check_cert = always;
    .ssl_sni_hostname = "__global_fpjs_domain__";
    .probe = {
        .dummy = true;
        .initial = 5;
        .request = "HEAD / HTTP/1.1"  "Host: __global_fpjs_domain__" "Connection: close";
        .threshold = 1;
        .timeout = 2s;
        .window = 5;
        .expected_response = 200;
      }
}
backend F_eu_api_fpjs_io {
    .always_use_host_header = true;
    .between_bytes_timeout = 10s;
    .connect_timeout = 1s;
    .dynamic = true;
    .first_byte_timeout = 15s;
    .host = "__europe_fpjs_domain__";
    .host_header = "__europe_fpjs_domain__";
    .max_connections = 200;
    .port = "443";
    .share_key = "__share_key__";
    .ssl = true;
    .ssl_cert_hostname = "__europe_fpjs_domain__";
    .ssl_check_cert = always;
    .ssl_sni_hostname = "__europe_fpjs_domain__";
    .probe = {
        .dummy = true;
        .initial = 5;
        .request = "HEAD / HTTP/1.1"  "Host: __europe_fpjs_domain__" "Connection: close";
        .threshold = 1;
        .timeout = 2s;
        .window = 5;
        .expected_response = 200;
      }
}
backend F_ap_api_fpjs_io {
    .always_use_host_header = true;
    .between_bytes_timeout = 10s;
    .connect_timeout = 1s;
    .dynamic = true;
    .first_byte_timeout = 15s;
    .host = "__asia_fpjs_domain__";
    .host_header = "__asia_fpjs_domain__";
    .max_connections = 200;
    .port = "443";
    .share_key = "__share_key__";
    .ssl = true;
    .ssl_cert_hostname = "__asia_fpjs_domain__";
    .ssl_check_cert = always;
    .ssl_sni_hostname = "__asia_fpjs_domain__";
    .probe = {
        .dummy = true;
        .initial = 5;
        .request = "HEAD / HTTP/1.1"  "Host: __asia_fpjs_domain__" "Connection: close";
        .threshold = 1;
        .timeout = 2s;
        .window = 5;
        .expected_response = 200;
      }
}

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
  set req.backend = F_fpcdn_io;
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
  set req.backend = F_api_fpjs_io;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = F_eu_api_fpjs_io;
  }
  if(querystring.get(req.url, "region") == "ap") {
    set req.backend = F_ap_api_fpjs_io;
  }
  return(pass);
}

sub proxy_browser_cache_recv {
  if (req.url.path ~ "^/([\w|-]+)/([^/]+)(.*)?$") {
    if(re.group.1 == table.lookup(__config_table_name__, "INTEGRATION_PATH")) {
        set req.url = re.group.3 + "/?" + req.url.qs;

        unset req.http.cookie;
        set req.backend = F_api_fpjs_io;
        if (querystring.get(req.url, "region") == "eu") {
          set req.backend = F_eu_api_fpjs_io;
        }
        if(querystring.get(req.url, "region") == "ap") {
          set req.backend = F_ap_api_fpjs_io;
        }
        return(pass);
    }
  }
}

sub proxy_status_page_error {
    declare local var.style_nonce STRING;
    declare local var.integration_status_text STRING;

    declare local var.missing_env BOOL;
    set var.missing_env = false;

    declare local var.proxy_secret_missing BOOL;
    set var.proxy_secret_missing = false;

    declare local var.agent_path_missing BOOL;
    set var.agent_path_missing = false;

    declare local var.result_path_missing BOOL;
    set var.result_path_missing = false;

    if(std.strlen(table.lookup(__config_table_name__, "AGENT_SCRIPT_DOWNLOAD_PATH")) == 0) {
        set var.agent_path_missing = true;
    }
    if(std.strlen(table.lookup(__config_table_name__, "GET_RESULT_PATH")) == 0) {
        set var.result_path_missing = true;
    }
    if(std.strlen(table.lookup(__config_table_name__, "PROXY_SECRET")) == 0) {
        set var.proxy_secret_missing = true;
    }

    if(var.proxy_secret_missing == true || var.agent_path_missing == true || var.result_path_missing == true) {
        set var.missing_env = true;
    }

    set var.integration_status_text = {"
        <p>
            <span>"}if(var.missing_env, "Your integration environment has problems", "Congratulations! Your integration deployed successfully"){"</span>
            <span>AGENT_SCRIPT_DOWNLOAD_PATH: "}if(var.agent_path_missing, "❌", "✅"){"</span>
            <span>GET_RESULT_PATH: "}if(var.result_path_missing, "❌", "✅"){"</span>
            <span>PROXY_SECRET: "}if(var.proxy_secret_missing, "❌", "✅"){"</span>
        </p>
    "};

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
            "} var.integration_status_text {"
            <span>
                Integration version: __integration_version__
            </span>
            <span>
                Please reach out our support via <a href='mailto:support@fingerprint.com'>support@fingerprint.com</a> if you have any issues
            </span>
        </body>
    </html>
    "};

    set obj.status = 200;
    set obj.http.content-type = "text/html; charset=utf-8";
    synthetic var.status_page_response;

    return (deliver);
}

sub vcl_recv {
#FASTLY recv
    declare local var.target_path STRING;
    set var.target_path = "/" table.lookup(__config_table_name__, "INTEGRATION_PATH") "/" table.lookup(__config_table_name__, "AGENT_SCRIPT_DOWNLOAD_PATH");
    if (req.method == "GET" && req.url.path == var.target_path) {
      call proxy_agent_download_recv;
    }

    set var.target_path = "/" table.lookup(__config_table_name__, "INTEGRATION_PATH") "/" table.lookup(__config_table_name__, "GET_RESULT_PATH");
    if (req.method == "POST" && req.url.path == var.target_path){
      call proxy_identification_request;
    }

    if (req.method == "GET" && req.url.path ~ "^/([\w|-]+)/([^/]+)") {
      if (re.group.1 == table.lookup(__config_table_name__, "INTEGRATION_PATH") && re.group.2 == table.lookup(__config_table_name__, "GET_RESULT_PATH")) {
        call proxy_browser_cache_recv;
      }
    }

    if (req.method == "GET" && req.url.path ~ "^/([\w|-]+)/status") {
        if (re.group.1 == table.lookup(__config_table_name__, "INTEGRATION_PATH")) {
            error 600;
        }
    }
}

sub vcl_error {
#FASTLY error
    if (obj.status == 600) {
        call proxy_status_page_error;
    }
}
