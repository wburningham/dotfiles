# Variable Initialization for HTTP Servers and Applications

This covers best practices for initializing variables in Go applications, particularly HTTP servers and CLI tools. Variable initialization typically occurs at program startup and involves reading environment variables, setting defaults, and ensuring required configuration is present.

## Key Principles

- **Initialize at package level** using function literals, not in `init()` functions or scattered throughout `main()`
- **Use `cmp.Or`** (Go 1.22+) for setting default values from environment variables
- **Avoid single Config structs** - spread variables across logical groups for better organization
- **Handle required variables gracefully** - validate early and provide clear error messages
- **Include validation** - ensure configuration values are valid before use
- **Use appropriate types** - convert string environment variables to proper types (`int`, `bool`, etc.)

## Anti-patterns to Avoid

- **Don't use `init()` functions** for variable initialization
- **Don't scatter initialization throughout `main()`** - use package-level variables
- **Don't put all configuration in a single struct** - organize by logical groups
- **Don't ignore errors** from type conversion - handle them appropriately
- **Don't use global variables for mutable state** - reserve for configuration

## Basic Pattern

Use package-level variables initialized with function literals that read from environment variables:

```go
import (
    "cmp"
    "os"
    "strconv"
)

// Server configuration
var (
    Port     = cmp.Or(os.Getenv("PORT"), "8080")
    Host     = cmp.Or(os.Getenv("HOST"), "localhost")
    Debug    = func() bool {
        val, _ := strconv.ParseBool(os.Getenv("DEBUG"))
        return val
    }()
)

// Database configuration
var (
    DBHost     = cmp.Or(os.Getenv("DB_HOST"), "localhost")
    DBPort     = cmp.Or(os.Getenv("DB_PORT"), "5432")
    DBName     = cmp.Or(os.Getenv("DB_NAME"), "myapp")
    DBUser     = cmp.Or(os.Getenv("DB_USER"), "postgres")
    DBPassword = os.Getenv("DB_PASSWORD") // Required, no default
)

// External service URLs
var (
    RedisURL    = cmp.Or(os.Getenv("REDIS_URL"), "redis://localhost:6379")
    MetricsURL  = cmp.Or(os.Getenv("METRICS_URL"), "http://localhost:9090")
)
```

## Handling Required Variables

For variables that must be set, validate them early in `main()` and provide clear error messages:

```go
func main() {
    // Validate required configuration
    if DBPassword == "" {
        log.Fatal("DB_PASSWORD environment variable is required")
    }

    // Continue with application startup...
}
```

## Type Conversion and Validation

Use function literals for type conversion and validation:

```go
var (
    // Boolean conversion
    EnableTLS = func() bool {
        val := cmp.Or(os.Getenv("ENABLE_TLS"), "false")
        enabled, _ := strconv.ParseBool(val)
        return enabled
    }()

    // Integer conversion with validation
    MaxConnections = func() int {
        val := cmp.Or(os.Getenv("MAX_CONNECTIONS"), "100")
        maxConn, err := strconv.Atoi(val)
        if err != nil || maxConn < 1 {
            maxConn = 100 // fallback to default
        }
        return maxConn
    }()

    // Duration parsing
    Timeout = func() time.Duration {
        val := cmp.Or(os.Getenv("TIMEOUT"), "30s")
        duration, err := time.ParseDuration(val)
        if err != nil {
            duration = 30 * time.Second // fallback
        }
        return duration
    }()
)
```

## Complex Initialization

For more complex setup, use function literals that return the final value:

```go
var (
    DatabaseURL = func() string {
        host := cmp.Or(os.Getenv("DB_HOST"), "localhost")
        port := cmp.Or(os.Getenv("DB_PORT"), "5432")
        name := cmp.Or(os.Getenv("DB_NAME"), "myapp")
        user := cmp.Or(os.Getenv("DB_USER"), "postgres")

        // Construct connection string
        return fmt.Sprintf("postgres://%s@%s:%s/%s?sslmode=disable",
            user, host, port, name)
    }()
)
```

## Organization by Concern

Group related variables together and use comments to indicate their purpose:

```go
// Server configuration
var (
    ServerPort = cmp.Or(os.Getenv("SERVER_PORT"), "8080")
    ServerHost = cmp.Or(os.Getenv("SERVER_HOST"), "0.0.0.0")
    ServerTLS  = func() bool {
        val, _ := strconv.ParseBool(cmp.Or(os.Getenv("SERVER_TLS"), "false"))
        return val
    }()
)

// Security configuration
var (
    JWTSecret     = os.Getenv("JWT_SECRET") // Required
    SessionSecret = cmp.Or(os.Getenv("SESSION_SECRET"), "default-session-key")
    CORSOrigins   = cmp.Or(os.Getenv("CORS_ORIGINS"), "*")
)

// Feature flags
var (
    EnableMetrics = func() bool {
        val, _ := strconv.ParseBool(cmp.Or(os.Getenv("ENABLE_METRICS"), "true"))
        return val
    }()
    EnableTracing = func() bool {
        val, _ := strconv.ParseBool(cmp.Or(os.Getenv("ENABLE_TRACING"), "false"))
        return val
    }()
)
```

## Validation in main()

Always validate configuration in `main()` before starting the application:

```go
import "net/url"

func main() {
    // Validate required configuration
    requiredVars := []string{"JWT_SECRET", "DB_PASSWORD"}
    for _, envVar := range requiredVars {
        if os.Getenv(envVar) == "" {
            log.Fatalf("Required environment variable %s is not set", envVar)
        }
    }

    // Validate configuration values
    if _, err := url.Parse(MetricsURL); err != nil {
        log.Fatalf("Invalid METRICS_URL: %s (%v)", MetricsURL, err)
    }

    // Start application...
}
```

## Benefits of This Approach

1. **Clear defaults** - `cmp.Or` makes default values obvious
2. **Type safety** - Function literals allow proper type conversion
3. **Validation** - Easy to validate in `main()` before startup
4. **Testability** - Package-level variables can be overridden in tests
5. **Documentation** - Variable names and comments serve as configuration documentation
