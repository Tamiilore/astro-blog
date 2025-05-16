# Stage 1: Build the Astro site
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the full project
COPY . .

# Build the site
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:1.28.0-alpine3.21-slim

# Clean out default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built static site to nginx root
COPY --from=builder /app/dist /usr/share/nginx/html

# Optionally add a custom nginx config
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 and start nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
