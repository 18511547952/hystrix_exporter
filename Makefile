SOURCE_FILES?=./...
TEST_PATTERN?=.
TEST_OPTIONS?=

# Install all the build and lint dependencies
setup:
	go get -u github.com/alecthomas/gometalinter
	go get -u github.com/golang/dep/cmd/dep
	go get -u github.com/pierrre/gotestcover
	go get -u golang.org/x/tools/cmd/cover
	dep ensure
	gometalinter --install

# Run all the tests
test:
	gotestcover $(TEST_OPTIONS) -covermode=atomic -coverprofile=coverage.txt $(SOURCE_FILES) -run $(TEST_PATTERN) -timeout=2m

# Run all the tests and opens the coverage report
cover: test
	go tool cover -html=coverage.txt

# Run all the linters
lint:
	gometalinter --vendor ./...

# Run all the tests and code checks
ci: test lint

# Build a beta version of goreleaser
build:
	go build

.DEFAULT_GOAL := build
