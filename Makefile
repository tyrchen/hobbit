CHECK=\033[32m✔\033[39m
DONE="\n$(CHECK) Done.\n"

SERVER=jcnrd.us
PROJECT=hobbit
PATH=deployment/$(PROJECT)
SUPERVISORCTL=/usr/bin/supervisorctl
SUCOPY=/bin/sucopy
SSH=/usr/bin/ssh
ECHO=/bin/echo -e
NPM=/usr/local/bin/npm
PIP=/usr/bin/pip
SUDO=/usr/bin/sudo
VENV=~/.virtualenvs/$(PROJECT)/bin/activate
ENTER_VENV=cd $(PATH); source $(VENV); git pull; pip install -r requirements.txt; python manage.py collectstatic --noinput

remote_deploy:
	@$(SSH) -t $(SERVER) "echo Deploy $(PROJECT) to the $(SERVER) server.; $(ENTER_VENV);  git pull; make deploy;"

dependency:
	@$(ECHO) "\nInstall project dependencies..."
	@pip install -r requirements.txt
	@echo ${DONE}
	
collect:
	@echo "\n\nCollecting static files..."
	@python manage.py collectstatic --noinput
	@echo ${DONE}


configuration:
	@$(ECHO) "\nUpdate configuration..."
	@$(SUDO) $(SUCOPY) -r _deploy/etc/. /etc/.

supervisor:
	@$(ECHO) "\nUpdate supervisor configuration..."
	@$(SUDO) $(SUPERVISORCTL) reread
	@$(SUDO) $(SUPERVISORCTL) update
	@$(ECHO) "\nRestart $(PROJECT)..."
	@$(SUDO) $(SUPERVISORCTL) restart $(PROJECT)

nginx:
	@$(ECHO) "\nRestart nginx..."
	@$(SUDO) /etc/init.d/nginx restart

deploy: configuration supervisor nginx
	@$(ECHO) $(DONE)
