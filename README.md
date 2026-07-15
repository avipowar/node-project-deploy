## initialize project and install dependency

- npm init -y
- npm i express
- npm i @types/express -D
- npm i @types/node -D

## create index.js file

- create express server

## create DOCKERFILE

- create this file for the dockerize the project

## create deployment folder

- write deployment things here

# multi-Stage Build

• Uses multiple FROM statements.
• First stage builds the application.
• Second stage creates the production image.
• Only required files are copied.
• Reduces image size.
• Improves security.
• Speeds up deployment.

# Without Multi-Stage Build

Docker Image

src/
node_modules/
package.json
dist/
npm
Build Tools

Image Size: 1 GB

# With Multi-Stage Build

Stage 1

src/
↓

Build

↓

dist/

---

Stage 2

dist/

↓

Final Image

Image Size: 80 MB

# instructions

- FROM => Start building my image from this base image.
- node:22-alpine => This is the base image.(Node.js Version = 22 Operating System = Alpine Linux)
- AS builder => This creates a name for this stage.
- Start with a Node.js 22 Alpine image and call this build stage "builder".

- WORKDIR => Change the current working directory.
- WORKDIR /app => If /app doesn't exist, Docker creates it automatically.

- COPY => Copy files from your computer into the Docker image.
- package*.json => The * is called a wildcard. So Docker copies both. ( package.json package-lock.json )
- /. => Current directory.

- RUN => Execute this command while building the image.
- npm ci => Uses package-lock.json exactly
- --only=production => Install only production dependencies.

- --from=builder => Copy something from the stage named (builder) instead of your laptop.
- /app/node_modules => Take this folder from Builder Image
- ./node_modules => Put it into Current directory /app/node_modules inside the runner image.
- Builder /app node_modules Copy Runner /app node_modules

- ENV => Create an environment variable.

- EXPOSE 8080 => My application listens on port 8080.
  - "My application listens on port 8080."
  - It does not publish the port to your laptop.
  - It is mainly documentation for Docker and for people reading the image.
  - To actually access it from outside, you still need:
  - docker run -p 8080:8080 image-name

- CMD => When someone runs docker run image-name Docker automatically executes npm start

- COPY . . ( <source> <destination>) => Copy files from my laptop into the Docker image.

# Project Commands

- docker build -t api . => crete docker image using current folder

- docker run -it --rm -p 8080:8080 api => run docker image
  - -i → Interactive mode
  - -t → Allocate a terminal (TTY)
  - --rm → Remove the container after it stops
  - api → Image name

- docker compose -f file-name up => run only one file
- docker ps => show running containers

## create docker-compose.api-gateway.yml file

# : What does this file do?

• Creates a Traefik container.
• Traefik acts as an API Gateway.
• Receives all incoming requests.
• Routes requests to the correct Docker container.
• Handles HTTP (80) and HTTPS (443).
• Automatically discovers Docker containers.
• Manages SSL certificates using Let's Encrypt.

- services => Which containers do you want Docker to create
- image => Which software should this container run?
- volumes => Share storage between host and container.

## create docker-compose.server.yml file

- build => Don't download an image from Docker Hub. Build the image yourself. (Read my Dockerfile Create Image)
- context: . => Current folder Use everything inside this folder.
- deploy: Run 5 copies of this service.

- ./Caddyfile:/etc/caddy/Caddyfile:ro

  • Copy the local Caddyfile into the container.
  • Store it at /etc/caddy/Caddyfile.
  • ro = Read Only.

# labels

Problem:
• Traefik can see running containers.
• But it doesn't know which request should go to which container.

Solution:
• Add labels to containers.
• Labels tell Traefik how to route requests.

Example:
User → Traefik → Reads Labels → Correct Container

## create CaddyFile

Traefik => Port 80 =>

:80
• Caddy listens on Port 80.

# Everything inside handle tells Caddy what to do.

reverse_proxy api-service:8000
• Forward requests to the Node.js service.
• api-service is the Docker service name.

header_up Host
• Pass the original Host header.

header_up X-Real-IP
• Pass the real client IP.

header_up X-Forwarded-For
• Pass the original client IP information.

header_up X-Forwarded-Proto
• Tell the backend whether the original request was HTTP or HTTPS.

## go to aws and do ssh

- sudo apt-get update => Download the latest package list from Ubuntu repositories.
- install docker
- clone project from docker
- point domain to machine ip
- sudo docker compose -f docker-compose.api-gateway.yml up -d => run traefik file
- sudo docker compose -f docker-compose.server.yml up -d => run caddey server
