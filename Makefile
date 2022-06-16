.PHONY: build run

REPO  ?= vprix/vscode
TAG   ?= develop


build:
	docker build -f ./dockerfile-vprix-vscode -t $(REPO):$(TAG) .

run:
	docker run -it --rm \
	-p 8080:8080 \
	--name vscode \
	$(REPO):$(TAG)

push:
	docker push $(REPO):$(TAG)

exec:
	docker exec -ti vscode bash

REPO_CHROMIUM  ?= vprix/chromium
TAG_CHROMIUM   ?= develop

build_chromium:
	docker build -f ./dockerfile-vprix-chromium -t $(REPO_CHROMIUM):$(TAG_CHROMIUM) .

run_chromium:
	docker run -it --rm \
	-p 8080:8080 \
	--name chromium \
	$(REPO_CHROMIUM):$(TAG_CHROMIUM)

push_chromium:
	docker push $(REPO_CHROMIUM):$(TAG_CHROMIUM)

exec_chromium:
	docker exec -ti chromium bash
