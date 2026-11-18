---
name: go-dev
description: Go Development
---

# Go Development Skill

## Overview
This skill helps you write, debug, optimize, and maintain Go (Golang) applications. It provides best practices for idiomatic Go code, proper error handling, concurrency patterns, testing strategies, and effective use of Go's toolchain and standard library.

## When to Use This Skill
Use this skill when you need to:
- Write new Go programs, packages, or modules
- Debug Go applications or understand error messages
- Implement concurrent programs using goroutines and channels
- Design RESTful APIs or microservices in Go
- Work with Go's standard library effectively
- Optimize Go code for performance
- Write tests and benchmarks
- Structure Go projects following best practices
- Work with Go modules and dependency management

## Go Philosophy & Principles

### Core Values
1. **Simplicity** - Prefer simple, readable code over clever solutions
2. **Clarity** - Code should be obvious and self-documenting
3. **Composition** - Build complex behavior from simple pieces
4. **Concurrency** - First-class support via goroutines and channels
5. **Practicality** - Solve real problems efficiently

### Key Mantras
- "Clear is better than clever"
- "Don't communicate by sharing memory; share memory by communicating"
- "A little copying is better than a little dependency"
- "Errors are values"
- "Design the architecture, name the components, document the details"

## Project Structure

### Standard Go Project Layout
```
myproject/
├── cmd/                    # Main applications
│   └── myapp/
│       └── main.go
├── internal/               # Private application code
│   ├── auth/
│   ├── database/
│   └── handler/
├── pkg/                    # Public library code
│   └── api/
├── api/                    # API definitions (OpenAPI, Protocol Buffers)
├── web/                    # Web application assets
├── configs/                # Configuration files
├── scripts/                # Build and deployment scripts
├── test/                   # Additional test data
├── docs/                   # Documentation
├── go.mod                  # Go module definition
├── go.sum                  # Dependency checksums
├── Makefile               # Build automation
└── README.md
```

### Module Initialization
```bash
# Initialize a new Go module
go mod init github.com/username/projectname

# Add dependencies
go get github.com/gorilla/mux@latest

# Tidy up dependencies
go mod tidy

# Vendor dependencies (optional)
go mod vendor
```

## Code Organization Best Practices

### 1. Package Naming
```go
// ✅ Good - short, lowercase, no underscores
package auth
package httputil
package stringutil

// ❌ Bad - avoid these patterns
package auth_handler  // no underscores
package AuthHandler   // no capitals
package authentication // too long, abbreviate to 'auth'
```

### 2. File Naming
```go
// ✅ Good - descriptive, lowercase, underscores for separation
user.go
user_test.go
http_server.go
database_connection.go

// ❌ Bad
User.go          // don't capitalize
userStuff.go     // too vague
HTTPServer.go    // don't capitalize
```

### 3. Package Organization
```go
// One package per directory
// Files in the same package can access each other's unexported identifiers

// auth/user.go
package auth

type User struct {
    ID       int
    Username string
    password string // unexported
}

// auth/service.go
package auth

func (u *User) validatePassword(pwd string) bool {
    // Can access u.password even though it's unexported
    return u.password == pwd
}
```

## Idiomatic Go Patterns

### 1. Error Handling
```go
// ✅ Good - explicit error handling
func readFile(filename string) ([]byte, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        return nil, fmt.Errorf("failed to read %s: %w", filename, err)
    }
    return data, nil
}

// Using errors.Is and errors.As (Go 1.13+)
func processFile(filename string) error {
    data, err := readFile(filename)
    if err != nil {
        if errors.Is(err, os.ErrNotExist) {
            return fmt.Errorf("file not found: %w", err)
        }
        return fmt.Errorf("unexpected error: %w", err)
    }
    
    // Process data...
    return nil
}

// Custom error types
type ValidationError struct {
    Field string
    Issue string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed on %s: %s", e.Field, e.Issue)
}

// Using custom errors
func validateUser(u *User) error {
    if u.Username == "" {
        return &ValidationError{Field: "username", Issue: "cannot be empty"}
    }
    return nil
}

// ❌ Bad - ignoring errors
data, _ := os.ReadFile(filename) // Never do this!

// ❌ Bad - panic in library code
func MustReadFile(filename string) []byte {
    data, err := os.ReadFile(filename)
    if err != nil {
        panic(err) // Only use panic for unrecoverable errors
    }
    return data
}
```

