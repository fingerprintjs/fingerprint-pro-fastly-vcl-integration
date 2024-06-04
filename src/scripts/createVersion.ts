import { createClient } from './utils/createClient'
import { getService } from './getService'

export async function createVersion() {
  const service = await getService()
  return createClient('version').cloneServiceVersion({
    service_id: process.env.FASTLY_SERVICE_ID,
    version_id: service.active_version.number,
  })
}
