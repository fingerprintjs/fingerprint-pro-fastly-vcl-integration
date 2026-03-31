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
