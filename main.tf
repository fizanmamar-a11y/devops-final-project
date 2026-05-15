terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "app_image" {
  name = "my-devops-app:latest"
  build {
    context = "."
  }
}

resource "docker_container" "app_container" {
  image = docker_image.app_image.image_id
  name  = "devops_final_prod"
  ports {
    internal = 5000
    external = 8080
  }
}

/*
COMMANDS TO FIX YOUR ERRORS (Copy-paste these into your VS Code terminal):

1. FIX THE DIRECTORY ERROR:
   New-Item -ItemType Directory -Path "app", "docker", "terraform", "scripts" -Force

2. CONFIGURE YOUR GIT IDENTITY (Required for the 'Author identity unknown' error):
   git config --local user.email "your@email.com"
   git config --local user.name "Your Name"

3. RE-RUN THE FILE CREATION (Now that directories exist):
   @"
   from flask import Flask, jsonify
   app = Flask(__name__)
   @app.route('/')
   def home(): return jsonify({"message": "DevOps Pipeline Demo", "status": "running"})
   @app.route('/health')
   def health(): return jsonify({"health": "OK"}), 200
   if __name__ == '__main__': app.run(host='0.0.0.0', port=5000)
   "@ | Set-Content app\app.py

   "Flask==2.3.0`nWerkzeug==2.3.0" | Set-Content app\requirements.txt

   @"
   FROM python:3.11-slim
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   COPY . .
   EXPOSE 5000
   CMD ["python", "app.py"]
   "@ | Set-Content docker\Dockerfile

4. MAKE THE COMMIT:
   git add .
   git commit -m "Initial project setup with Flask app and Docker configuration"

5. DEPLOY WITH TERRAFORM:
   terraform init
   terraform apply -auto-approve
*/