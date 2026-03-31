import fs from 'fs'
import path from 'path'

async function getTemplate(src: string) {
  return new Promise<string>((resolve, reject) => {
    fs.readFile(path.join(process.cwd(), `./src/assets/${src}`), (err, data) => {
      if (err) {
        reject(err)
        return
      }
      resolve(data.toString())
    })
  })
}

export async function getTemplateData() {
  return `# Common shared backends for all versions
${await getTemplate('backends.vcl')}
${await getTemplate('utils/is_authorized_request.vcl')}

# Status page handler
${await getTemplate('status.vcl')}

# v3 Handlers
${await getTemplate('v3/handlers/agent.vcl')}
${await getTemplate('v3/handlers/browser_cache.vcl')}
${await getTemplate('v3/handlers/ingress.vcl')}

# v3 Routing
${await getTemplate('v3/routing.vcl')}

# v4 Handlers
${await getTemplate('v4/handlers/cookie_headers.vcl')}
${await getTemplate('v4/handlers/path.vcl')}
${await getTemplate('v4/handlers/proxy_headers.vcl')}
${await getTemplate('v4/handlers/region.vcl')}
${await getTemplate('v4/handlers/traffic_monitoring.vcl')}

# v4 Routing
${await getTemplate('v4/routing.vcl')}

# General routing between v3 and v4
${await getTemplate('routing.vcl')}

# Template for fastly, handling proper subroutines
${await getTemplate('index.vcl')}
`
}
