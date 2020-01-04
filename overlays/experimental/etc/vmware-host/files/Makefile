.PHONY: clean build launch start console

clean:
	docker rm -v $(shell docker ps -a -q -f status=exited)
	docker system prune

build:
	@docker build -t $$USER:vmware .

start:
	@$(MAKE) F="-i" C="cd /usr/lib/x86_64-linux-gnu && sudo rm -rf dri && sudo ln -sf /run/opengl-driver/lib/* . && cd /app && sudo shoreman Procfile" launch

console:
	@$(MAKE) F="-it" C="cd $$HOME && /bin/bash --login && exit 0" launch

launch:
	@docker run --rm $(F) --privileged --net host \
		--user="1000:100" \
		--group-add="1" \
		--group-add="2" \
		--group-add="6" \
		--group-add="17" \
		--group-add="26" \
		--group-add="174" \
		\
		--device=/dev \
		\
		--volume=/sys:/sys:ro \
		--volume=/nix:/nix:ro \
		--volume=/run/opengl-driver:/run/opengl-driver:ro \
		--volume=/etc/asound.conf:/etc/asound.conf:ro \
		\
		--volume=$$HOME/.vmware/networking:/etc/vmware/networking \
		--volume=$$HOME/.vmware/vmnet1:/etc/vmware/vmnet1 \
		--volume=$$HOME/.vmware/vmnet8:/etc/vmware/vmnet8 \
		--volume=$$HOME/.config/vmware/isoimages:/usr/lib/vmware/isoimages \
		\
		--volume=/etc/group:/etc/group:ro \
		--volume=/etc/passwd:/etc/passwd:ro \
		--volume=/etc/shadow:/etc/shadow:ro \
		--volume=/run/current-system/sw/bin:/run/current-system/sw/bin:ro \
		\
		--env="DISPLAY=$$DISPLAY" \
		--env="XAUTHORITY=$$HOME/.Xauthority" \
		--env="LD_LIBRARY_PATH=/opt/opengl-driver/lib" \
		\
		--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
		--volume=/run/user/1000/gdm/Xauthority:$$HOME/.Xauthority:ro \
		--volume=/run/user/1000/pulse:/run/user/1000/pulse:rw \
		\
		--volume=/etc/fonts:/etc/fonts:ro \
		\
		--volume=$$HOME/VM:$$HOME/vmware \
		--volume=/run/media/$$USER/data:$$HOME/data \
		--volume=$$HOME/Downloads:$$HOME/Downloads \
		--volume=$$HOME/.vmware:$$HOME/.vmware \
		--volume=$$HOME/.cache/vmware:$$HOME/.cache/vmware \
		--volume=$$HOME/.local/share/vmware:$$HOME/.local/share \
		$$USER:vmware bash -c "$(C)"	
