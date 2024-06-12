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
2. Build the application with `pnpm build`
   - **`--config-table-name` (Optional, default: `fingerprint_config`):** Identifier name for Fastly VCL's dictionary to store Fingerprint related variables
   - **`--fpcdn-domain` (Optional, default: `fpcdn.io`):** Domain to request agent script from
   - **`--fpjs-domain` (Optional, default: `api.fpjs.io`):** Domain to make user identification requests
   - **`--max-connections` (Optional, default: `200`):** Fastly CDN Service maximum number of requests per second limit for each origin
3. Copy `dist/integration.vcl` file's contents.
4. Paste contents to your Fastly CDN Service's Custom VCL.
5. Create a Dictionary named `fingerprint_config` or the value you specified as `config-table-name` in Step 2 and add the following values:

| Key                        | Example Value             | Description                                             |
|----------------------------|---------------------------|---------------------------------------------------------|
| PROXY_SECRET               | 6XI9CLf3C9oHSB12TTaI | Fingerprint proxy secret generated in Step 1            |
| INTEGRATION_PATH              | 02mbd3 | Random path prefix for proxy integration endpoints      |
| AGENT_SCRIPT_DOWNLOAD_PATH | z5kms2                    | Random path segment for downloading the JS agent        |
| GET_RESULT_PATH            | nocmjw                    | Random path segment Fingerprint identification requests |

5. Configure the Fingerprint [JS Agent](https://dev.fingerprint.com/docs/js-agent) on your website using the paths defined in Step 2.

    ```javascript
    import * as FingerprintJS from '@fingerprintjs/fingerprintjs-pro'
    
    const fpPromise = FingerprintJS.load({
      apiKey: 'PUBLIC_API_KEY',
      scriptUrlPattern: [
        'https://yourwebsite.com/INTEGRATION-PATH/AGENT_SCRIPT_DOWNLOAD_PATH?apiKey=<apiKey>&version=<version>&loaderVersion=<loaderVersion>',
        FingerprintJS.defaultScriptUrlPattern, // Fallback to default CDN in case of error
      ],
      endpoint: 
        'https://yourwebsite.com/INTEGRATION-PATH/GET_RESULT_PATH?region=us',
        FingerprintJS.defaultEndpoint // Fallback to default endpoint in case of error
      ],
    });
    ```

See the [Fastly VCL proxy integration guide](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration#step-3-configure-the-fingerprint-javascript-agent-on-your-client) in our documentation for more details.

If you have any questions, reach out to our [support team](https://fingerprint.com/support).

## License

This project is licensed under the [MIT license](LICENSE).
