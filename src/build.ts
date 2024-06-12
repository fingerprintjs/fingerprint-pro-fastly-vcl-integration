import packageJson from '../package.json'
import arg from 'arg'
import fs from 'fs'
import path from 'path'
import * as process from 'process'
import { randomString } from './utils/randomString'

const version = packageJson.version
const args = arg({
  '--fpcdn-domain': String,
  '--fpjs-domain': String,
  '--config-table-name': String,
  '--max-connections': Number,
})

const argumentValues = {
  cdnBackend: args['--fpcdn-domain'] ?? 'fpcdn.io',
  ingressBackend: args['--fpjs-domain'] ?? 'api.fpjs.io',
  configTableName: args['--config-table-name'] ?? 'fingerprint_config',
  maxConnections: args['--max-connections'] ?? 200,
}

fs.readFile(path.join(__dirname, './assets/template.vcl'), (err, data) => {
  if (err) {
    console.error(err)
    process.exit(1)
  }
  let output = data.toString()
  output = output.replace(/__fpcdn_domain__/g, argumentValues.cdnBackend)
  output = output.replace(/__global_fpjs_domain__/g, argumentValues.ingressBackend)
  output = output.replace(/__europe_fpjs_domain__/g, `eu.${argumentValues.ingressBackend}`)
  output = output.replace(/__asia_fpjs_domain__/g, `ap.${argumentValues.ingressBackend}`)
  output = output.replace(/__integration_version__/g, version)
  output = output.replace(/__config_table_name__/g, argumentValues.configTableName)
  output = output.replace(/__share_key__/g, randomString()) // Please see this URL for what share_key stands for Fastly. https://www.fastly.com/documentation/guides/concepts/healthcheck/
  output = output.replace(/__max_connections__/g, argumentValues.maxConnections.toString())

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
