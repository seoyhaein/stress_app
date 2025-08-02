# Makefile for building and pushing Docker images to GitHub Container Registry (GHCR)
GH_OWNER    := seoyhaein
# 이미지 이름, 태그
IMAGE_NAME  := stress_app
TAG         := v1
# GHCR 레지스트리 URL
REGISTRY    := ghcr.io/$(GH_OWNER)
FULL_IMAGE  := $(REGISTRY)/$(IMAGE_NAME):$(TAG)

# 기본 목표
.PHONY: all
all: build
#all: build push

# 1) Docker 이미지 빌드
.PHONY: build
build:
	@echo ">> Building Docker image $(FULL_IMAGE)"
	sudo docker build \
	  -t $(FULL_IMAGE) \
	  -f Dockerfile .

# 그냥 터미널에서 푸시하자. 로그인 정보를 가져오지 못해서 에러난다. 넣어주면 보안적으로 위험하다.
# docker push ghcr.io/seoyhaein/stress_app:v1
# docker pull ghcr.io/seoyhaein/stress_app:v1
# docker image ls ghcr.io/seoyhaein/stress_app

# 2) GHCR에 푸시
#.PHONY: push
#push:
#	@echo ">> Pushing to GHCR: $(FULL_IMAGE)"
#	# ghcr.io에 로그인 되어 있어야 함. ~/.bashrc 에 작성했음.
#	#   echo $CR_PAT | docker login ghcr.io -u $(GH_OWNER) --password-stdin
#	docker push $(FULL_IMAGE)