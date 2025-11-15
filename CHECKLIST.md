# ✅ 发布前手动检查清单

**请在发布前逐项检查以下内容：**

---

## 🔒 安全检查（最重要！）

### 1. 检查是否有 API 密钥泄露

运行以下命令：
```bash
cd /Users/wucharlie/Desktop/00-Personal/Products/aimusic-mcp/aimusic-mcp-tool

# 运行清理脚本
chmod +x cleanup.sh
./cleanup.sh
```

### 2. 手动确认敏感文件已删除

```bash
# 这些文件不应该存在：
ls run_inspector.sh 2>/dev/null && echo "❌ 警告: run_inspector.sh 仍然存在！" || echo "✅ run_inspector.sh 已删除"
ls start_inspector.sh 2>/dev/null && echo "❌ 警告: start_inspector.sh 仍然存在！" || echo "✅ start_inspector.sh 已删除"
```

**如果发现这些文件，立即删除：**
```bash
rm -f run_inspector.sh start_inspector.sh
```

### 3. 确认 .gitignore 包含敏感文件

```bash
cat .gitignore | grep "run_inspector.sh" && echo "✅" || echo "❌ 需要添加"
cat .gitignore | grep "start_inspector.sh" && echo "✅" || echo "❌ 需要添加"
```

---

## 📋 文件完整性检查

### 4. 核心文件存在

- [ ] `musicmcp_ai_mcp/api.py` - 核心实现
- [ ] `musicmcp_ai_mcp/__init__.py` - 包初始化
- [ ] `musicmcp_ai_mcp/__main__.py` - 入口点
- [ ] `pyproject.toml` - 项目配置
- [ ] `README.md` - 文档
- [ ] `LICENSE` - 许可证
- [ ] `.gitignore` - Git 忽略配置

### 5. 测试文件存在

- [ ] `tests/test_api.py` - API 测试
- [ ] `tests/test_query.py` - 查询测试

### 6. 示例和配置文件

- [ ] `inspector.sh.example` - 示例配置（不含真实密钥）

---

## 🧪 功能测试

### 7. 运行基础测试

```bash
python tests/test_api.py
```

预期输出：
```
🧪 Running MusicMCP.AI MCP Server Tests
==================================================
✅ All 5 MCP tools are available
```

### 8. 检查导入

```bash
python3 -c "from musicmcp_ai_mcp.api import mcp; print('✅ 导入成功')"
```

---

## 📝 文档检查

### 9. README.md 完整性

- [ ] 包含安装说明
- [ ] 包含配置说明
- [ ] 包含使用示例
- [ ] 参数说明与最新代码一致
- [ ] 没有错误的链接

### 10. 版本号检查

```bash
# 检查 pyproject.toml 中的版本号
grep version pyproject.toml
```

当前应该是 `2.0.0` 或更高版本。

---

## 🔨 构建测试

### 11. 清理并重新构建

```bash
# 清理旧文件
rm -rf build/ dist/ *.egg-info

# 构建
python3 -m build
```

### 12. 检查构建产物

```bash
ls -lh dist/

# 应该看到两个文件：
# - aimusic_mcp-2.0.0-py3-none-any.whl
# - aimusic_mcp-2.0.0.tar.gz
```

### 13. 验证包内容

```bash
# 检查 wheel 文件内容
unzip -l dist/aimusic_mcp-*.whl

# 确认没有包含敏感文件
unzip -l dist/aimusic_mcp-*.whl | grep -E "(run_inspector|start_inspector)" && echo "❌ 包含敏感文件！" || echo "✅ 未发现敏感文件"
```

---

## 🚀 发布准备

### 14. Git 状态检查

```bash
git status

# 确保没有包含：
# - run_inspector.sh
# - start_inspector.sh
# - __pycache__/
# - *.egg-info/
```

### 15. 最后的安全确认

```bash
# 搜索可能的 API 密钥
echo "🔍 搜索可能的 API 密钥..."
grep -r "iOoek" --exclude-dir=.git --exclude-dir=dist --exclude-dir=build . && echo "❌ 发现 API 密钥！请立即删除相关文件！" || echo "✅ 未发现 API 密钥"
```

---

## ✅ 全部检查完成！

如果所有检查都通过，你可以：

1. **提交代码到 GitHub：**
   ```bash
   git add .
   git commit -m "chore: release v2.0.0"
   git push origin main
   ```

2. **发布到 PyPI：**
   ```bash
   chmod +x release.sh
   ./release.sh

   # 然后
   python3 -m twine upload dist/*
   ```

3. **创建 GitHub Release：**
   访问 https://github.com/puyue-ai/musicmcp-ai-mcp/releases/new

---

**⚠️ 重要提醒：**
- 如果任何检查失败，请不要继续发布！
- 发现 API 密钥立即删除相关文件！
- 有疑问时先咨询，不要冒险发布！
