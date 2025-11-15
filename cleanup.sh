#!/bin/bash
# 清理脚本 - 删除不应该发布的文件

echo "🧹 清理项目文件..."
echo "=================================="
echo ""

# 删除包含 API 密钥的脚本
echo "🔒 删除包含 API 密钥的文件..."
rm -f run_inspector.sh start_inspector.sh
echo "   ✅ 已删除: run_inspector.sh, start_inspector.sh"

# 删除Python缓存
echo "🗑️  删除 Python 缓存文件..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type f -name "*.pyo" -delete 2>/dev/null || true
echo "   ✅ Python 缓存已清理"

# 删除egg-info
echo "📦 删除构建文件..."
rm -rf *.egg-info build/ dist/
echo "   ✅ 构建文件已清理"

# 删除临时文件
echo "🗑️  删除临时文件..."
rm -f *.tmp *.log
echo "   ✅ 临时文件已清理"

echo ""
echo "=================================="
echo "✅ 清理完成！"
echo ""
echo "📋 剩余文件检查:"
echo "   核心代码:"
ls musicmcp_ai_mcp/*.py 2>/dev/null | sed 's/^/   - /'
echo ""
echo "   测试文件:"
ls tests/*.py 2>/dev/null | sed 's/^/   - /'
echo ""
echo "   配置文件:"
ls *.toml *.txt *.md LICENSE 2>/dev/null | sed 's/^/   - /'
echo ""
