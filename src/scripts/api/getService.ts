import { createClient } from '../utils/createClient'
import {activateVersion} from "./activateVersion";

export async function createService(domain: string) {
  const client = createClient('service')
  try {
    const searchResponse = await client.searchService({ name: domain })
    if (searchResponse && searchResponse.id) {
      return client.getServiceDetail({ service_id: searchResponse.id })
    }
  }
  catch (_) {
    console.log(`Couldn't find service with name: `, domain);
  }
  console.log('Creating service', domain);
  const createResponse = await client.createService({
    name: domain,
  })
  await createDomain(domain, createResponse.id)
  await createOrigin(createResponse.id)
  await createDictionary(createResponse.id)
  await activateVersion(createResponse.id, 1)
  console.log('Version activated, Service created!')
  return client.getServiceDetail({ service_id: createResponse.id })
}

async function createOrigin(serviceId: string) {
  console.log('Creating default origin')
  const client = createClient('backend')
  await client.createBackend({
    service_id: serviceId,
    version_id: 1,
    address: process.env.DEFAULT_ORIGIN ?? 'playground.orkunfpjs.com',
    name: 'default-backend',
    port: 443,
  })
  console.log('Default origin created')
}

async function createDomain(domain: string, serviceId: string) {
  console.log('Creating domain', domain)
  const domainClient = createClient('domain')
  await domainClient.createDomain({
    version_id: 1,
    name: domain,
    service_id: serviceId,
  })
  console.log('Domain created')
}

async function createDictionary(serviceId: string) {
  console.log('Creating dictionary')
  const dictionaryClient = createClient('dictionary')
  const dictionaryItemClient = createClient('dictionaryItem')
  const dictionary = await dictionaryClient.createDictionary({
    service_id: serviceId,
    version_id: 1,
    name: process.env.CONFIG_TABLE_NAME ?? 'fingerprint_config',
  })
  await dictionaryItemClient.upsertDictionaryItem({
    service_id: serviceId,
    dictionary_id: dictionary.id,
    dictionary_item_key: 'GET_RESULT_PATH',
    item_value: process.env.GET_RESULT_PATH ?? 'result',
  })
  await dictionaryItemClient.upsertDictionaryItem({
    service_id: serviceId,
    dictionary_id: dictionary.id,
    dictionary_item_key: 'AGENT_SCRIPT_DOWNLOAD_PATH',
    item_value: process.env.AGENT_SCRIPT_DOWNLOAD_PATH ?? 'agent',
  })
  await dictionaryItemClient.upsertDictionaryItem({
    service_id: serviceId,
    dictionary_id: dictionary.id,
    dictionary_item_key: 'PROXY_SECRET',
    item_value: 'secret',
  })
}