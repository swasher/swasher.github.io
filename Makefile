dummy:
	@echo Dont run without arguments!

serve:
	hugo serve -D

deploy:
	git commit -am "commit"
	git push origin master


