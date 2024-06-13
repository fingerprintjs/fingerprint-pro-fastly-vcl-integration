import fs from 'fs'
import path from 'path'

export async function getTemplateData() {
  return new Promise<string>((resolve, reject) => {
    fs.readFile(path.join(process.cwd(), './src/assets/template.vcl'), (err, data) => {
      if (err) {
        reject(err)
        return
      }
      resolve(data.toString())
    })
  })
}
