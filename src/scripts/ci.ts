import { createService } from './api/getService'
import { createVersion } from './api/createVersion'
import { listVCLFiles } from './api/listVCLFiles'
import { getBuiltVCL } from './utils/getBuiltVCL'
import { createVCLFile } from './api/createVCLFile'
import { updateVCLFile } from './api/updateVCLFile'
import { activateVersion } from './api/activateVersion'
import { configDotenv } from 'dotenv'
import { setVCLMain } from './api/setVCLMain'

async function main() {
  configDotenv()
  const VCL_FILE_NAME = 'fingerprint-pro-fastly-vcl'
  const SERVICE_NAME = process.env.SERVICE_NAME as string
  try {
    const service = await createService(SERVICE_NAME)
    const versionsSorted = service.versions.sort((a, b) => b.number - a.number)
    const lastVersion = versionsSorted.length > 0 ? versionsSorted[0] : undefined
    let versionNumber
    if (lastVersion?.active) {
      console.log('active version found', lastVersion.number)
      const version = await createVersion(service.id, lastVersion.number)
      versionNumber = version.number
      console.log('created draft version', versionNumber)
    }
    if (!versionNumber) {
      console.log('version not found, creating...')
      const version = await createVersion(service.id)
      versionNumber = version.number
      console.log('version created', versionNumber)
    }
    const vclFiles = await listVCLFiles(service.id, versionNumber)
    const vclFileToUpdate = vclFiles.find((t) => t.name === VCL_FILE_NAME)
    console.log('searched for vcl files, found', vclFileToUpdate ? 'yes' : 'no')
    const builtVCLFile = await getBuiltVCL()
    if (!vclFileToUpdate) {
      await createVCLFile(service.id, VCL_FILE_NAME, versionNumber, builtVCLFile)
      console.log('created vcl file')
    } else {
      await updateVCLFile(service.id, VCL_FILE_NAME, versionNumber, builtVCLFile)
      console.log('updated vcl file')
    }
    console.log('updating main vcl file')
    await setVCLMain(service.id, VCL_FILE_NAME, versionNumber)
    console.log('main vcl updated, activating new version', versionNumber)
    await activateVersion(service.id, versionNumber)
    console.log('activated version', versionNumber)
  } catch (e) {
    console.error(e)
  }
}

main().then(() => {
  console.log('CI Deploy completed!')
  process.exit(0)
}).catch((err) => {
  console.error('CI Deploy failed', err);
  process.exit(1)
})
