NAME = cddr/dev-stack

.PHONY: build

build:
	docker build --rm -t $(NAME):$(VERSION) .
