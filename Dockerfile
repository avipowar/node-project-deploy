FROM node:22-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production


FROM node:22-alpine AS runner

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
ENV NODE_ENV=production
EXPOSE 8080

CMD ["npm", "start"]