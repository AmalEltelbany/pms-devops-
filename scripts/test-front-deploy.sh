#!/bin/bash
set -e

echo "🚀 Testing Docker Swarm Frontend Setup..."

# 1. Check if in Swarm mode
if ! docker node ls &> /dev/null; then
    echo "Initializing Swarm..."
    docker swarm init --advertise-addr 127.0.0.1
fi

# 2. Create test network if doesn't exist
docker network create -d overlay --attachable frontend-net 2>/dev/null || true

# 3. Deploy stack
echo "Deploying stack..."
docker stack deploy -c docker-stack-frontend.yml pms-test

# 4. Wait for services
echo "Waiting for services to start..."
sleep 10

# 5. Show status
echo "✅ Deployment Status:"
docker stack services pms-test

echo ""
echo "🌐 TESTING URLs:"
echo "  - Direct Nginx test: http://localhost"
echo "  - Admin via path:    http://localhost/admin/"
echo "  - Parker via path:   http://localhost/parker/"
echo ""
echo "📝 To test with domains (requires /etc/hosts edit):"
echo "  - Add to /etc/hosts: 127.0.0.1 admin.local parker.local"
echo "  - Then access: http://admin.local and http://parker.local"
