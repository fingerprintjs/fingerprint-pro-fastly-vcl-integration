import { getTemplateData } from './utils/getTemplateData'
import { writeTemplateOutput } from './utils/writeTemplateOutput'
import { replaceTemplateForCI } from './utils/replaceTemplateForCI'

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
