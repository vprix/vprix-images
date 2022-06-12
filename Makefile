.PHONY: build run

REPO  ?= vprix/vscode
TAG   ?= develop


build:
	docker build -f ./dockerfile-vprix-vs-code -t $(REPO):$(TAG) .

run:
	docker run -it --rm \
	-p 8080:8080 \
	--name vscode \
	$(REPO):$(TAG)

push:
	docker push $(REPO):$(TAG)

exec:
	docker exec -ti vscode bash