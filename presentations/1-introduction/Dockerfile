FROM pandoc/core:latest AS builder

# Set working directory
WORKDIR /app

# Copy the presentation files
COPY introduction.md /app/
COPY README.md /app/

# Convert the markdown to reveal.js presentation
RUN pandoc -t revealjs -s -o /app/index.html /app/introduction.md \
    -V revealjs-url=/reveal.js \
    -V theme=moon \
    -V transition=slide

# Use node22-alpine for the web server
FROM node:22-alpine

# Install serve
RUN npm install -g serve reveal.js

# Set working directory
WORKDIR /app

# Copy the generated HTML file and node_modules from the builder stage
RUN ln -s "$(npm root -g)/reveal.js" /app/reveal.js
COPY --from=builder /app/index.html /app/

# Expose port 3000
EXPOSE 3000

# Start serve
CMD ["serve", "-s", ".", "-l", "3000"]
