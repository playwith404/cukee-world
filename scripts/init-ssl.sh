#!/bin/bash
# SSL Certificate Initialization Script for playwith404.world
# Run this script on your production server to generate the initial SSL certificate

set -e

DOMAIN="playwith404.world"
EMAIL="${CERTBOT_EMAIL:-admin@playwith404.world}"
STAGING="${STAGING:-0}"  # Set to 1 for testing

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SSL Certificate Setup for ${DOMAIN}${NC}"
echo -e "${GREEN}========================================${NC}"

# Create required directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p certbot/conf
mkdir -p certbot/www

# Check if certificate already exists
if [ -d "certbot/conf/live/${DOMAIN}" ]; then
    echo -e "${YELLOW}Existing certificate found. Checking validity...${NC}"
    if docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" certbot/certbot certificates | grep -q "VALID"; then
        echo -e "${GREEN}Certificate is still valid. Skipping generation.${NC}"
        echo -e "${YELLOW}If you want to force regeneration, delete certbot/conf/live/${DOMAIN} and run again.${NC}"
        exit 0
    fi
fi

# Download recommended TLS parameters
echo -e "${YELLOW}Downloading recommended TLS parameters...${NC}"
if [ ! -f "certbot/conf/options-ssl-nginx.conf" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > certbot/conf/options-ssl-nginx.conf
fi

if [ ! -f "certbot/conf/ssl-dhparams.pem" ]; then
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > certbot/conf/ssl-dhparams.pem
fi

# Create dummy certificate for nginx to start
echo -e "${YELLOW}Creating dummy certificate for initial nginx startup...${NC}"
mkdir -p "certbot/conf/live/${DOMAIN}"
docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    --entrypoint openssl \
    certbot/certbot \
    req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" \
    -out "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" \
    -subj "/CN=localhost"

# Create chain.pem (copy of fullchain for OCSP)
cp "certbot/conf/live/${DOMAIN}/fullchain.pem" "certbot/conf/live/${DOMAIN}/chain.pem"

# Start nginx with dummy certificate
echo -e "${YELLOW}Starting nginx with dummy certificate...${NC}"
docker compose -f docker-compose.ssl.yml up -d nginx

# Wait for nginx to be ready
echo -e "${YELLOW}Waiting for nginx to start...${NC}"
sleep 5

# Delete dummy certificate
echo -e "${YELLOW}Removing dummy certificate...${NC}"
rm -rf "certbot/conf/live/${DOMAIN}"

# Request real certificate
echo -e "${GREEN}Requesting Let's Encrypt certificate...${NC}"

STAGING_ARG=""
if [ "$STAGING" = "1" ]; then
    echo -e "${YELLOW}Using staging environment (for testing)${NC}"
    STAGING_ARG="--staging"
fi

docker run --rm \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly --webroot \
    -w /var/www/certbot \
    -d ${DOMAIN} \
    -d www.${DOMAIN} \
    --email ${EMAIL} \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    ${STAGING_ARG}

# Create chain.pem for OCSP stapling
cp "certbot/conf/live/${DOMAIN}/fullchain.pem" "certbot/conf/live/${DOMAIN}/chain.pem" 2>/dev/null || true

# Reload nginx with real certificate
echo -e "${YELLOW}Reloading nginx with real certificate...${NC}"
docker compose -f docker-compose.ssl.yml exec nginx nginx -s reload

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SSL Certificate Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Your site is now available at:"
echo -e "  ${GREEN}https://${DOMAIN}${NC}"
echo -e "  ${GREEN}https://www.${DOMAIN}${NC}"
echo ""
echo -e "${YELLOW}Note: Certificate will auto-renew via certbot container${NC}"
