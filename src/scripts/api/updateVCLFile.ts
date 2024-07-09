import { createClient } from '../utils/createClient'

export async function updateVCLFile(service_id: string, name: string, versionNumber: number, content: string) {
  return createClient('vcl').updateCustomVcl({
    service_id,
    version_id: versionNumber,
    vcl_name: name,
    content: content,
  })
}
