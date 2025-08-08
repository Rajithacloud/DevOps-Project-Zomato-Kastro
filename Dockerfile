# Use Node.js 16 slim as the base image
FROM node:16-slim

# Install OS packages needed for compiling npm modules (if any)
RUN apt-get update && apt-get install -y python3 make g++ \
 && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Set npm cache location (so it reuses cache in Docker layers)
RUN npm config set cache /root/.npm-cache --global

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start your Node.js server (assuming it serves the React app)  
CMD ["npm", "start"]
