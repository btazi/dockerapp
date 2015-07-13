db() {
	docker run -P --volumes-from app_data --name app_db -e POSTGRES_USER=app_user -e POSTGRES_PASSWORD=$APP_PWD -t postgres:latest 
}

data() {
	docker run -v /var/lib/postgresql/data --name app_data -t busybox
}

app() {
	docker run -p 3000:3000 --link app_db:postgres --name app btazi/app #docker build -t spawnge/app .
}

action=$1

${action} #sh script.sh db