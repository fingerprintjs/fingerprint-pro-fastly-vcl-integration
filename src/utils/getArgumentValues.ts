import arg from 'arg'

export function getArgumentValues() {
  const args = arg({
    '--fpjs-domain': String,
    '--config-table-name': String,
    '--max-connections': String,
  })

  const maxConnections = Number(args['--max-connections'] ?? '200')
  if (isNaN(maxConnections) || maxConnections <= 0) {
    throw new Error('Invalid value for --max-connections. It must be a positive number.')
  }

  return {
    ingressBackend: args['--fpjs-domain'] ?? 'api.fpjs.io',
    configTableName: args['--config-table-name'] ?? 'fingerprint_config',
    maxConnections,
  }
}
