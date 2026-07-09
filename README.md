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

---------------------

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
- ./node_modules =>  Put it into Current directory /app/node_modules inside the runner image.
- Builder /app node_modules Copy Runner /app node_modules

- ENV => Create an environment variable.

- EXPOSE 8080 => My application listens on port 8080.

    - "My application listens on port 8080."
    - It does not publish the port to your laptop.
    - It is mainly documentation for Docker and for people reading the image.
    - To actually access it from outside, you still need:
    - docker run -p 8080:8080 image-name

- CMD => When someone runs docker run image-name Docker automatically executes npm start