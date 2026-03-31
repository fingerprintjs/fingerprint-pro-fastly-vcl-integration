sub vcl_deliver {
#FASTLY deliver
  declare local var.integration_path STRING;
  set var.integration_path = table.lookup(__config_table_name__, "INTEGRATION_PATH");
  if (std.prefixof(req.url, "/" + var.integration_path)) {
    unset resp.http.Strict-Transport-Security;
  }
}

sub vcl_recv {
#FASTLY recv
  call handle_integration_routing;
}
