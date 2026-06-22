#!/bin/bash
# Quick Setup Script for LGTM Stack
# Usage: bash setup.sh

set -e

echo "🚀 Setting up LGTM Stack locally..."

# 1. Create directories
echo "📁 Creating directories..."
mkdir -p ~/observability/{prometheus,grafana/provisioning/datasources,loki,tempo,data}

# 2. Copy config files
echo "📋 Copying configuration files..."
cp prometheus.yml ~/observability/prometheus/prometheus.yml
cp lgtm.yaml ~/observability/grafana/provisioning/datasources/lgtm.yaml

# 3. Start the stack
echo "🐳 Starting Docker containers..."
cd ~/observability
docker compose up -d

# 4. Wait for containers to start
echo "⏳ Waiting for containers to start..."
sleep 5

# 5. Show status
echo ""
echo "✅ LGTM Stack is running!"
echo ""
echo "📊 Access the dashboards:"
echo "   • Prometheus:  http://localhost:9090"
echo "   • Grafana:    http://localhost:3000 (admin/admin123)"
echo "   • Node Exp:   http://localhost:9100"
echo ""
echo "📝 Next steps:"
echo "   1. Open http://localhost:3000"
echo "   2. Login with admin/admin123"
echo "   3. Import dashboard ID: 1860"
echo ""
echo "🐛 Useful commands:"
echo "   • View logs: docker compose logs -f"
echo "   • Stop:      docker compose down"
echo "   • Restart:   docker compose restart"
