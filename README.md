<p align="center">
  <a href="https://fingerprint.com">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://fingerprintjs.github.io/home/resources/logo_light.svg" />
        <source media="(prefers-color-scheme: light)" srcset="https://fingerprintjs.github.io/home/resources/logo_dark.svg" />
        <img src="https://fingerprintjs.github.io/home/resources/logo_dark.svg" alt="Fingerprint logo" width="312px" />
   </picture>
  </a>
</p>
<p align="center">
<a href="https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration"><img src="https://img.shields.io/github/v/release/fingerprintjs/fingerprint-pro-fastly-vcl-integration" alt="Current version"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/:license-mit-blue.svg" alt="MIT license"></a>
<a href="https://discord.gg/39EpE2neBg"><img src="https://img.shields.io/discord/852099967190433792?style=logo&label=Discord&logo=Discord&logoColor=white" alt="Discord server"></a>
</p>

> [!WARNING]
> This integration is in Beta

# Fingerprint Pro Fastly VCL Proxy Integration

[Fingerprint](https://fingerprint.com) is a device intelligence platform offering 99.5% accurate visitor identification.

Fingerprint Fastly VCL Proxy Integration is responsible for proxying identification and agent-download requests between your website and Fingerprint through your Fastly infrastructure via [VCL](https://www.fastly.com/documentation/guides/vcl/using/). The integration consists of a custom VCL file you can add to your Fastly CDN Service.

## 🚧 Requirements and expectations

* **Integration in Beta**: Please report any issues to our [support team](https://fingerprint.com/support).

* **Limited to Enterprise plan**: The Fastly VCL Proxy Integration is exclusively supported for customers on the **Enterprise** Plan. Other customers are encouraged to use [Custom subdomain setup](https://dev.fingerprint.com/docs/custom-subdomain-setup) or [Cloudflare Proxy Integration](https://dev.fingerprint.com/docs/cloudflare-integration).

* **Manual updates occasionally required**: The underlying data contract in the identification logic can change to keep up with browser updates. Using the Fastly VCL Proxy Integration might require occasional manual updates on your side. Ignoring these updates will lead to lower accuracy or service disruption.

## How to install

This is a quick overview of the installation setup. For detailed step-by-step instructions, see the [Fastly VCL proxy integration guide in our documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration).

1. Go to Fingerprint **Dashboard** > [**API Keys**](https://dashboard.fingerprint.com/api-keys) and click **Create Proxy Key** to create a proxy secret. You will use it later to authenticate your requests to Fingerprint APIs.
2. Build the application with `pnpm build --behavior-path="some-random-path-here" --config-table-name="fingerprint_config"` and copy `dist/integration.vcl` file's contents.
   - **`behavior-path` (Required):** Prefix path for integration to run
   - **`config-table-name` (Optional):** Identifier name for Fastly VCL's dictionary to store Fingerprint related variables
3. Paste contents to your Fastly CDN Service's Custom VCL.
4. Create Dictionary as explained the table below

| Key                        | Example Value             | Description                                                   |
|----------------------------|---------------------------|---------------------------------------------------------------|
| PROXY_SECRET               | 6XI9CLf3C9oHSB12TTaI | Fingerprint proxy secret generated in Step 1 |
| AGENT_SCRIPT_DOWNLOAD_PATH | z5kms2                    | Random string for Fingerprint Agent Script download path      |
| GET_RESULT_PATH            | nocmjw                    | Random string for Fingerprint Ingress endpoint path           |

5. Configure the Fingerprint [JS Agent](https://dev.fingerprint.com/docs/js-agent) on your website using the paths defined in Step 2.

    ```javascript
    import * as FingerprintJS from '@fingerprintjs/fingerprintjs-pro'
    
    const fpPromise = FingerprintJS.load({
      apiKey: 'PUBLIC_API_KEY',
      scriptUrlPattern: [
        'https://yourwebsite.com/YOUR_INTEGRATION_PATH_HERE/YOUR_AGENT_PATH_HERE?apiKey=<apiKey>&version=<version>&loaderVersion=<loaderVersion>',
        FingerprintJS.defaultScriptUrlPattern, // Fallback to default CDN in case of error
      ],
      endpoint: 
        'https://yourwebsite.com/YOUR_INTEGRATION_PATH_HERE/YOUR_RESULT_PATH_HERE?region=us',
        FingerprintJS.defaultEndpoint // Fallback to default endpoint in case of error
      ],
    });
    ```

See the [Fastly VCL proxy integration guide](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration#step-3-configure-the-fingerprint-javascript-agent-on-your-client) in our documentation for more details.

If you have any questions, reach out to our [support team](https://fingerprint.com/support).

## License

This project is licensed under the MIT license. See the [LICENSE](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/blob/main/LICENSE) file for more info.
