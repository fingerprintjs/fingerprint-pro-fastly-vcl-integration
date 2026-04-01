sub vcl_deliver {
#FASTLY deliver
  if (client.identity == "integration-request") {
    unset resp.http.Strict-Transport-Security;
  }
}

sub vcl_fetch {
#FASTLY fetch
  if (client.identity == "integration-request") {
    unset beresp.http.Strict-Transport-Security;
  }
}

sub vcl_recv {
#FASTLY recv
  call handle_integration_routing;
}