### 2. Interfaces
```go
// ✅ Good - small, focused interfaces (often single method)
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Compose interfaces
type ReadWriter interface {
    Reader
    Writer
}

// Accept interfaces, return concrete types
func ProcessData(r io.Reader) (*Result, error) {
    // Implementation
    return &Result{}, nil
}

// Define interfaces where they're used (consumer side)
// mypackage/processor.go
type DataStore interface {
    Save(data []byte) error
    Load(id string) ([]byte, error)
}

func NewProcessor(store DataStore) *Processor {
    return &Processor{store: store}
}

// ❌ Bad - too many methods
type Massive interface {
    Method1()
    Method2()
    Method3()
    Method4()
    Method5() // Interfaces should be small!
}

// ❌ Bad - unnecessary interface
type UserInterface interface {
    GetName() string
    GetEmail() string
}

type User struct {
    Name  string
    Email string
}

func (u *User) GetName() string  { return u.Name }
func (u *User) GetEmail() string { return u.Email }

// Just use the concrete type unless you need abstraction!
```

### 3. Struct Design
```go
// ✅ Good - clear, well-organized structs
type Server struct {
    addr     string
    port     int
    router   *mux.Router
    db       *sql.DB
    logger   *log.Logger
    
    // Group related fields
    timeout  time.Duration
    maxConns int
    
    // Use sync types for concurrent access
    mu       sync.RWMutex
    clients  map[string]*Client
}

// Constructor pattern
func NewServer(addr string, port int, db *sql.DB) *Server {
    return &Server{
        addr:     addr,
        port:     port,
        router:   mux.NewRouter(),
        db:       db,
        logger:   log.New(os.Stdout, "server: ", log.LstdFlags),
        timeout:  30 * time.Second,
        maxConns: 100,
        clients:  make(map[string]*Client),
    }
}

// Functional options pattern for complex configuration
type ServerOption func(*Server)

func WithTimeout(d time.Duration) ServerOption {
    return func(s *Server) {
        s.timeout = d
    }
}

func WithLogger(logger *log.Logger) ServerOption {
    return func(s *Server) {
        s.logger = logger
    }
}

func NewServerWithOptions(addr string, port int, opts ...ServerOption) *Server {
    s := &Server{
        addr:    addr,
        port:    port,
        timeout: 30 * time.Second, // defaults
    }
    
    for _, opt := range opts {
        opt(s)
    }
    
    return s
}

// Usage
server := NewServerWithOptions(
    "localhost",
    8080,
    WithTimeout(1*time.Minute),
    WithLogger(customLogger),
)

// ❌ Bad - exported fields that should be private
type BadServer struct {
    Addr   string    // Should these be exported?
    Port   int       // Probably not!
    Router *mux.Router
}
```

### 4. Method Receivers
```go
// Pointer receivers - use when:
// 1. Method modifies the receiver
// 2. Receiver is large struct (avoid copying)
// 3. Consistency (if any method uses pointer, all should)

type Counter struct {
    count int
}

func (c *Counter) Increment() {
    c.count++ // Modifies receiver, needs pointer
}

func (c *Counter) Value() int {
    return c.count // Could be value receiver, but use pointer for consistency
}

// Value receivers - use when:
// 1. Receiver is small (few fields, simple types)
// 2. Receiver is immutable
// 3. Receiver is a primitive type or small struct like time.Time

type Point struct {
    X, Y int
}

func (p Point) Distance(other Point) float64 {
    dx := float64(p.X - other.X)
    dy := float64(p.Y - other.Y)
    return math.Sqrt(dx*dx + dy*dy)
}

// ✅ Rule of thumb: When in doubt, use pointer receiver
```

## Concurrency Patterns

