import { createClient } from '../utils/createClient'

export async function activateVersion(versionId: number) {
  return createClient('version').activateServiceVersion({
    version_id: versionId,
    service_id: process.env.FASTLY_SERVICE_ID,
  })
}
