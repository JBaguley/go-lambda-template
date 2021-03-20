.PHONY: test run invoke call clean setup upload start

PAYLOAD=localstack/requests/payload.json
TMPDIR=/tmp/localstack

run: start invoke clean

refresh: build update invoke

start: setup build upload

setup: 
	@echo "Starting LocalStack..."
	@TMPDIR=${TMPDIR} docker-compose -f localstack/docker-compose.yml up -d
	@sleep 2
	@echo "Creating Lambda execution IAM role..."
	-@aws --endpoint http://localhost:4566 iam create-role --role-name lambda-ex --assume-role-policy-document file://localstack/cfts/trust-policy.json

build:
	@echo "Compiling..."
	@GOOS=linux go build -o localstack/build/main main.go
	@echo "Zipping..."
	@zip localstack/build/function.zip localstack/build/main

upload:
	@echo "Uploading Lambda..."
	@aws --endpoint http://localhost:4566 lambda create-function --function-name my-function --runtime go1.x --zip-file fileb://localstack/build/function.zip --handler localstack/build/main --role arn:aws:iam::000000000000:role/lambda-ex

update:
	@echo "Updating Lambda..."
	@aws --endpoint http://localhost:4566 lambda update-function-code --function-name my-function --zip-file fileb://localstack/build/function.zip

invoke:
	@echo "Invoking Lambda..."
	@mkdir -p localstack/response
	@aws --endpoint http://localhost:4566 lambda invoke --function-name my-function --payload file://$(PAYLOAD) localstack/response/response.json
	@cat localstack/response/response.json

call: invoke

clean:
	@echo "Stopping LocalStack..."
	-@docker kill go-lambda-localstack
	@echo "Cleaning up..."
	-@rm -rf localstack/build
	-@rm -rf localstack/response

cucumber:
	@cd test/cucumber;\
		godog
