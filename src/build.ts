import { getTemplateData } from './utils/getTemplateData.ts'
import { replaceTemplate } from './utils/replaceTemplate.ts'
import { writeTemplateOutput } from './utils/writeTemplateOutput.ts'

async function main() {
  const data = await getTemplateData()
  const output = replaceTemplate(data)
  await writeTemplateOutput(output)
}

main()
  .then(() => {
    console.log('Template built successfully')
    process.exit(0)
  })
  .catch((err) => {
    console.error(err)
    process.exit(1)
  })
