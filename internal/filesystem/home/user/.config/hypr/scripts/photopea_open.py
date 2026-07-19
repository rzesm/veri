#!/usr/bin/env python3
import sys
import os
import http.server
import socketserver
import threading
import time
import urllib.parse
import json
import subprocess

def main():
    if len(sys.argv) < 2:
        print("Usage: photopea-open <path_to_image>")
        sys.exit(1)

    # Resolve absolute path of the target image
    file_path = os.path.abspath(sys.argv[1])
    if not os.path.exists(file_path):
        print(f"Error: File not found: {file_path}")
        sys.exit(1)

    file_dir = os.path.dirname(file_path)
    file_name = os.path.basename(file_path)

    # Thread event to monitor when Photopea successfully grabs the asset
    file_fetched = threading.Event()

    # Simple HTTP handler that injects mandatory CORS headers for Photopea
    class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
        def end_headers(self):
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
            self.send_header('Access-Control-Allow-Headers', '*')
            super().end_headers()
            
        def do_GET(self):
            super().do_GET()
            # Signal that the image stream has started/finished
            file_fetched.set()

        def log_message(self, format, *args):
            pass # Keep terminal output silent

    # Start an ephemeral server on a random open port on localhost
    with socketserver.TCPServer(("127.0.0.1", 0), CORSRequestHandler) as httpd:
        port = httpd.server_address[1]
        
        # Jump into file's directory to serve it cleanly
        os.chdir(file_dir)
        
        # Run server passively in a background thread
        server_thread = threading.Thread(target=httpd.serve_forever)
        server_thread.daemon = True
        server_thread.start()
        
        # Format target JSON payload for Photopea API
        local_url = f"http://127.0.0.1:{port}/{urllib.parse.quote(file_name)}"
        photopea_config = {"files": [local_url]}
        encoded_config = urllib.parse.quote(json.dumps(photopea_config))
        
        # Build final URL configuration
        photopea_url = f"https://www.photopea.com#{encoded_config}"
        
        # Launch Zen
        cmd = [
            "zen-browser",
            "-P", "app-photopea",
            "--name=photopea",
            "--new-window",
            photopea_url
        ]
        subprocess.Popen(cmd)
        
        # Keep server open until image is fetched, or kill after a 25s timeout
        file_fetched.wait(timeout=25)
        httpd.shutdown()

if __name__ == "__main__":
    main()