### 1. Goroutines and Channels
```go
// Basic goroutine
func doWork() {
    fmt.Println("Working...")
}

func main() {
    go doWork() // Launch goroutine
    time.Sleep(time.Second) // Wait (not ideal, see WaitGroup below)
}

// Channels - typed conduits for communication
func worker(jobs <-chan int, results chan<- int) {
    for job := range jobs {
        results <- job * 2 // Process and send result
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    // Start 3 workers
    for i := 0; i < 3; i++ {
        go worker(jobs, results)
    }
    
    // Send jobs
    for i := 1; i <= 9; i++ {
        jobs <- i
    }
    close(jobs)
    
    // Collect results
    for i := 1; i <= 9; i++ {
        fmt.Println(<-results)
    }
}

// ✅ Good - buffered vs unbuffered channels
unbuffered := make(chan int)      // Blocks until receiver ready
buffered := make(chan int, 10)    // Blocks only when full

// ✅ Good - directional channels in function signatures
func producer(out chan<- int) {    // Can only send
    out <- 42
}

func consumer(in <-chan int) {     // Can only receive
    val := <-in
    fmt.Println(val)
}
```

### 2. WaitGroups
```go
// ✅ Good - wait for multiple goroutines
func processFiles(files []string) {
    var wg sync.WaitGroup
    
    for _, file := range files {
        wg.Add(1)
        
        go func(f string) {
            defer wg.Done()
            
            // Process file
            data, err := os.ReadFile(f)
            if err != nil {
                log.Printf("Error reading %s: %v", f, err)
                return
            }
            
            // Do something with data
            fmt.Printf("Processed %s: %d bytes\n", f, len(data))
        }(file) // Pass file as parameter!
    }
    
    wg.Wait() // Block until all goroutines complete
}

// ❌ Bad - closure capturing loop variable
for _, file := range files {
    go func() {
        data, _ := os.ReadFile(file) // Race condition! 'file' changes
    }()
}
```

### 3. Select Statement
```go
// ✅ Good - multiplex channel operations
func main() {
    ch1 := make(chan string)
    ch2 := make(chan string)
    
    go func() {
        time.Sleep(1 * time.Second)
        ch1 <- "one"
    }()
    
    go func() {
        time.Sleep(2 * time.Second)
        ch2 <- "two"
    }()
    
    for i := 0; i < 2; i++ {
        select {
        case msg1 := <-ch1:
            fmt.Println("Received:", msg1)
        case msg2 := <-ch2:
            fmt.Println("Received:", msg2)
        case <-time.After(3 * time.Second):
            fmt.Println("Timeout")
            return
        }
    }
}

// With default for non-blocking operations
select {
case msg := <-ch:
    fmt.Println("Received:", msg)
default:
    fmt.Println("No message available")
}
```

### 4. Context for Cancellation
```go
import "context"

// ✅ Good - use context for cancellation and timeouts
func processWithTimeout(ctx context.Context, data []string) error {
    for _, item := range data {
        select {
        case <-ctx.Done():
            return ctx.Err() // Cancelled or timed out
        default:
            // Process item
            if err := process(item); err != nil {
                return err
            }
        }
    }
    return nil
}

func main() {
    // With timeout
    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()
    
    err := processWithTimeout(ctx, []string{"a", "b", "c"})
    if err != nil {
        log.Fatal(err)
    }
}

// HTTP server with context
func handler(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context() // Get request context
    
    // Use context for database queries
    rows, err := db.QueryContext(ctx, "SELECT * FROM users")
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    defer rows.Close()
    
    // Process rows...
}
```

### 5. Worker Pools
```go
// ✅ Good - bounded worker pool pattern
type Job struct {
    ID   int
    Data string
}

type Result struct {
    Job    Job
    Output string
    Error  error
}

func worker(id int, jobs <-chan Job, results chan<- Result) {
    for job := range jobs {
        // Simulate work
        output := fmt.Sprintf("Worker %d processed job %d: %s", 
            id, job.ID, job.Data)
        
        results <- Result{
            Job:    job,
            Output: output,
        }
    }
}

func main() {
    const numWorkers = 5
    const numJobs = 20
    
    jobs := make(chan Job, numJobs)
    results := make(chan Result, numJobs)
    
    // Start workers
    for w := 1; w <= numWorkers; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= numJobs; j++ {
        jobs <- Job{ID: j, Data: fmt.Sprintf("task-%d", j)}
    }
    close(jobs)
    
    // Collect results
    for a := 1; a <= numJobs; a++ {
        result := <-results
        fmt.Println(result.Output)
    }
}
```

