#!/bin/bash

clear
echo "==================================="
echo "  Ollama Service Monitoring"
echo "==================================="
echo ""

echo "Container Status:"
docker ps --filter name=ollama --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "Resource Usage:"
docker stats ollama-central-service --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
echo ""

echo "Disk Usage:"
docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}"
echo ""

echo "Loaded Models:"
docker exec ollama-central-service ollama list 2>/dev/null || echo "Ollama not ready"
echo ""

echo "System Memory:"
free -h
echo ""

echo "Disk Space:"
df -h | grep -E '^/dev|Filesystem'

