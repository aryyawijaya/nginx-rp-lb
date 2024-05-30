package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", handleAPIRequest)
	port := 8080 // Change this to your desired port
	fmt.Printf("Server listening on port %d...\n", port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}

func handleAPIRequest(w http.ResponseWriter, r *http.Request) {
	// Simulate some data (replace with your actual data)
	hostname, err := os.Hostname()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	responseData := map[string]interface{}{
		"message":  "Hello, world!",
		"hostname": hostname,
		"status":   "success",
	}

	// Set response headers
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	// Encode data as JSON and write to response
	err = json.NewEncoder(w).Encode(responseData)
	if err != nil {
		http.Error(w, "Error encoding JSON response", http.StatusInternalServerError)
		return
	}
}
