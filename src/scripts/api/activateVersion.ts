import { createClient } from '../utils/createClient'

export async function activateVersion(service_id: string, versionId: number) {
  return createClient('version').activateServiceVersion({
    version_id: versionId,
    service_id,
  })
}
