APP = api-vetclinic
VERSION = 1.0.0
JAR = ${APP}-${VERSION}.jar
TARGET_JAR = target/${JAR}

DOCKER_IMAGE = ${APP}:${VERSION}
DOCKER_FOLDER = .
DOCKER_CONF = ${DOCKER_FOLDER}/Dockerfile
COMPOSE_CONF = ${DOCKER_FOLDER}/compose.yaml

# Maven

clean:
	./mvnw clean

dist-run: dist run

dist:
	./mvnw clean package -DskipTests=true -Dmaven.plugin.validation=BRIEF

run:
	java -jar ${TARGET_JAR}

check:
	./mvnw clean test -Dmaven.plugin.validation=BRIEF

verify:
	./mvnw clean verify -Dmaven.plugin.validation=BRIEF

# Tests

# surefire-report:
# 	./mvnw clean surefire-report:report

#failsafe-report:
#	./mvnw clean surefire-report:report

# jacoco-report:
# 	./mvnw clean test jacoco:report -Dmaven.plugin.validation=BRIEF -Pcoverage

# Compose

compose-down-up: compose-down compose-up

compose-down:
	docker compose down

compose-up:
	docker compose up -d

compose-up-db:
	docker compose up -d db

# Docker

dist-docker-build: dist docker-build

docker-build:
	docker build -f ${DOCKER_CONF} -t ${DOCKER_IMAGE} .

docker-run:
	docker run -d \
		--name ${APP} \
	  	--env SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/vetclinic?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC \
		--publish 8080:8080 \
		${DOCKER_IMAGE}

docker-tag:
	docker tag ${APP} ${DOCKER_IMAGE}

docker-push:
	docker push ${DOCKER_IMAGE}

docker-pull:
	docker pull ${DOCKER_IMAGE}

# sonar

sonar-start:
	docker run -d --name sonarqube -p 9020:9000 sonarqube:latest

sonar-run:
	./mvnw clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar \
		-Dsonar.projectKey=api-vetclinic \
		-Dsonar.projectName='api-vetclinic' \
		-Dsonar.host.url=http://localhost:9000 \
		-Dsonar.token=sqp_694eb1bb2011f15748c25e44a90b2e2391272724 \
		-Dmaven.plugin.validation=NONE
