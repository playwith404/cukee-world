#!/bin/bash
# GCE Server Initial Setup Script
# Run this ONCE on your GCE instance before the first deployment

set -e

DEPLOY_PATH="/opt/cukee-world"
DOMAIN="playwith404.world"
EMAIL="${CERTBOT_EMAIL:-admin@playwith404.world}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  GCE Server Setup for ${DOMAIN}${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo)${NC}"
    exit 1
fi

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh

    # Add current user to docker group
    usermod -aG docker $SUDO_USER
fi

# Install Docker Compose plugin if not present
if ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose plugin...${NC}"
    apt-get update
    apt-get install -y docker-compose-plugin
fi

# Create deployment directory
echo -e "${YELLOW}Creating deployment directory...${NC}"
mkdir -p ${DEPLOY_PATH}
mkdir -p ${DEPLOY_PATH}/nginx
mkdir -p ${DEPLOY_PATH}/certbot/conf
mkdir -p ${DEPLOY_PATH}/certbot/www

# Set ownership
chown -R $SUDO_USER:$SUDO_USER ${DEPLOY_PATH}

# Open firewall ports (for GCE, also need to configure in Cloud Console)
echo -e "${YELLOW}Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 80/tcp
    ufw allow 443/tcp
    echo -e "${GREEN}UFW rules added for ports 80 and 443${NC}"
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Server Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Ensure GCP Firewall allows ports 80 and 443"
echo "2. Point DNS for ${DOMAIN} to this server's IP"
echo "3. Push to main branch to trigger first deployment"
echo "4. After first deployment, run SSL initialization:"
echo ""
echo -e "   ${GREEN}cd ${DEPLOY_PATH}${NC}"
echo -e "   ${GREEN}CERTBOT_EMAIL=your@email.com ./scripts/init-ssl.sh${NC}"
echo ""
echo -e "${YELLOW}Note: SSL certificates will auto-renew after initial setup${NC}"
