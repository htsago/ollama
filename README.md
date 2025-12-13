# Ollama Self-Hosted Setup

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/htsago/ollama
   cd ollama
   ```

2. **Start with Docker Compose**
   ```bash
   docker-compose up -d
   ```

   The Ollama server will be available at `http://localhost:11434` (locally) or `http://<YOUR-SERVER-IP>:11434` (on a VPS).

---

## For VPS with Domain & HTTPS

To run Ollama on a VPS with a custom domain (e.g., `https://ollama.herman-tsago.tech`), set up an NGINX reverse proxy with SSL:

### 1. Install NGINX
```bash
sudo apt update && sudo apt install nginx
```

### 2. Create NGINX configuration  
Save the following config to `/etc/nginx/sites-available/ollama`:

```nginx
server {
    listen 443 ssl http2;
    server_name ollama.herman-tsago.tech;
    
    ssl_certificate /etc/letsencrypt/live/ollama.herman-tsago.tech/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ollama.herman-tsago.tech/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    client_max_body_size 50M;
    
    location /v1/ {
        rewrite ^/v1/(.*) /$1 break;
        proxy_pass http://localhost:11434;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        proxy_connect_timeout 600s;
    }
}

server {
    listen 80;
    server_name ollama.herman-tsago.tech;
    return 301 https://$server_name$request_uri;
}
```

### 3. Obtain SSL certificate with Let’s Encrypt
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d ollama.herman-tsago.tech
```

### 4. Enable and reload NGINX
```bash
sudo ln -s /etc/nginx/sites-available/ollama /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

The API will then be accessible at `https://ollama.herman-tsago.tech/v1/` — fully OpenAI-compatible and ready for integration.

