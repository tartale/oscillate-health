build:
	docker build -t quay.io/tartale/tools:oscillate-health-v1 -t quay.io/tartale/tools:oscillate-health-latest .

push: build
	docker push quay.io/tartale/tools:oscillate-health-v1
	docker push quay.io/tartale/tools:oscillate-health-latest
