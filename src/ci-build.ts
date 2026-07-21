import { getTemplateData } from './utils/getTemplateData.ts'
import { writeTemplateOutput } from './utils/writeTemplateOutput.ts'
import { replaceTemplateForCI } from './utils/replaceTemplateForCI.ts'

async function main() {
  const data = await getTemplateData()
  const output = replaceTemplateForCI(data)
  await writeTemplateOutput(output)
}

main()
  .then(() => {
    console.log('CI Template built successfully')
    process.exit(0)
  })
  .catch((err) => {
    console.error(err)
    process.exit(1)
  })
