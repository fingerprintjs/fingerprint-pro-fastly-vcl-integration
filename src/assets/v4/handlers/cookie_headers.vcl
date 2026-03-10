sub handle_cookie_headers {
  declare local var.cookie_iidt STRING;
  set var.cookie_iidt = req.http.cookie:_iidt;
  unset req.http.cookie;
  if (std.strlen(var.cookie_iidt) > 0) {
    set req.http.cookie:_iidt = var.cookie_iidt;
  }
}
