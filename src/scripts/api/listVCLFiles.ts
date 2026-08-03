import { createClient } from '../utils/createClient.ts'

export async function listVCLFiles(service_id: string, versionNumber: number) {
  return createClient('vcl').listCustomVcl({
    service_id,
    version_id: versionNumber,
  })
}
