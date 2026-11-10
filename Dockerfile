# Stage 1: Build the Vite React application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency manifests first for better layer caching
COPY package*.json ./
RUN npm ci

# Copy the application source and create the production build
COPY . .
RUN npm run build

# Stage 2: Serve the static build with Nginx
FROM nginx:alpine

# Copy only the generated static files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Configure Nginx to support React Router routes
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