### 6. Mutex for Shared State
```go
// ✅ Good - protect shared state with mutex
type SafeCounter struct {
    mu    sync.Mutex
    count map[string]int
}

func (c *SafeCounter) Inc(key string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count[key]++
}

func (c *SafeCounter) Value(key string) int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.count[key]
}

// RWMutex for read-heavy workloads
type Cache struct {
    mu    sync.RWMutex
    items map[string]string
}

func (c *Cache) Get(key string) (string, bool) {
    c.mu.RLock()         // Multiple readers OK
    defer c.mu.RUnlock()
    val, ok := c.items[key]
    return val, ok
}

func (c *Cache) Set(key, value string) {
    c.mu.Lock()          // Exclusive lock for writing
    defer c.mu.Unlock()
    c.items[key] = value
}

// ❌ Bad - race condition
type BadCounter struct {
    count int
}

func (c *BadCounter) Inc() {
    c.count++ // RACE! Multiple goroutines can access simultaneously
}
```

### 7. Once for Initialization
```go
// ✅ Good - ensure initialization happens exactly once
type Database struct {
    conn *sql.DB
}

var (
    db   *Database
    once sync.Once
)

func GetDB() *Database {
    once.Do(func() {
        conn, err := sql.Open("postgres", "connection-string")
        if err != nil {
            log.Fatal(err)
        }
        db = &Database{conn: conn}
    })
    return db
}

// Thread-safe singleton pattern
```

## Testing Best Practices

### 1. Table-Driven Tests
```go
// ✅ Good - comprehensive table-driven tests
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -2, -3, -5},
        {"mixed signs", -2, 3, 1},
        {"zeros", 0, 0, 0},
        {"large numbers", 1000000, 2000000, 3000000},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", 
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}

// ✅ Good - test helpers
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper() // Marks this as helper, error shows caller's line
    if !reflect.DeepEqual(got, want) {
        t.Errorf("got %v, want %v", got, want)
    }
}

func TestUser(t *testing.T) {
    user := NewUser("alice")
    assertEqual(t, user.Name, "alice")
}
```

### 2. Mocking with Interfaces
```go
// Define interface for testing
type UserStore interface {
    GetUser(id string) (*User, error)
    SaveUser(user *User) error
}

// Production implementation
type PostgresUserStore struct {
    db *sql.DB
}

func (s *PostgresUserStore) GetUser(id string) (*User, error) {
    // Real database logic
    return nil, nil
}

// Mock implementation for testing
type MockUserStore struct {
    users map[string]*User
}

func (m *MockUserStore) GetUser(id string) (*User, error) {
    user, ok := m.users[id]
    if !ok {
        return nil, fmt.Errorf("user not found")
    }
    return user, nil
}

func (m *MockUserStore) SaveUser(user *User) error {
    m.users[user.ID] = user
    return nil
}

// Test using mock
func TestUserService(t *testing.T) {
    mockStore := &MockUserStore{
        users: map[string]*User{
            "1": {ID: "1", Name: "Alice"},
        },
    }
    
    service := NewUserService(mockStore)
    
    user, err := service.GetUser("1")
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
    
    if user.Name != "Alice" {
        t.Errorf("got %s, want Alice", user.Name)
    }
}
```

### 3. Benchmarking
```go
// Benchmark function naming: BenchmarkXxx
func BenchmarkFibonacci(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Fibonacci(20)
    }
}

// With sub-benchmarks
func BenchmarkStringBuilding(b *testing.B) {
    tests := []struct {
        name  string
        count int
    }{
        {"small", 10},
        {"medium", 100},
        {"large", 1000},
    }
    
    for _, tt := range tests {
        b.Run(tt.name, func(b *testing.B) {
            for i := 0; i < b.N; i++ {
                var s string
                for j := 0; j < tt.count; j++ {
                    s += "x"
                }
            }
        })
    }
}

// Run benchmarks:
// go test -bench=. -benchmem
```

