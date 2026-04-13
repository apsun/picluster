package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/jackc/pgx/v5"
)

func index(w http.ResponseWriter, r *http.Request) {
	// urlExample := "postgres://username:password@localhost:5432/database_name"
	conn, err := pgx.Connect(r.Context(), os.Getenv("DATABASE_URL"))
	if err != nil {
		http.Error(w, fmt.Sprintf("unable to connect to database: %v", err), http.StatusInternalServerError)
		return
	}
	defer conn.Close(r.Context())

	_, err = conn.Exec(
		r.Context(),
		`
CREATE TABLE IF NOT EXISTS visitors (
	visit_time INTEGER NOT NULL,
	user_agent VARCHAR(256) NOT NULL
)
`)
	if err != nil {
		http.Error(w, fmt.Sprintf("failed to create table: %v", err), http.StatusInternalServerError)
		return
	}

	_, err = conn.Exec(r.Context(), "INSERT INTO visitors VALUES($1, $2)", time.Now().UTC(), r.UserAgent())
	if err != nil {
		http.Error(w, fmt.Sprintf("failed to insert row: %v", err), http.StatusInternalServerError)
		return
	}

	var count int64
	err = conn.QueryRow(r.Context(), "SELECT COUNT(*) FROM visitors").Scan(&count)
	if err != nil {
		http.Error(w, fmt.Sprintf("failed to query row count: %v", err), http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, `
<!DOCTYPE html>
<html lang="en">
<head><title>testapp</title></head>
<body>You are lucky visitor number %d!</body>
</html>
`, count)
}

func main() {
	http.HandleFunc("/", index)
	log.Fatal(http.ListenAndServe(":8000", nil))
}
