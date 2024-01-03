package main

import (
    "fmt"
    "github.com/valyala/fasthttp"
)

// Main entry point for the edgee proxy.
func main() {
    fmt.Println("Starting server...")
    _ = fasthttp.ListenAndServe(":8080", httpHandler)
}

func httpHandler(ctx *fasthttp.RequestCtx) {
    // Serve "Hello, World!" at /
    if string(ctx.Path()) == "/" {
        ctx.SetStatusCode(fasthttp.StatusOK)
        ctx.Response.Header.Set("Content-Type", "text/plain; charset=utf-8")
        _, err := ctx.WriteString("Hello, World!")
        if err == nil {
            return
        }
    }

    // Simply echo "ok" for the /status path
    if string(ctx.Path()) == "/status" {
        ctx.SetStatusCode(fasthttp.StatusOK)
        ctx.Response.Header.Set("Content-Type", "text/plain; charset=utf-8")
        _, err := ctx.WriteString("ok")
        if err == nil {
            return
        }
    }

    // Return the 404 Not Found for other routes.
    ctx.SetStatusCode(fasthttp.StatusNotFound)
    return
}
