sub try_handle_v4 {
  call handle_proxy_headers;
  call handle_cookie_headers;
  call handle_region;
  call handle_traffic_monitoring;
  call handle_proxy_path;

  unset req.http.X-FPJS-REQUEST; # Remove the X-FPJS-REQUEST header

  return(pass);
}