### 4. Test Fixtures and Setup
```go
func TestMain(m *testing.M) {
    // Setup before all tests
    setup()
    
    // Run tests
    code := m.Run()
    
    // Cleanup after all tests
    teardown()
    
    os.Exit(code)
}

func setup() {
    // Initialize test database, etc.
}

func teardown() {
    // Clean up resources
}

// Per-test setup
func TestWithSetup(t *testing.T) {
    // Setup
    db := setupTestDB(t)
    defer db.Close()
    
    // Test
    // ...
}

func setupTestDB(t *testing.T) *sql.DB {
    t.Helper()
    db, err := sql.Open("sqlite3", ":memory:")
    if err != nil {
        t.Fatalf("failed to open test db: %v", err)
    }
    return db
}
```

### 5. Testing HTTP Handlers
```go
func TestHandler(t *testing.T) {
    // Create request
    req := httptest.NewRequest("GET", "/users/123", nil)
    
    // Create response recorder
    w := httptest.NewRecorder()
    
    // Call handler
    handler := http.HandlerFunc(UserHandler)
    handler.ServeHTTP(w, req)
    
    // Check response
    if w.Code != http.StatusOK {
        t.Errorf("got status %d, want %d", w.Code, http.StatusOK)
    }
    
    var user User
    if err := json.NewDecoder(w.Body).Decode(&user); err != nil {
        t.Fatalf("failed to decode response: %v", err)
    }
    
    if user.ID != "123" {
        t.Errorf("got user ID %s, want 123", user.ID)
    }
}
```

## Common Patterns and Idioms

### 1. Defer, Panic, and Recover
```go
// ✅ Good - defer for cleanup
func readFile(filename string) error {
    f, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer f.Close() // Always closes, even if errors occur below
    
    // Process file
    data := make([]byte, 1024)
    _, err = f.Read(data)
    return err
}

// Multiple defers execute in LIFO order
func example() {
    defer fmt.Println("Third")
    defer fmt.Println("Second")
    defer fmt.Println("First")
    // Prints: First, Second, Third
}

// ✅ Good - recover from panics (use sparingly!)
func safeHandler(w http.ResponseWriter, r *http.Request) {
    defer func() {
        if err := recover(); err != nil {
            log.Printf("panic: %v", err)
            http.Error(w, "Internal Server Error", 500)
        }
    }()
    
    // Handler logic that might panic
    riskyOperation()
}

// ❌ Bad - using panic for control flow
func badValidate(data string) {
    if data == "" {
        panic("empty data") // Don't do this! Return an error instead
    }
}
```

### 2. Empty Interface and Type Assertions
```go
// empty interface can hold any type
var i interface{} = "hello"

// Type assertion
s, ok := i.(string)
if ok {
    fmt.Println("String:", s)
}

// Type switch
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d\n", v)
    case string:
        fmt.Printf("String: %s\n", v)
    case bool:
        fmt.Printf("Boolean: %t\n", v)
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}

// ✅ Good - use specific types when possible
// ❌ Bad - overusing interface{} reduces type safety
```

### 3. Embedding
```go
// Struct embedding (composition over inheritance)
type Base struct {
    Name string
}

func (b *Base) PrintName() {
    fmt.Println(b.Name)
}

type Derived struct {
    Base          // Embedded struct
    Age  int
}

func main() {
    d := Derived{
        Base: Base{Name: "Alice"},
        Age:  30,
    }
    
    d.PrintName()      // Can call Base's methods directly
    fmt.Println(d.Name) // Can access Base's fields directly
}

// Interface embedding
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

type ReadCloser interface {
    Reader
    Closer
}
```

### 4. Functional Options (Advanced)
```go
type Server struct {
    host    string
    port    int
    timeout time.Duration
    maxConn int
}

type Option func(*Server)

func WithTimeout(d time.Duration) Option {
    return func(s *Server) {
        s.timeout = d
    }
}

func WithMaxConnections(n int) Option {
    return func(s *Server) {
        s.maxConn = n
    }
}

func NewServer(host string, port int, opts ...Option) *Server {
    s := &Server{
        host:    host,
        port:    port,
        timeout: 30 * time.Second, // defaults
        maxConn: 100,
    }
    
    for _, opt := range opts {
        opt(s)
    }
    
    return s
}

// Usage
server := NewServer(
    "localhost",
    8080,
    WithTimeout(1*time.Minute),
    WithMaxConnections(500),
)
```

## HTTP Server Patterns

