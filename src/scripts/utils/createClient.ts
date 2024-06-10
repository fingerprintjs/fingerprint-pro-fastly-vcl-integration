import * as Fastly from 'fastly'

export type FastlyClientTypes = 'version' | 'service' | 'vcl' | 'domain' | 'dictionary' | 'dictionaryItem' | 'backend'
export function createClient(api: FastlyClientTypes) {
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
    case 'domain':
      client = new Fastly.DomainApi()
      break
    case "dictionary":
      client = new Fastly.DictionaryApi();
      break
    case "dictionaryItem":
      client = new Fastly.DictionaryItemApi();
      break
    case "backend":
      client = new Fastly.BackendApi();
      break
  }
  Fastly.ApiClient.instance.authenticate(process.env.FASTLY_API_TOKEN)
  return client
}
