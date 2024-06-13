import packageJson from '../../package.json'
import { getArgumentValues } from './getArgumentValues'
import { randomString } from './randomString'

export function replaceTemplate(data: string) {
  const version = packageJson.version
  const argumentValues = getArgumentValues()
  let output = data.toString()
  output = output.replace(/__fpcdn_domain__/g, argumentValues.cdnBackend)
  output = output.replace(/__global_fpjs_domain__/g, argumentValues.ingressBackend)
  output = output.replace(/__europe_fpjs_domain__/g, `eu.${argumentValues.ingressBackend}`)
  output = output.replace(/__asia_fpjs_domain__/g, `ap.${argumentValues.ingressBackend}`)
  output = output.replace(/__config_table_name__/g, argumentValues.configTableName)
  output = output.replace(/__max_connections__/g, argumentValues.maxConnections)
  output = output.replace(/__integration_version__/g, version)
  output = output.replace(/__share_key__/g, randomString()) // Please see this URL for what share_key stands for Fastly. https://www.fastly.com/documentation/guides/concepts/healthcheck/

  return output
}
