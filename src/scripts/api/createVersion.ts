import { createClient } from '../utils/createClient'

export async function createVersion(versionToClone?: number) {
  if(!versionToClone) {
    return createClient('version').createServiceVersion({
      service_id: process.env.FASTLY_SERVICE_ID,
    });
  }
  return createClient('version').cloneServiceVersion({
    service_id: process.env.FASTLY_SERVICE_ID,
    version_id: versionToClone,
  })
}
