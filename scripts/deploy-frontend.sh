#!/bin/bash

echo "🚀 Starting Frontend Services..."

# 1. Create necessary directories
mkdir -p nginx logs

# 2. Build images if needed
echo "📦 Building images..."
docker-compose -f docker-compose.frontend.yml build

# 3. Start services
echo "⚡ Starting containers..."
docker-compose -f docker-compose.frontend.yml up -d

# 4. Show status
echo "✅ Services started!"
echo ""
echo "🌐 Access URLs:"
echo "  - Parker Frontend: http://parker.localhost"
echo "  - Admin Frontend:  http://admin.localhost"
echo "  - Mock API:        http://localhost:3000/api/health"
echo ""
echo "📋 Check status: docker-compose -f docker-compose.frontend.yml ps"
echo "📝 View logs:    docker-compose -f docker-compose.frontend.yml logs -f"
