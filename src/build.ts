import packageJson from '../package.json'
import arg from 'arg'
import fs from 'fs'
import path from 'path'
import * as process from 'process'

const version = packageJson.version
const args = arg({
  '--cdn-backend': String,
  '--ingress-backend': String,
  '--behavior-path': String,
  '--config-table-name': String,
})

const argumentValues = {
  cdnBackend: args['--cdn-backend'] ?? 'F_fpcdn_io',
  ingressBackend: args['--ingress-backend'] ?? 'F_api_fpjs_io',
  ingressBackendEurope: args['--ingress-backend'] ?? 'F_eu_api_fpjs_io',
  ingressBackendAsia: args['--ingress-backend'] ?? 'F_ap_api_fpjs_io',
  behaviorPath: args['--behavior-path'] ?? 'behavior',
  configTableName: args['--config-table-name'] ?? 'fingerprint_config',
}

fs.readFile(path.join(__dirname, './assets/template.vcl'), (err, data) => {
  if (err) {
    console.error(err)
    process.exit(1)
  }
  let output = data.toString()
  output = output.replace(/__cdn_backend__/g, argumentValues.cdnBackend)
  output = output.replace(/__ingress_backend__/g, argumentValues.ingressBackend)
  output = output.replace(/__ingress_backend_europe__/g, argumentValues.ingressBackendEurope)
  output = output.replace(/__ingress_backend_asia__/g, argumentValues.ingressBackendAsia)
  output = output.replace(/__integration_version__/g, version)
  output = output.replace(/__behavior_path__/g, argumentValues.behaviorPath)
  output = output.replace(/__config_table_name__/g, argumentValues.configTableName)

  const distPath = path.join(process.cwd(), '/dist')
  if (!fs.existsSync(distPath)) {
    fs.mkdirSync(path.join(process.cwd(), '/dist'))
  }
  fs.writeFile(path.join(distPath, '/integration.vcl'), output, (err) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
  })
})
