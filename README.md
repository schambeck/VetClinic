# API vetclinic

> Vet Clinic Service application.

## Tech Stack

- Java 21
- Spring Boot
- MySQL, Flyway
- Swagger

## Running project for development

### Start infra (MySQL)
To start the MySQL database, follow these steps:
```bash
$ make compose-up-db
```

### 🚀 Build artifact
To build the application, follow these steps:
```bash
$ make dist
```

### ☕ Run backend
To run the application, follow these steps:
```bash
$ make run
```

### 🐳 Run application in Docker
To run the backend and database through Docker, follow these steps:
```bash
$ make docker-build
$ make compose-up
```

## Application URLs

### Swagger
🔗 http://localhost:8080

### API Context Path
🔗 http://localhost:8080/v1
