dummy:
	@echo Dont run without arguments!

serve:
	hugo serve -D

push:
	git commit -am "commit"
	git push origin master