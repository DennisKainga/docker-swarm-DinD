
TOKEN = $(shell docker exec swarm-manager docker swarm join-token -q worker)

.PHONY: join visualizer

join:
	@echo "Joining workers to manager..."
	docker exec -it swarm-worker-1 docker swarm join --token $(TOKEN) manager:2377 || true
	docker exec -it swarm-worker-2 docker swarm join --token $(TOKEN) manager:2377 || true
	docker exec -it swarm-worker-3 docker swarm join --token $(TOKEN) manager:2377 || true

# Dont worry about this for now: UNLESS YOU NEED TO VISUALIZE THE NODES ONTHE WEB
visualizer:
	@echo "Deploying visualizer"
	docker exec -it swarm-manager \
	docker service create \
	--name swarm-viz \
	--publish 8080:8080 \
	--constraint 'node.role == manager' \
	--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
	dockersamples/visualizer