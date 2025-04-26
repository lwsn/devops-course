FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:20-alpine AS runner

# ENV NODE_ENV production

WORKDIR /app

COPY package*.json .
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

ENV PORT 3000

CMD ["node", "dist/server.js"]
