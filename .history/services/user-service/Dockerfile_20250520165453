# Dockerfile for User Service
FROM node:18
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Configure npm to handle network timeouts
RUN npm config set fetch-retries 5
RUN npm config set fetch-timeout 60000

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
