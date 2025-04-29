#!/bin/bash

# Script to configure npm for enterprise environments with SSL issues
echo "Configuring npm for enterprise environment..."

# Create .npmrc file with relaxed SSL settings
cat > .npmrc << EOF
strict-ssl=false
cafile=
insecure=true
EOF

echo ".npmrc file created successfully."

# Prompt for custom npm registry (if needed)
read -p "Do you need to set a custom npm registry? (y/n): " set_registry
if [[ "$set_registry" == "y" ]]; then
  read -p "Enter your enterprise npm registry URL: " registry_url
  echo "registry=$registry_url" >> .npmrc
  echo "Custom registry added to .npmrc"
fi

echo ""
echo "Enterprise setup completed. Now run the following commands to restart the container:"
echo "docker compose down"
echo "docker compose up -d"
echo ""

chmod +x enterprise-setup.sh 