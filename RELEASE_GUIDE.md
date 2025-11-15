# 🚀 MusicMCP.AI MCP 发布指南

## 发布前检查清单

### ✅ 安全检查（非常重要！）

- [ ] **检查没有 API 密钥泄露**
  ```bash
  # 搜索可能的 API 密钥
  grep -r "iOoek" . 2>/dev/null || echo "✅ 未发现密钥"
  grep -r "MUSICMCP_API_KEY.*=" . --include="*.sh" --include="*.py" 2>/dev/null || echo "✅ 未发现密钥"
  ```

- [ ] **确认 .gitignore 已生效**
  ```bash
  git status
  # 确保 run_inspector.sh, start_inspector.sh 等文件不在待提交列表中
  ```

- [ ] **检查敏感文件**
  ```bash
  ls -la *.sh
  # 确保只有 install.sh, release.sh, inspector.sh.example 等安全文件
  ```

### 📋 代码质量检查

- [ ] **所有测试通过**
  ```bash
  python tests/test_api.py
  ```

- [ ] **文档完整**
  - README.md 包含所有必要信息
  - 参数说明与最新 API 匹配
  - 示例代码可运行

- [ ] **版本号正确**
  - pyproject.toml 中的版本号已更新
  - 遵循语义化版本 (semver)

### 🛠️ 依赖检查

- [ ] **pyproject.toml 依赖正确**
  ```toml
  dependencies = [
      "mcp[cli]>=1.6.0",
      "httpx>=0.24.0",
  ]
  ```

- [ ] **requirements.txt 与 pyproject.toml 一致**

---

## 发布步骤

### 步骤 1: 准备发布环境

```bash
# 安装发布工具
pip install build twine

# 确保在正确的目录
cd /Users/wucharlie/Desktop/00-Personal/Products/aimusic-mcp/aimusic-mcp-tool
```

### 步骤 2: 运行发布脚本

```bash
chmod +x release.sh
./release.sh
```

这个脚本会自动：
1. 清理旧的构建文件
2. 检查版本号
3. 运行测试
4. 构建发布包
5. 检查包的完整性

### 步骤 3: 本地测试安装

```bash
# 在虚拟环境中测试
python3 -m venv test_env
source test_env/bin/activate

# 安装构建的包
pip install dist/aimusic_mcp-*.whl

# 测试导入
python -c "from musicmcp_ai_mcp.api import mcp; print('✅ 导入成功')"

# 清理
deactivate
rm -rf test_env
```

### 步骤 4: 发布到 TestPyPI（可选但推荐）

```bash
# 首先在 TestPyPI 注册账号: https://test.pypi.org/

# 配置 TestPyPI 凭证
python3 -m twine upload --repository testpypi dist/*

# 从 TestPyPI 测试安装
pip install --index-url https://test.pypi.org/simple/ aimusic-mcp
```

### 步骤 5: 发布到正式 PyPI

```bash
# 在 PyPI 注册账号: https://pypi.org/

# 上传到 PyPI
python3 -m twine upload dist/*

# 等待几分钟后测试安装
pip install aimusic-mcp
```

### 步骤 6: 验证发布成功

```bash
# 检查 PyPI 页面
open https://pypi.org/project/aimusic-mcp/

# 测试 uvx 安装
uvx aimusic-mcp --help
```

### 步骤 7: 提交代码到 GitHub

```bash
# 添加文件
git add .

# 提交（确保没有 API 密钥！）
git commit -m "chore: release v2.0.0 - 更新 API 参数，移除 model_type 和 duration"

# 推送到远程
git push origin main

# 创建 GitHub Release
gh release create v2.0.0 --title "v2.0.0" --notes "更新说明..."
```

---

## 🐛 常见问题

### 问题 1: twine 上传失败 - 401 Unauthorized

**解决方案**：
```bash
# 配置 PyPI token
python3 -m twine upload dist/* --username __token__ --password pypi-YOUR-TOKEN-HERE
```

### 问题 2: 包已存在错误

**解决方案**：
- 检查 PyPI 上的版本号
- 更新 pyproject.toml 中的版本号
- 重新构建

### 问题 3: 构建失败 - 缺少依赖

**解决方案**：
```bash
pip install build twine setuptools wheel
```

---

## 📝 发布后检查

- [ ] PyPI 页面正确显示: https://pypi.org/project/aimusic-mcp/
- [ ] README 在 PyPI 正确渲染
- [ ] `pip install aimusic-mcp` 可正常安装
- [ ] `uvx aimusic-mcp` 可正常运行
- [ ] GitHub Release 已创建
- [ ] 文档更新

---

## 🔒 安全提醒

**永远不要提交包含以下内容的文件：**
- 真实的 API 密钥
- 密码或 token
- 个人凭证
- 开发环境特定的配置

**发布前最后检查：**
```bash
# 检查待提交的文件
git status

# 检查文件内容（寻找 API 密钥）
git diff

# 如果发现敏感信息，立即取消提交并清理
```

---

**发布者**: Claude Code
**最后更新**: 2025-11-15
