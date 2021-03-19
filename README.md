# Go Lambda Template
A template repository for Go-based AWS lambda functions with LocalStack setup.

## Prerequisites

- Docker
- LocalStack (pip)
- Go

## How to run
```
# Start LocalStack, build and upload the function, invoke, print response and clean up.
make run


# Start LocalStack, builds and upload the function
make start
# Invoke the function, storing the output under 'localstack/response'
make invoke
# Build and upload the function and invoke it, saving the response
make refresh
# Stops LocalStack and cleans up 'localstack/build' and 'localstack/response'
make clean
```