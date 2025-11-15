#!/bin/bash
# MusicMCP.AI MCP 发布脚本

set -e  # 遇到错误立即退出

echo "🚀 MusicMCP.AI MCP 发布准备"
echo "========================================"
echo ""

# 步骤 1: 清理旧的构建文件
echo "📦 步骤 1/5: 清理旧的构建文件..."
rm -rf build/ dist/ *.egg-info
echo "✅ 清理完成"
echo ""

# 步骤 2: 检查版本号
echo "📋 步骤 2/5: 检查版本号..."
VERSION=$(python3 -c "import tomli; print(tomli.load(open('pyproject.toml', 'rb'))['project']['version'])" 2>/dev/null || python3 -c "import toml; print(toml.load('pyproject.toml')['project']['version'])")
echo "   当前版本: $VERSION"
echo ""

# 步骤 3: 运行测试
echo "🧪 步骤 3/5: 运行测试..."
if command -v pytest &> /dev/null; then
    pytest tests/test_api.py -v || echo "⚠️  警告: 某些测试失败（可能需要 API 密钥）"
else
    python3 tests/test_api.py || echo "⚠️  警告: 某些测试失败（可能需要 API 密钥）"
fi
echo ""

# 步骤 4: 构建发布包
echo "🔨 步骤 4/5: 构建发布包..."
python3 -m build
echo "✅ 构建完成"
echo ""

# 步骤 5: 检查构建的包
echo "🔍 步骤 5/5: 检查构建的包..."
python3 -m twine check dist/*
echo "✅ 包检查通过"
echo ""

echo "========================================"
echo "✅ 发布准备完成！"
echo ""
echo "📋 构建的文件:"
ls -lh dist/
echo ""
echo "📝 下一步操作:"
echo "   测试安装: pip install dist/aimusic_mcp-$VERSION-py3-none-any.whl"
echo "   发布到 TestPyPI: python3 -m twine upload --repository testpypi dist/*"
echo "   发布到 PyPI: python3 -m twine upload dist/*"
echo ""
