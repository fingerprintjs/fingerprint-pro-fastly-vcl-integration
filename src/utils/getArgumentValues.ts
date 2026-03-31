import arg from 'arg'

export function getArgumentValues() {
  const args = arg({
    '--fpjs-domain': String,
    '--config-table-name': String,
    '--max-connections': String,
  })

  return {
    ingressBackend: args['--fpjs-domain'] ?? 'api.fpjs.io',
    configTableName: args['--config-table-name'] ?? 'fingerprint_config',
    maxConnections: args['--max-connections'] ?? '200',
  }
}
