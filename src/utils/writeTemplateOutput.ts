import path from 'path'
import process from 'process'
import fs from 'fs'

export async function writeTemplateOutput(output: string) {
  return new Promise<undefined>((resolve, reject) => {
    const distPath = path.join(process.cwd(), '/dist')
    if (!fs.existsSync(distPath)) {
      fs.mkdirSync(path.join(process.cwd(), '/dist'))
    }
    fs.writeFile(path.join(distPath, '/fingerprint-pro-fastly-vcl-integration.vcl'), output, (err) => {
      if (err) {
        reject(err)
        return
      }
      resolve(undefined)
    })
  })
}
