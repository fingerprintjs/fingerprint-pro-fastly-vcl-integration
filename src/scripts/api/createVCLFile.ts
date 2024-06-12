import { createClient } from '../utils/createClient'

export async function createVCLFile(service_id: string, name: string, versionNumber: number, content: string) {
  return createClient('vcl').createCustomVcl({
    service_id,
    name,
    version_id: versionNumber,
    content: content,
  })
}
