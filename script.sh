db() {
	docker run -P --name app_db -e POSTGRES_USER=app_user -e POSTGRES_PASSWORD=$APP_PWD -t postgres:latest 
}

app() {
	docker run -p 3000:3000 --link app_db:postgres spawnge/app #docker build -t spawnge/app .
}

action=$1

${action} #sh script.sh db