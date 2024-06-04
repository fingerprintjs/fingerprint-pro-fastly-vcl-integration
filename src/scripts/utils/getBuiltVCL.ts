import fs from 'fs'

export async function getBuiltVCL() {
  return new Promise<string>((resolve, reject) => {
    fs.readFile(__dirname + '/dist/integration.vcl', 'utf8', (err, data) => {
      if (!err && data) {
        resolve(data)
      }
      reject(err)
    })
  })
}
