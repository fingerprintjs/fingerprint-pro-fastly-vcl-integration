import * as Fastly from 'fastly'
import { configDotenv } from 'dotenv'
export function createClient(api: 'version' | 'service' | 'vcl') {
  configDotenv()
  let client
  switch (api) {
    case 'service':
      client = new Fastly.ServiceApi()
      break
    case 'version':
      client = new Fastly.VersionApi()
      break
    case 'vcl':
      client = new Fastly.VclApi()
      break
  }
  Fastly.ApiClient.instance.authenticate(process.env.FASTLY_API_TOKEN)
  return client
}
