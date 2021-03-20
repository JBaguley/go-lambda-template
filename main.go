package main

import (
	"github.com/JBaguley/go-lambda-template/internal/handler"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handler.HandleRequest)
}
