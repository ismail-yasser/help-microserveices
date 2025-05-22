# Use an official Node runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the public and src directories
COPY public/ ./public/
COPY src/ ./src/

# List files for debugging
RUN echo "Listing /app contents:"
RUN ls -R /app
RUN echo "Listing /app/public contents:"
RUN ls -R /app/public || echo "/app/public not found or empty"

# Build the React app
RUN npm run build

# Serve the built app using a lightweight HTTP server (e.g., serve)
# First, install serve globally
RUN npm install -g serve

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["serve", "-s", "build", "-l", "3000"]
