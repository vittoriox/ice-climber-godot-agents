#!/usr/bin/env python3
"""Local Godot Web server with the headers required by threaded Web exports."""

from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import argparse
import ssl


class GodotWebHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        super().end_headers()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Serve the Godot Web export locally.")
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--cert", help="PEM certificate for HTTPS.")
    parser.add_argument("--key", help="PEM private key for HTTPS.")
    args = parser.parse_args()

    server = ThreadingHTTPServer(("0.0.0.0", args.port), GodotWebHandler)
    if bool(args.cert) != bool(args.key):
        parser.error("--cert y --key deben usarse juntos")
    if args.cert and args.key:
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(args.cert, args.key)
        server.socket = context.wrap_socket(server.socket, server_side=True)
        print(f"HTTPS activo en https://0.0.0.0:{args.port}")
    else:
        print(f"HTTP activo en http://0.0.0.0:{args.port}")
    server.serve_forever()
