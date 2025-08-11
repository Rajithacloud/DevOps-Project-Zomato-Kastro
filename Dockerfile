# Use Node.js 16 slim as the base image
FROM node:16-slim

# # Install OS packages needed for compiling npm modules (alphabetically sorted)
# RUN apt-get update && apt-get install -y --no-install-recommends g++ make python3 \
#     && rm -rf /var/lib/apt/lists/*

# Enable BuildKit cache mounts for apt
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends \
       g++ \
       make \
       python3 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Set npm cache location and install dependencies in the same layer for efficiency
RUN npm config set cache /root/.npm-cache --global \
    && npm ci --only=production  --ignore-scripts

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start your Node.js server (assuming it serves the React app)  
CMD ["npm", "start"]
