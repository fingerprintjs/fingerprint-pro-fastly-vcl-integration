sub handle_integration_routing {
  declare local var.integration_path STRING;
  set var.integration_path = table.lookup(__config_table_name__, "INTEGRATION_PATH");

  # If the request is for the integration, route it to the integration
  if (std.prefixof(req.url, "/" + var.integration_path)) {
    set req.http.X-FPJS-REQUEST = "true";
    if (req.url ~ ".*?(/status$)") {
      # If the request is for the status page, route it to the status page
      error 600;
    }
    call try_handle_v3; # If fails handling v3 routing due to specific path and method conditions, passes to next line
    call try_handle_v4; # Catches all requests without checking path or method
  } else {
    # If the request is not for the integration, pass it to the origin
    return(pass);
  }
}
