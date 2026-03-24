sub is_warden_request BOOL {
 if (req.method == "POST" || req.method == "PUT" || req.method == "DELETE" || req.method == "PATCH") {
    return true;
 }
 return false;
}
