IMAGE = ghcr.io/belchiorg/game-downloader
TAG   ?= latest

GITHUB_TOKEN ?= $(shell pass pi5-token)

.PHONY: login build push all

login:
			echo $(GITHUB_TOKEN) | docker login ghcr.io -u belchiorg --password-stdin

build:
			docker build -t $(IMAGE):$(TAG) .

push:
			docker push $(IMAGE):$(TAG)

all: build push