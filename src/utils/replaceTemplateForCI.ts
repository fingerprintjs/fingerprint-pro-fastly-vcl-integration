import { replaceTemplate } from './replaceTemplate.ts'

export function replaceTemplateForCI(data: string) {
  let output = replaceTemplate(data)
  output = output.replace(
    'set req.http.FPJS-Proxy-Forwarded-Host = req.http.host;',
    'set req.http.FPJS-Proxy-Forwarded-Host = req.http.host ".global.prod.fastly.net";'
  )

  return output
}