### 1. Basic HTTP Server
```go
package main

import (
    "encoding/json"
    "log"
    "net/http"
)

type User struct {
    ID   string `json:"id"`
    Name string `json:"name"`
}

func main() {
    http.HandleFunc("/users", usersHandler)
    http.HandleFunc("/users/", userHandler) // Note trailing slash
    
    log.Println("Server starting on :8080")
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatal(err)
    }
}

func usersHandler(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
    case http.MethodGet:
        getUsers(w, r)
    case http.MethodPost:
        createUser(w, r)
    default:
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    }
}

func getUsers(w http.ResponseWriter, r *http.Request) {
    users := []User{
        {ID: "1", Name: "Alice"},
        {ID: "2", Name: "Bob"},
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(users)
}

func createUser(w http.ResponseWriter, r *http.Request) {
    var user User
    if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    // Save user...
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(user)
}
```

### 2. Middleware Pattern
```go
// Middleware type
type Middleware func(http.Handler) http.Handler

// Logging middleware
func loggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}

// Authentication middleware
func authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        if token == "" {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        
        // Validate token...
        
        next.ServeHTTP(w, r)
    })
}

// Chain middleware
func chain(h http.Handler, middleware ...Middleware) http.Handler {
    for i := len(middleware) - 1; i >= 0; i-- {
        h = middleware[i](h)
    }
    return h
}

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/api/users", usersHandler)
    
    // Apply middleware
    handler := chain(
        mux,
        loggingMiddleware,
        authMiddleware,
    )
    
    http.ListenAndServe(":8080", handler)
}
```

### 3. Using gorilla/mux Router
```go
import "github.com/gorilla/mux"

func main() {
    r := mux.NewRouter()
    
    // Routes
    r.HandleFunc("/users", getUsers).Methods("GET")
    r.HandleFunc("/users", createUser).Methods("POST")
    r.HandleFunc("/users/{id}", getUser).Methods("GET")
    r.HandleFunc("/users/{id}", updateUser).Methods("PUT")
    r.HandleFunc("/users/{id}", deleteUser).Methods("DELETE")
    
    // Subrouters
    api := r.PathPrefix("/api/v1").Subrouter()
    api.HandleFunc("/products", getProducts).Methods("GET")
    
    // Middleware
    r.Use(loggingMiddleware)
    api.Use(authMiddleware)
    
    http.ListenAndServe(":8080", r)
}

func getUser(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]
    
    // Fetch user by ID
    user := User{ID: id, Name: "Alice"}
    
    json.NewEncoder(w).Encode(user)
}
```

## Database Patterns

### 1. Database Connection
```go
import (
    "database/sql"
    _ "github.com/lib/pq" // PostgreSQL driver
)

func initDB() (*sql.DB, error) {
    connStr := "postgres://user:password@localhost/dbname?sslmode=disable"
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        return nil, err
    }
    
    // Verify connection
    if err := db.Ping(); err != nil {
        return nil, err
    }
    
    // Configure connection pool
    db.SetMaxOpenConns(25)
    db.SetMaxIdleConns(5)
    db.SetConnMaxLifetime(5 * time.Minute)
    
    return db, nil
}
```

### 2. Query Patterns
```go
// Query single row
func getUser(db *sql.DB, id int) (*User, error) {
    var user User
    err := db.QueryRow(
        "SELECT id, name, email FROM users WHERE id = $1",
        id,
    ).Scan(&user.ID, &user.Name, &user.Email)
    
    if err == sql.ErrNoRows {
        return nil, fmt.Errorf("user not found")
    }
    if err != nil {
        return nil, err
    }
    
    return &user, nil
}

// Query multiple rows
func getUsers(db *sql.DB) ([]*User, error) {
    rows, err := db.Query("SELECT id, name, email FROM users")
    if err != nil {
        return nil, err
    }
    defer rows.Close() // Always close rows!
    
    var users []*User
    for rows.Next() {
        var user User
        if err := rows.Scan(&user.ID, &user.Name, &user.Email); err != nil {
            return nil, err
        }
        users = append(users, &user)
    }
    
    // Check for errors during iteration
    if err := rows.Err(); err != nil {
        return nil, err
    }
    
    return users, nil
}

// Insert with returning ID
func createUser(db *sql.DB, user *User) error {
    err := db.QueryRow(
        "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id",
        user.Name,
        user.Email,
    ).Scan(&user.ID)
    
    return err
}

// Update
func updateUser(db *sql.DB, user *User) error {
    result, err := db.Exec(
        "UPDATE users SET name = $1, email = $2 WHERE id = $3",
        user.Name,
        user.Email,
        user.ID,
    )
    if err != nil {
        return err
    }
    
    rows, err := result.RowsAffected()
    if err != nil {
        return err
    }
    
    if rows == 0 {
        return fmt.Errorf("user not found")
    }
    
    return nil
}
```

