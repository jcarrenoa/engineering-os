package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "ok",
			"project": "__PROJECT_NAME__",
		})
	})

	fmt.Println("Server running on :8080")
	http.ListenAndServe(":8080", mux)
}
