import { createClient } from './utils/createClient'
import { getBuiltVCL } from './utils/getBuiltVCL'

export async function createCustomVCL(versionId: number) {
  const builtVCL = await getBuiltVCL()
  const client = createClient('vcl')
  return client.createCustomVcl({
    name: 'fingerprint-pro-fastly-vcl',
    version_id: versionId,
    service_id: process.env.FASTLY_SERVICE_ID,
    content: encodeURIComponent(builtVCL),
  })
}

export async function updateCustomVCL(versionId: null) {
  const builtVCL = await getBuiltVCL()
  const client = createClient('vcl')
  client.updateCustomVcl({
    name: 'fingerprint-pro-fastly-vcl',
    version_id: versionId,
    service_id: process.env.FASTLY_SERVICE_ID,
    content: encodeURIComponent(builtVCL),
  })
}
