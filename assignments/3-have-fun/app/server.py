#!/usr/bin/python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import json
from socketserver import ThreadingMixIn
import threading
import subprocess
import os
from urllib.parse import unquote
import threading

hostName = "0.0.0.0"
serverPort = int(os.environ["PORT"]) if "PORT" in os.environ else 8000

statuses = { }

cliName = "fanficfare"

rootDir = os.getcwd()

def make_epub(url):
    try:
        statuses[url] = "started"
        path = os.path.join(rootDir, 'downloads', url)
        os.makedirs(path, exist_ok=True)
        os.chdir(path)
        if len(os.listdir()) == 0:
            print(f"Downloading {unquote(url)}")
            subprocess.check_output([cliName, '--non-interactive', '-o include_images=coveronly', unquote(url) ])
            print(f"Downloaded finished {unquote(url)}")
        statuses[url] = "done"
    except Exception as e:
        print(e)
        statuses[url] = "failed"


def get_status(url):
    if url in statuses:
        return statuses[url]
    else:
        return json.dumps(statuses)

class Handler(BaseHTTPRequestHandler):
    def __send_header(self, code=200):
        self.send_response(code)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    def attach_file(self, url):
        print(os.listdir())
        os.chdir(os.path.join(rootDir, 'downloads', url))
        print(os.listdir(), url, os.getcwd())
        filename = os.listdir()[0]

        print(os.listdir(), url)

        with open(filename, 'rb') as file:
            self.send_response(200)
            self.send_header("Content-type", "application/epub+zip")
            self.send_header("Content-Disposition", f"attachment; filename={filename}")
            self.end_headers()
            self.wfile.write(file.read())

    def do_HEAD(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    def do_GET(self):
        try:
            if self.path == "/ready":
                self.__send_header()
                self.wfile.write(json.dumps({'status': 'ready'}).encode(encoding='utf-8'))
            if self.path == "/health":
                try:
                    version = subprocess.check_output([cliName, '-v'])
                    self.__send_header()
                    self.wfile.write(json.dumps({'status': 'ok', 'version': version.decode("utf-8").replace('\n', '').replace('Version: ', '')}).encode(encoding='utf-8'))
                except Exception as e:
                    print(e)
                    self.__send_header(500)
                    self.wfile.write(json.dumps({'error': cliName}).encode(encoding='utf-8'))

            if self.path.startswith("/status"):
                self.__send_header()
                if self.path == "/status":
                    self.wfile.write(json.dumps({'status': statuses}).encode(encoding='utf-8'))
                else:
                    url = self.path[8:]
                    self.wfile.write(json.dumps({'status': get_status(url)}).encode(encoding='utf-8'))

            if self.path.startswith("/epub/"):
                try:
                    url = self.path[6:]
                    if url.startswith("http"):
                        if url not in statuses:
                            make_epub_thread = threading.Thread(target=make_epub, args=([ url ]))
                            make_epub_thread.start()

                        self.__send_header()
                        self.wfile.write(json.dumps({'status': get_status(url)}).encode(encoding='utf-8'))
                    else:
                        raise Exception("invalid url")
                except Exception as e:
                    print(e)
                    self.__send_header(400)
                    self.wfile.write(json.dumps({'error': 'invalid url'}).encode(encoding='utf-8'))
            if self.path.startswith("/download/"):
                self.attach_file(self.path[10:])
        finally:
            os.chdir(rootDir)
            return

def run(server_class=HTTPServer, handler_class=Handler, port=8000):
    server_address = (hostName, port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    print("Server started http://%s:%s" % (hostName, serverPort))
    try:
        run(port=serverPort)
    except KeyboardInterrupt:
        pass
    print("Server stopped.")
