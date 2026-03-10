sub handle_proxy_path {
  declare local var.integration_path STRING;
  set var.integration_path = table.lookup(__config_table_name__, "INTEGRATION_PATH");

  set req.url = std.replace(req.url, "/" + var.integration_path, "");
  if (req.url.path ~ "^(?!/).*") {
    set req.url = "/?" + req.url.qs;
  }
}
