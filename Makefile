APP_NAME=gocrud-book-store-service


# installs required binaries for linting and protobuf generation for local depvelopment 
# as well as a pre commit hook to lint all files before committing
configure:
	@echo "Installing golangci-lint to GOBIN..."
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "Installing dependencies from go.mod..."
	@go mod download && go mod verify
	@echo "Installing pre-commit hook ..."
	@cp pre-commit.sh .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Done."

### CI SCRIPTS ###
ci:
	go mod download && go mod verify

vuln_scan:
	go run --mod=mod golang.org/x/vuln/cmd/govulncheck ./...

synth_ci:
	cdk synth >>/dev/null

test_report:
	go run --mod=mod gotest.tools/gotestsum --junitfile unit-tests.xml  -- -coverprofile=cover.out -covermode count -p 1 ./...
	grep -v -E -f .covignore cover.out > coverage.filtered.out
	mv coverage.filtered.out cover.out
	go tool cover -html=cover.out -o coverage.html
	go run --mod=mod github.com/boumenot/gocover-cobertura <cover.out > coverage.xml

ecr_deploy_ci:
	cdk deploy \*ecr-stack --require-approval never

ecr_diff_ci:
	cdk diff \*ecr-stack

build_tag_ci:
	REPO_URI=$(shell aws ssm get-parameter --name "/config/${APP_NAME}/ecr/uri" --query "Parameter.Value" --output text); \
	TAG=$(if $(strip $(GITHUB_SHA)),$(GITHUB_SHA),no-tag); \
	PLATFORM=$(if $(strip $(TARGET_PLATFORM)),$(TARGET_PLATFORM),linux/arm64); \
	docker buildx build --platform $$PLATFORM -t $$REPO_URI:$$TAG .

build_tag_push_ci:
	REPO_URI=$(shell aws ssm get-parameter --name "/config/${APP_NAME}/ecr/uri" --query "Parameter.Value" --output text); \
	TAG=$(if $(strip $(GITHUB_SHA)),$(GITHUB_SHA),no-tag); \
	PLATFORM=$(if $(strip $(TARGET_PLATFORM)),$(TARGET_PLATFORM),linux/arm64); \
	docker buildx build --platform $$PLATFORM -t $$REPO_URI:$$TAG .; \
	docker push $$REPO_URI:$$TAG

deploy_stacks_ci:
	cdk deploy \*db-stack \*app-stack --require-approval never

diff_stacks_ci:
	cdk diff \*db-stack \*app-stack

### UTILITY FOR LOCAL DEVELOPMENT ###
lint:
	golangci-lint run ./...

dia:
	npx cdk-dia

update_deps:
	go get -u ./...
	go mod tidy
	go mod verify