### 3. Transactions
```go
func transferMoney(db *sql.DB, fromID, toID int, amount float64) error {
    tx, err := db.Begin()
    if err != nil {
        return err
    }
    defer tx.Rollback() // Rollback if not committed
    
    // Deduct from sender
    _, err = tx.Exec(
        "UPDATE accounts SET balance = balance - $1 WHERE id = $2",
        amount,
        fromID,
    )
    if err != nil {
        return err
    }
    
    // Add to receiver
    _, err = tx.Exec(
        "UPDATE accounts SET balance = balance + $1 WHERE id = $2",
        amount,
        toID,
    )
    if err != nil {
        return err
    }
    
    // Commit transaction
    return tx.Commit()
}
```

## Performance Optimization

### 1. Profiling
```go
import (
    "runtime/pprof"
    _ "net/http/pprof"
)

// CPU profiling
func main() {
    f, err := os.Create("cpu.prof")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()
    
    pprof.StartCPUProfile(f)
    defer pprof.StopCPUProfile()
    
    // Your code here
}

// Memory profiling
func memProfile() {
    f, err := os.Create("mem.prof")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()
    
    runtime.GC()
    if err := pprof.WriteHeapProfile(f); err != nil {
        log.Fatal(err)
    }
}

// HTTP profiling endpoints (import _ "net/http/pprof")
func main() {
    go func() {
        log.Println(http.ListenAndServe("localhost:6060", nil))
    }()
    
    // Your application code
}

// View profiles:
// go tool pprof cpu.prof
// go tool pprof http://localhost:6060/debug/pprof/heap
```

### 2. String Building
```go
// ❌ Bad - inefficient string concatenation
func bad(n int) string {
    var s string
    for i := 0; i < n; i++ {
        s += "x" // Creates new string each iteration
    }
    return s
}

// ✅ Good - use strings.Builder
func good(n int) string {
    var b strings.Builder
    b.Grow(n) // Pre-allocate if size is known
    for i := 0; i < n; i++ {
        b.WriteString("x")
    }
    return b.String()
}
```

### 3. Slice Pre-allocation
```go
// ❌ Bad - slice grows dynamically
func bad() []int {
    var nums []int
    for i := 0; i < 1000; i++ {
        nums = append(nums, i) // May reallocate multiple times
    }
    return nums
}

// ✅ Good - pre-allocate when size is known
func good() []int {
    nums := make([]int, 0, 1000) // capacity 1000
    for i := 0; i < 1000; i++ {
        nums = append(nums, i) // No reallocation needed
    }
    return nums
}

// ✅ Good - pre-allocate and index directly
func better() []int {
    nums := make([]int, 1000) // length and capacity 1000
    for i := 0; i < 1000; i++ {
        nums[i] = i
    }
    return nums
}
```

### 4. Avoid Unnecessary Allocations
```go
// ❌ Bad - allocates in loop
for i := 0; i < n; i++ {
    result := process(data[i]) // allocates each iteration
    results = append(results, result)
}

// ✅ Good - reuse allocations
var result Result
for i := 0; i < n; i++ {
    processInPlace(data[i], &result) // reuse result
    results = append(results, result)
}
```

## Common Gotchas

### 1. Slice vs Array
```go
// Arrays have fixed size, slices are dynamic
var arr [5]int           // Array
var slice []int          // Slice
slice = make([]int, 5)   // Slice with length 5

// Arrays are value types, slices are references
arr1 := [3]int{1, 2, 3}
arr2 := arr1             // Copies the entire array
arr2[0] = 99
fmt.Println(arr1[0])     // Still 1

slice1 := []int{1, 2, 3}
slice2 := slice1         // References same underlying array
slice2[0] = 99
fmt.Println(slice1[0])   // Now 99!
```

