sub vcl_deliver {
#FASTLY deliver
  if (req.http.X-FPJS-REQUEST) {
      unset resp.http.Strict-Transport-Security;
  }
}

sub vcl_recv {
#FASTLY recv
  call handle_integration_routing;
}
