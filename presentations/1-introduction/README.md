# Introduction Presentation

This directory contains the introduction presentation for the Kubernetes, DevOps, and AWS course.

## Presentation Content

The presentation covers:
- Course overview
- Instructor introduction
- Required tools
- Course assignments
- CKAD certification
- Infrastructure as Code
- Kubernetes core concepts
- Additional Kubernetes resources
- Pod identity, AWS IAM, and EKS

## Running the Presentation

### Using Docker

A Dockerfile is provided to convert the markdown presentation to reveal.js and serve it using a web server.

#### Building the Docker Image

```bash
docker build -t k8s-intro-presentation .
```

#### Running the Container

```bash
docker run -p 3000:3000 k8s-intro-presentation
```

After running the container, you can access the presentation at [http://localhost:3000/introduction.html](http://localhost:3000/introduction.html).

### Manual Conversion

If you prefer to convert the presentation manually, you can use pandoc:

```bash
pandoc -t revealjs -s -o introduction.html introduction.md -V revealjs-url=https://revealjs.com
```

Then serve the HTML file using any web server.

## Customizing the Presentation

You can modify the `introduction.md` file to customize the presentation content. The Dockerfile will automatically convert the updated markdown to HTML when you rebuild the Docker image. 
