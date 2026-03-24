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

    declare local var.integration_path_missing BOOL;
    set var.integration_path_missing = false;

    declare local var.v3_missing_env BOOL;
    set var.v3_missing_env = false;

    declare local var.environment_warnings_text STRING;
    set var.environment_warnings_text = "✅ Congratulations! Your integration deployed successfully";

    if(std.strlen(table.lookup(__config_table_name__, "AGENT_SCRIPT_DOWNLOAD_PATH")) == 0) {
        set var.agent_path_missing = true;
    }
    if(std.strlen(table.lookup(__config_table_name__, "INTEGRATION_PATH")) == 0) {
        set var.integration_path_missing = true;
    }
    if(std.strlen(table.lookup(__config_table_name__, "GET_RESULT_PATH")) == 0) {
        set var.result_path_missing = true;
    }
    if(std.strlen(table.lookup(__config_table_name__, "PROXY_SECRET")) == 0) {
        set var.proxy_secret_missing = true;
    }

    if(var.proxy_secret_missing == true || var.integration_path_missing == true) {
        set var.missing_env = true;
        set var.environment_warnings_text = "❌ Your integration environment has problems on both API v3 and v4. Please check the following:";
    } else if(var.agent_path_missing == true || var.result_path_missing == true) {
        set var.v3_missing_env = true;
        set var.environment_warnings_text = "⚠️ Your integration environment doesn't support API v3. If you don't use API v3 Agent, you may skip this warning. Please check the following, if you still need to use API v3:";
    }

    set var.integration_status_text = {"
        <p>
            <span>"} var.environment_warnings_text {"</span>
            <span>INTEGRATION_PATH: "} if(var.integration_path_missing, "❌", "✅") {"</span>
            <span>AGENT_SCRIPT_DOWNLOAD_PATH: "}if(var.agent_path_missing, "⚠️", "✅"){"</span>
            <span>GET_RESULT_PATH: "}if(var.result_path_missing, "⚠️", "✅"){"</span>
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
            <span>
                Integration version: __integration_version__
            </span>
            <span>
                Service version: "} req.vcl.version {"
            </span>
            <span>The following configuration values have been set: </span>
            "} var.integration_status_text {"
            <span>
                If you have any questions, please contact us at <a href='mailto:support@fingerprint.com'>support@fingerprint.com</a>.
            </span>
        </body>
    </html>
    "};

    set obj.status = 200;
    set obj.http.content-type = "text/html; charset=utf-8";
    synthetic var.status_page_response;

    return (deliver);
}

sub vcl_error {
#FASTLY error
    if (obj.status == 600) {
        call proxy_status_page_error;
    }
}
