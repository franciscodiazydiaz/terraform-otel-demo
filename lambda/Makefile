all: clean build

clean:
	git clean -fdx

build:
	GOOS=linux GOARCH=amd64 go build -o ./build/bootstrap .
