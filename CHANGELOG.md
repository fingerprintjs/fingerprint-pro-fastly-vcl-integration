## [1.0.0-test.4](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/compare/v1.0.0-test.3...v1.0.0-test.4) (2024-07-03)


### Features

* update routing for ingress and browser cache endpoint ([ca1a5c9](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/ca1a5c98460d3079bf53e69f594e4d0838b7db75))


### Bug Fixes

* browser cache endpoint trailing slashes ([16c4f52](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/16c4f522957d8839fb8f9ee47ecdaf1512176340))
* browser cache endpoint url path ([9b22942](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/9b22942cea49f6805f06022a5544776c7ba30ef9))

## [1.0.0-test.3](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/compare/v1.0.0-test.2...v1.0.0-test.3) (2024-06-26)


### Features

* add hsts header filter on vcl ([76e603d](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/76e603da8b6d13327de2b07262cc3b798ecb2406))

## [1.0.0-test.2](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/compare/v1.0.0-test.1...v1.0.0-test.2) (2024-06-14)


### Bug Fixes

* browser cache 3rd group of regexp ([8bc5bfc](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/8bc5bfc1f086720163f4ceea5a645e3b7fbf5f94))
* browser cache endpoint regions ([515d877](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/515d8777bdac39ea5d62d78e20f071b9c5304b01))
* handle browser cache reqs without additional path ([bfdf9af](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/bfdf9aff3e4323451b8dd06f9acf1c742636ebd4))

## 1.0.0-test.1 (2024-06-14)


### Features

* add multi region support ([20f904b](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/20f904b0a8d886c4a507ae72d6a81430890ded4c))
* add share key and max connection arg ([27f2156](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/27f2156d06e78ed0ea4215597a2c97525b46486c))
* add status page ([895656b](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/895656b4eb4230d25ec4f529f86edd180f135935))
* add status page env checks ([46710fe](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/46710fe1f1b44d0f3423c403aacaad7ee8afe63f))
* behavior path now configurable from environment variables ([3dd69c2](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/3dd69c2e37218285b6bc4802e2e125bc38c61b19))
* move origins inside vcl ([9a9e20b](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/9a9e20bd61a295e03739f01f7b4494ff0d762ebc))
* put probe fields back and add expected_response field ([6b3f825](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/6b3f825755179d1b76d22842f15464aac59e0be2))
* remove probe fields from backends ([b1eedc8](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/b1eedc8efd96b5a79474a0e6a2c73930da889cb0))


### Bug Fixes

* url for target paths ([a3973ba](https://github.com/fingerprintjs/fingerprint-pro-fastly-vcl-integration/commit/a3973bab2f1893e04ba72ccad9c420b336017f16))
