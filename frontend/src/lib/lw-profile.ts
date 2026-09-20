import { Protocols } from '@/schemas/primitives';

export const IS_LIGHTWEIGHT_PROFILE =
  import.meta.env.VITE_XUI_PROFILE === 'lw' || import.meta.env.VITE_XUI_PROFILE === 'lightweight';

export const LIGHTWEIGHT_PROTOCOL_OPTIONS = [
  { value: Protocols.VLESS, label: Protocols.VLESS },
] as const;

export const LIGHTWEIGHT_NETWORK_OPTIONS = [
  { value: 'ws', label: 'WebSocket' },
  { value: 'xhttp', label: 'XHTTP' },
  { value: 'tcp', label: 'RAW (Reality)' },
] as const;
