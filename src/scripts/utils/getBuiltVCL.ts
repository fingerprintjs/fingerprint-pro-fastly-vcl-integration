import fs from 'fs'

export async function getBuiltVCL() {
  return new Promise<string>((resolve, reject) => {
    fs.readFile(process.cwd() + '/dist/fingerprint-pro-fastly-vcl-integration.vcl', 'utf8', (err, data) => {
      if (!err && data) {
        resolve(data)
      }
      reject(err)
    })
  })
}
