package service

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/mhsanaei/3x-ui/v3/internal/config"
	"github.com/mhsanaei/3x-ui/v3/internal/database/model"
)

// validateLightweightInbound keeps the lw distribution deliberately narrow:
// VLESS over XHTTP/TLS and WebSocket/TLS for CDN deployments, or TCP/Reality
// for direct anti-blocking deployments. Other protocols remain available in
// the normal profile and can be re-enabled later without a schema migration.
func validateLightweightInbound(inbound *model.Inbound) error {
	if !config.IsLightweightProfile() || inbound == nil {
		return nil
	}
	if inbound.Protocol != model.VLESS {
		return fmt.Errorf("lightweight profile only supports VLESS (XHTTP, WebSocket, or Reality)")
	}

	var stream struct {
		Network  string `json:"network"`
		Security string `json:"security"`
	}
	if raw := strings.TrimSpace(inbound.StreamSettings); raw != "" {
		if err := json.Unmarshal([]byte(raw), &stream); err != nil {
			return fmt.Errorf("invalid stream settings: %w", err)
		}
	}

	switch {
	case stream.Network == "xhttp" && stream.Security == "tls":
		return nil
	case stream.Network == "ws" && stream.Security == "tls":
		return nil
	case stream.Network == "tcp" && stream.Security == "reality":
		return nil
	default:
		return fmt.Errorf("lightweight profile supports only VLESS XHTTP/TLS, VLESS WebSocket/TLS, or VLESS TCP/Reality")
	}
}