### 2. Range Loop Variable
```go
// ❌ Bad - loop variable reused
var funcs []func()
for _, val := range []int{1, 2, 3} {
    funcs = append(funcs, func() {
        fmt.Println(val) // Always prints 3!
    })
}

// ✅ Good - capture variable
var funcs []func()
for _, val := range []int{1, 2, 3} {
    val := val // Shadow variable
    funcs = append(funcs, func() {
        fmt.Println(val) // Prints 1, 2, 3
    })
}
```

### 3. Map Iteration Order
```go
// Map iteration order is RANDOM
m := map[string]int{
    "a": 1,
    "b": 2,
    "c": 3,
}

for k, v := range m {
    fmt.Println(k, v) // Order varies each run
}

// Sort keys for consistent order
keys := make([]string, 0, len(m))
for k := range m {
    keys = append(keys, k)
}
sort.Strings(keys)

for _, k := range keys {
    fmt.Println(k, m[k]) // Always prints a, b, c
}
```

### 4. Nil Slices and Empty Slices
```go
var nilSlice []int           // nil
emptySlice := []int{}        // not nil, but empty
madeSlice := make([]int, 0)  // not nil, but empty

fmt.Println(nilSlice == nil)   // true
fmt.Println(emptySlice == nil) // false
fmt.Println(len(nilSlice))     // 0
fmt.Println(len(emptySlice))   // 0

// Both work the same for most operations
nilSlice = append(nilSlice, 1)
emptySlice = append(emptySlice, 1)

// Prefer nil slices for zero value
type Response struct {
    Items []Item `json:"items,omitempty"` // nil serializes to null
}
```

## File Creation Workflow

When creating Go files:

1. **Create in `/home/claude` first** for development and testing
2. **Use proper package structure**:
```
   /home/claude/myproject/
   ├── go.mod
   ├── main.go
   └── pkg/
       └── mypackage/
           └── myfile.go
```
3. **Run `go mod init`** for new projects
4. **Test with `go build` or `go run`**
5. **Format with `go fmt`**
6. **Copy to `/mnt/user-data/outputs/`** for delivery

Example workflow:
```bash
# Create project structure
mkdir -p /home/claude/myapp/cmd/myapp
mkdir -p /home/claude/myapp/pkg/handlers

# Initialize module
cd /home/claude/myapp
go mod init github.com/user/myapp

# Create files
create_file /home/claude/myapp/cmd/myapp/main.go
create_file /home/claude/myapp/pkg/handlers/user.go

# Format code
go fmt ./...

# Test build
go build ./cmd/myapp

# Copy to outputs
cp -r /home/claude/myapp /mnt/user-data/outputs/
```

## Essential Go Commands
```bash
# Build
go build                    # Build current package
go build -o myapp          # Build with specific output name
go build ./cmd/myapp       # Build specific package

# Run
go run main.go             # Run single file
go run ./cmd/myapp         # Run package

# Test
go test                    # Test current package
go test ./...              # Test all packages
go test -v                 # Verbose output
go test -cover             # With coverage
go test -bench=.           # Run benchmarks
go test -race              # Race detector

# Module management
go mod init                # Initialize module
go mod tidy                # Clean up dependencies
go mod vendor              # Vendor dependencies
go get package@version     # Add/update dependency

# Formatting and linting
go fmt ./...               # Format all files
goimports -w .             # Organize imports
go vet ./...               # Run static analysis
golangci-lint run          # Comprehensive linting

# Documentation
go doc package             # View package docs
godoc -http=:6060          # Local doc server

# Other
go version                 # Show Go version
go env                     # Show Go environment
go clean                   # Clean build cache
```

## Resources

- Official Documentation: https://go.dev/doc/
- Effective Go: https://go.dev/doc/effective_go
- Go by Example: https://gobyexample.com/
- Standard Library: https://pkg.go.dev/std
- Go Blog: https://go.dev/blog/
- Go Proverbs: https://go-proverbs.github.io/

---

**Remember:** Go values simplicity, clarity, and practicality. Write code that is easy to read and maintain. When in doubt, follow the standard library's patterns and idioms. Use `go fmt`, write tests, and leverage Go's excellent tooling.
