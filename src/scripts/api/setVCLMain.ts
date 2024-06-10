import { createClient } from '../utils/createClient'

export async function setVCLMain(serviceId: string, fileName: string, versionNumber: number) {
  const vclClient = createClient('vcl')
  await vclClient.setCustomVclMain({
    service_id: serviceId,
    vcl_name: fileName,
    version_id: versionNumber,
  })
}
