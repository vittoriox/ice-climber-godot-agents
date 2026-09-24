#!/usr/bin/env python3
"""Local Godot Web server with the headers required by threaded Web exports."""

from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class GodotWebHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        super().end_headers()


if __name__ == "__main__":
    server = ThreadingHTTPServer(("0.0.0.0", 8000), GodotWebHandler)
    server.serve_forever()
