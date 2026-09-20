package service

import (
	"testing"

	"github.com/mhsanaei/3x-ui/v3/internal/database/model"
)

func TestValidateLightweightInbound(t *testing.T) {
	t.Setenv("XUI_PROFILE", "lw")
	tests := []struct {
		name      string
		protocol  model.Protocol
		stream    string
		wantError bool
	}{
		{name: "xhttp tls", protocol: model.VLESS, stream: `{"network":"xhttp","security":"tls"}`},
		{name: "websocket tls", protocol: model.VLESS, stream: `{"network":"ws","security":"tls"}`},
		{name: "reality", protocol: model.VLESS, stream: `{"network":"tcp","security":"reality"}`},
		{name: "unsupported protocol", protocol: model.Trojan, stream: `{"network":"tcp","security":"tls"}`, wantError: true},
		{name: "unsupported transport", protocol: model.VLESS, stream: `{"network":"grpc","security":"tls"}`, wantError: true},
		{name: "missing tls", protocol: model.VLESS, stream: `{"network":"ws","security":"none"}`, wantError: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateLightweightInbound(&model.Inbound{Protocol: tt.protocol, StreamSettings: tt.stream})
			if (err != nil) != tt.wantError {
				t.Fatalf("validateLightweightInbound() error = %v, wantError %v", err, tt.wantError)
			}
		})
	}
}

func TestValidateLightweightInboundDisabledByDefault(t *testing.T) {
	t.Setenv("XUI_PROFILE", "")
	if err := validateLightweightInbound(&model.Inbound{Protocol: model.Trojan, StreamSettings: `{"network":"tcp","security":"none"}`}); err != nil {
		t.Fatalf("normal profile must remain compatible: %v", err)
	}
}
