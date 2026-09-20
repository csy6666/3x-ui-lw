import { readdir, unlink } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const assetsDir = fileURLToPath(new URL('../../internal/web/dist/assets/', import.meta.url));
const removedPrefixes = ['ApiDocsPage-', 'NodesPage-', 'HostsPage-', 'vendor-swagger-'];
const removedNames = new Set();

for (const name of await readdir(assetsDir)) {
  if (removedPrefixes.some((prefix) => name.startsWith(prefix))) {
    await unlink(join(assetsDir, name));
    removedNames.add(name);
  }
}

if (removedNames.size > 0) {
  console.log(`[lw] pruned ${removedNames.size} unused frontend assets`);
}
