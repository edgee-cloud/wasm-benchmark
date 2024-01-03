package main

import (
    "net/http"
)

// Main entry point for the edgee proxy.
func main() {

    proxyHandler := http.HandlerFunc(httpHandler)

    // Build http/https server with options we need
    httpServer := http.Server{
        Addr:    ":8080",
        Handler: proxyHandler,
    }

    _ = httpServer.ListenAndServe()
}

func httpHandler(w http.ResponseWriter, r *http.Request) {

    // Serve "Hello, World!" at /
    if r.URL.Path == "/" {
        w.WriteHeader(http.StatusOK)
        w.Header().Set("Content-Type", "text/plain; charset=utf-8")
        _, err := w.Write([]byte("Hello, World!"))
        if err == nil {
            return
        }
    }

    // Simply echo "ok" for the /status path
    if r.URL.Path == "/status" {
        w.WriteHeader(http.StatusOK)
        w.Header().Set("Content-Type", "text/plain; charset=utf-8")
        _, err := w.Write([]byte("ok"))
        if err == nil {
            return
        }
    }

    // Return the 404 Not Found for other routes.
    w.WriteHeader(http.StatusNotFound)
    return
}
