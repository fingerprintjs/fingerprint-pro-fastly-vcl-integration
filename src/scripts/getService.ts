import { createClient } from './utils/createClient'

export async function getService() {
  const client = createClient('service')
  return client.getServiceDetail({ service_id: process.env.FASTLY_SERVICE_ID })
}
