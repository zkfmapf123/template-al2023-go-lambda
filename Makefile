FUNC_NAME=inspectRuleToFunction

build:
	mkdir -p dist
	env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -tags lambda.norpc -ldflags="-s -w" -o ./dist/bootstrap main.go

chmod:
	chmod +x ./dist/bootstrap

zip:
	cd ./dist && zip bootstrap.zip bootstrap && cd ..

deploy:
	@make build
	@make chmod
	@make zip
	@aws lambda update-function-code --function-name  ${FUNC_NAME} --zip-file fileb://./dist/bootstrap.zip