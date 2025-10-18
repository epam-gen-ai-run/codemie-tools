# Contributing to CodeMie Tools

Thank you for your interest in contributing to CodeMie Tools! We're excited to have you join our community. This guide will help you get started with contributing to this open-source project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Toolkit Development](#toolkit-development)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [Community & Support](#community-support)

---

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

---

## Ways to Contribute

There are many ways to contribute to CodeMie Tools:

- **Report bugs** - Submit detailed bug reports via [GitHub Issues](https://github.com/epam-gen-ai-run/codemie-tools/issues)
- **Suggest features** - Share ideas for new features or improvements
- **Write code** - Implement new toolkits, tools, or fix bugs
- **Improve documentation** - Enhance guides, add examples, fix typos
- **Review pull requests** - Help review and test community contributions
- **Share knowledge** - Answer questions in discussions or issues
- **Write tutorials** - Create blog posts, videos, or examples

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Python 3.12 or 3.13** ([Download](https://www.python.org/downloads/))
- **Poetry 1.0.0+** ([Installation Guide](https://python-poetry.org/docs/#installation))
- **Git** ([Download](https://git-scm.com/downloads))
- **Make** (usually pre-installed on Unix systems)

### First-Time Setup

1. **Fork the repository**

   Click the "Fork" button at the top right of the [repository page](https://github.com/epam-gen-ai-run/codemie-tools).

2. **Clone your fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/codemie-tools.git
   cd codemie-tools
   ```

3. **Add upstream remote**

   ```bash
   git remote add upstream https://github.com/epam-gen-ai-run/codemie-tools.git
   ```

4. **Install dependencies**

   ```bash
   make install
   ```

5. **Activate virtual environment**

   **CRITICAL**: Always activate the virtual environment before running commands:

   ```bash
   source venv/bin/activate
   ```

   Or prefix commands with:

   ```bash
   source venv/bin/activate && make test
   ```

6. **Verify installation**

   ```bash
   source venv/bin/activate && make verify
   ```

### First-Time Contributor Checklist

- [ ] Forked and cloned the repository
- [ ] Installed dependencies with `make install`
- [ ] Read the [DEV_GUIDE.md](DEV_GUIDE.md) for technical details
- [ ] Reviewed reference implementations (ITSM, Project Management toolkits)
- [ ] Joined the community (GitHub Discussions)
- [ ] Virtual environment activation reminder set up

---

## Development Workflow

### Branch Naming Convention

We follow GitHub best practices for branch naming:

```bash
# Feature branches
feature/add-gitlab-toolkit
feature/xlsx-filtering

# Bug fixes
fix/confluence-auth-error
fix/pdf-extraction-encoding

# Documentation
docs/contributing-guide
docs/api-reference

# Refactoring
refactor/simplify-base-client

# Performance
perf/optimize-xlsx-parsing

# Maintenance
chore/update-dependencies
```

**Pattern**: `type/brief-description-in-kebab-case`

**Types**: `feature`, `fix`, `docs`, `refactor`, `perf`, `test`, `chore`, `ci`

### Commit Message Convention

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear and meaningful commit history:

```bash
# Format
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]

# Examples
feat(jira): add support for custom fields in issue creation
fix(xlsx): resolve encoding issue with non-ASCII characters
docs(contributing): add GitHub workflow guidelines
refactor(base): simplify client error handling
test(confluence): add integration tests for page operations
chore(deps): update langchain to 0.3.25
perf(pdf): optimize text extraction for large files

# Breaking changes
feat(api)!: change tool configuration schema

BREAKING CHANGE: Configuration now requires 'timeout' parameter
```

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Code style/formatting
- `refactor` - Code refactoring
- `perf` - Performance improvement
- `test` - Adding/updating tests
- `build` - Build system changes
- `ci` - CI/CD changes
- `chore` - Maintenance tasks
- `revert` - Revert previous commit

**Optional scopes**: `jira`, `confluence`, `gitlab`, `xlsx`, `pdf`, `base`, `api`, etc.

### Git Workflow

```bash
# 1. Update your fork
git checkout main
git fetch upstream
git merge upstream/main

# 2. Create a feature branch
git checkout -b feature/your-feature-name

# 3. Make your changes
# ... edit files ...

# 4. Run linting and tests
source venv/bin/activate && make ruff-fix
source venv/bin/activate && make test

# 5. Commit your changes
git add .
git commit -m "feat(scope): add your feature"

# 6. Keep branch updated (if needed)
git fetch upstream
git rebase upstream/main

# 7. Push to your fork
git push origin feature/your-feature-name

# 8. Create a Pull Request
# Go to GitHub and click "Compare & pull request"
```

---

## Code Standards

### Core Principles

CodeMie Tools follows **KISS (Keep It Simple, Stupid)** and **DRY (Don't Repeat Yourself)** principles:

- Write clean, efficient, and well-documented code
- Keep implementations simple and straightforward
- Avoid code duplication - use utilities
- Maintain low cognitive complexity
- Consider edge cases and error handling

### Python Style Guide

We use **Ruff** for linting and formatting:

- **Line length**: 100 characters maximum
- **Quotes**: Double quotes for strings
- **Indentation**: 4 spaces (no tabs)
- **Docstrings**: Required for all public classes and methods
- **Type hints**: Use where appropriate for clarity

### File Naming Conventions

```python
# Packages (directories)
project_management/
access_management/

# Modules (files)
tools.py
toolkit.py
models.py
tools_vars.py
jira_client.py

# Classes
class GenericJiraIssueTool(CodeMieTool):
class ProjectManagementToolkit(DiscoverableToolkit):

# Functions/methods
def get_toolkit():
def execute():

# Constants
GENERIC_JIRA_TOOL = ToolMetadata(...)

# Tests
test_jira_tool.py
```

### Import Organization

Organize imports in three groups:

```python
# 1. Standard library imports
import os
from typing import List, Dict, Optional

# 2. Third-party imports
from pydantic import Field, BaseModel
from langchain_core.tools import BaseTool, ToolException

# 3. Local imports
from codemie_tools.base.codemie_tool import CodeMieTool
from codemie_tools.base.models import ToolMetadata
from codemie_tools.base.utils import validate_url
```

### Error Handling

Always use `ToolException` for tool-related errors:

```python
from langchain_core.tools import ToolException

def execute(self, **kwargs):
    """Execute with proper error handling."""

    # Validate inputs
    if not kwargs.get("required_field"):
        raise ToolException("required_field is mandatory")

    try:
        result = self._perform_operation(**kwargs)

        if not result:
            raise ToolException("Operation returned empty result")

        return result

    except ToolException:
        # Re-raise ToolExceptions
        raise
    except ValueError as e:
        # Handle specific exceptions
        raise ToolException(f"Invalid value: {str(e)}")
    except Exception as e:
        # Catch-all for unexpected errors
        raise ToolException(f"Unexpected error: {str(e)}")
```

### Code Quality Checklist

Before submitting code, ensure:

- [ ] Virtual environment is activated
- [ ] Code follows style guide (100 char line length, double quotes)
- [ ] All imports are organized properly
- [ ] Docstrings added for public classes/methods
- [ ] Error handling uses `ToolException`
- [ ] No duplicate code (check `base/utils.py` for utilities)
- [ ] Low complexity (avoid deeply nested logic)
- [ ] Linting passes: `make ruff-fix`
- [ ] Tests pass (if applicable): `make test`

---

## Toolkit Development

### When to Create a New Toolkit

Create a new toolkit when:
- Integrating with a new external service/API
- Adding a new category of functionality
- Grouping multiple related tools together

### Directory Structure

```
src/codemie_tools/
└── your_toolkit/
    ├── __init__.py
    ├── toolkit.py              # Toolkit registration
    ├── tool_one/
    │   ├── __init__.py
    │   ├── models.py           # Config + Input schemas
    │   ├── tools.py            # Tool implementation
    │   ├── tools_vars.py       # Tool metadata
    │   └── client.py           # Optional: API client
    └── tool_two/
        ├── __init__.py
        ├── models.py
        ├── tools.py
        └── tools_vars.py
```

### Quick Toolkit Creation Steps

1. **Study reference implementations**:
   - **ITSM Toolkit** (`src/codemie_tools/itsm/`) - Excellent structure
   - **Project Management** (`src/codemie_tools/core/project_management/`) - Jira/Confluence examples
   - **Report Portal** (`src/codemie_tools/report_portal/`) - Health check patterns

2. **Review DEV_GUIDE.md**: Read the [comprehensive development guide](DEV_GUIDE.md) for detailed patterns

3. **Check for utilities**: Before implementing utilities, check `src/codemie_tools/base/utils.py`

4. **Follow the pattern**:
   - Define models (`models.py`)
   - Create metadata (`tools_vars.py`)
   - Implement tool (`tools.py`)
   - Create client if needed (`*_client.py`)
   - Register toolkit (`toolkit.py`)

### Configuration Model Pattern

All configurations must extend `CodeMieToolConfig`:

```python
from pydantic import Field
from codemie_tools.base.models import CodeMieToolConfig

class YourToolConfig(CodeMieToolConfig):
    """Configuration for Your Tool integration."""

    url: str = Field(
        description="Service URL",
        json_schema_extra={"placeholder": "https://example.com"}
    )

    api_token: str = Field(
        description="API authentication token",
        json_schema_extra={
            "placeholder": "your_token",
            "sensitive": True,  # Masks in UI
            "help": "https://docs.example.com/api-keys"
        }
    )

    timeout: int = Field(
        default=30,
        description="Request timeout in seconds"
    )
```

### Tool Implementation Pattern

```python
from typing import Type
from langchain_core.tools import ToolException
from pydantic import BaseModel
from codemie_tools.base.codemie_tool import CodeMieTool

class YourTool(CodeMieTool):
    """Your tool description."""

    config: YourToolConfig
    name: str = TOOL_METADATA.name
    description: str = TOOL_METADATA.description
    args_schema: Type[BaseModel] = YourToolInput

    def execute(self, **kwargs):
        """
        Execute the tool operation.

        Args:
            **kwargs: Tool input parameters

        Returns:
            Result of the operation

        Raises:
            ToolException: If operation fails
        """
        try:
            result = self._perform_operation(**kwargs)
            return result
        except Exception as e:
            raise ToolException(f"Operation failed: {str(e)}")
```

For complete toolkit development examples, see [DEV_GUIDE.md](DEV_GUIDE.md).

---

## Testing Guidelines

### Important Testing Policy

**Do NOT write or run tests unless explicitly requested in the issue/PR requirements.**

However, if tests are required:

### Test Structure

Tests mirror the source structure:

```
tests/
└── codemie_tools/
    └── your_toolkit/
        └── tool_one/
            └── test_tools.py
```

### Basic Test Pattern

```python
import pytest
from unittest.mock import Mock, patch
from langchain_core.tools import ToolException
from codemie_tools.your_toolkit.tool_one.tools import YourTool
from codemie_tools.your_toolkit.tool_one.models import YourToolConfig

@pytest.fixture
def tool_config():
    """Create a test configuration."""
    return YourToolConfig(
        url="https://test.example.com",
        api_token="test_token"
    )

@pytest.fixture
def tool(tool_config):
    """Create a tool instance."""
    return YourTool(config=tool_config)

def test_tool_initialization(tool):
    """Test tool initializes correctly."""
    assert tool.name == "your_tool"
    assert tool.config.url == "https://test.example.com"

def test_execute_success(tool):
    """Test successful execution."""
    with patch.object(tool.client, 'get_resource') as mock_get:
        mock_get.return_value = {"id": "123", "name": "test"}

        result = tool.execute(operation="get", resource_id="123")

        assert result["id"] == "123"
        mock_get.assert_called_once_with("123")

def test_execute_failure(tool):
    """Test execution with error."""
    with patch.object(tool.client, 'get_resource') as mock_get:
        mock_get.side_effect = Exception("API Error")

        with pytest.raises(ToolException) as exc_info:
            tool.execute(operation="get", resource_id="123")

        assert "Failed to execute" in str(exc_info.value)
```

### Running Tests

```bash
# IMPORTANT: Always activate virtual environment first
source venv/bin/activate

# Run all tests
make test

# Run specific test file
poetry run pytest tests/codemie_tools/your_toolkit/test_tools.py

# Run with coverage
make coverage

# Run specific test
poetry run pytest tests/path/to/test.py::test_name -v
```

### Testing Best Practices

- Always mock external dependencies (APIs, databases)
- Test edge cases and error conditions
- Use descriptive test function names
- Follow Arrange-Act-Assert pattern
- Use fixtures for reusable test data

---

## Documentation

### Important Documentation Policy

**Do NOT generate documentation unless explicitly requested.**

However, when documentation is required:

### Docstring Standards

Use Google-style docstrings:

```python
def method(self, param: str) -> dict:
    """
    Brief description of what the method does.

    Detailed explanation if needed, including:
    - Business logic
    - Important constraints
    - Usage examples

    Args:
        param: Description of parameter

    Returns:
        dict: Description of return value

    Raises:
        ToolException: When and why this is raised

    Example:
        >>> tool.method("example")
        {"result": "success"}
    """
```

### When to Update Documentation

- Adding a new toolkit or tool
- Changing public APIs
- Adding new features
- Fixing significant bugs
- Adding examples or tutorials

### Documentation Structure

- **Project README** - Project overview and quick start (in repository root)
- **DEV_GUIDE.md** - Comprehensive development guide for AI agents
- **CONTRIBUTING.md** - This file (contribution guidelines)
- **docs/** - MkDocs documentation site

---

## Pull Request Process

### Pre-PR Checklist

Before creating a pull request, ensure:

- [ ] Virtual environment activated for all commands
- [ ] Read and followed [DEV_GUIDE.md](DEV_GUIDE.md)
- [ ] Studied reference implementations for similar patterns
- [ ] Code follows style guide and conventions
- [ ] Imports organized properly
- [ ] Docstrings added for public classes/methods
- [ ] Error handling uses `ToolException`
- [ ] Checked `base/utils.py` for existing utilities
- [ ] Linting passes: `source venv/bin/activate && make ruff-fix`
- [ ] Tests pass (if applicable): `source venv/bin/activate && make test`
- [ ] Branch is up-to-date with upstream/main
- [ ] Commit messages follow Conventional Commits format
- [ ] No secrets or credentials committed

### Creating a Pull Request

1. **Push your branch to your fork**

   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a pull request**

   - Go to the [repository](https://github.com/epam-gen-ai-run/codemie-tools)
   - Click "Compare & pull request"
   - Fill out the PR template

3. **PR Title Format**

   Follow Conventional Commits:

   ```
   feat(gitlab): Add repository management toolkit
   fix(auth): Resolve token refresh issue for Keycloak
   docs: Update installation guide with troubleshooting
   ```

4. **PR Description**

   Include:
   - **Summary**: What does this PR do?
   - **Motivation**: Why is this change needed?
   - **Changes**: What changed?
   - **Testing**: How was this tested?
   - **Screenshots**: If applicable
   - **Breaking Changes**: If any
   - **Related Issues**: Closes #123

### Review Process

1. **Automated Checks**: CI must pass (linting, tests)
2. **Code Review**: At least one maintainer approval required
3. **Feedback**: Address review comments
4. **Updates**: Push additional commits if needed
5. **Merge**: Maintainer will merge after approval

### After Your PR is Merged

- Delete your feature branch (GitHub offers this option)
- Update your local main branch:

  ```bash
  git checkout main
  git pull upstream main
  ```

---

## Common Tasks

### Adding a New Toolkit

1. Study reference implementations (ITSM, Project Management)
2. Create directory structure under `src/codemie_tools/`
3. Implement models, metadata, tool, and client
4. Register in `toolkit.py`
5. Run `source venv/bin/activate && make ruff-fix`
6. Create PR with title: `feat(toolkit-name): Add [toolkit name] integration`

### Adding a Tool to Existing Toolkit

1. Create tool package directory
2. Implement `models.py`, `tools_vars.py`, `tools.py`
3. Add client if needed
4. Register in parent `toolkit.py`
5. Run linting and tests
6. Create PR with title: `feat(toolkit-name): Add [tool name] support`

### Fixing a Bug

1. Create branch: `fix/brief-description`
2. Write a test that reproduces the bug (if applicable)
3. Fix the bug
4. Verify the test passes
5. Run linting: `make ruff-fix`
6. Create PR with title: `fix(scope): Brief description of fix`

### Updating Dependencies

1. Update `pyproject.toml`
2. Run `poetry update`
3. Test that everything still works
4. Create PR with title: `chore(deps): Update [dependency] to [version]`

### Quick Command Reference

```bash
# Development
make install              # Install dependencies
make build                # Build package

# Code Quality
make ruff-fix             # Auto-fix linting issues (recommended)
make ruff                 # Full lint and format check
make verify               # Run linting and tests together

# Testing
make test                 # Run all tests
make coverage             # Run tests with coverage report
poetry run pytest tests/path/to/test.py              # Run specific test file
poetry run pytest tests/path/to/test.py::test_name   # Run specific test

# Documentation
poetry run mkdocs serve   # Serve docs locally
poetry run mkdocs build   # Build docs

# Git Workflow
git fetch upstream        # Fetch upstream changes
git rebase upstream/main  # Rebase on latest main
```

---

## Troubleshooting

### Common Issues

**Issue**: Import errors when running tests

**Solution**: Ensure package is installed: `make install`

---

**Issue**: Linting failures

**Solution**: Run `make ruff-fix` to auto-fix issues

---

**Issue**: Tests fail with connection errors

**Solution**: Ensure external dependencies are properly mocked

---

**Issue**: "Command not found" errors

**Solution**: Activate virtual environment: `source venv/bin/activate`

---

**Issue**: Configuration not appearing in UI

**Solution**:
- Check `json_schema_extra` is properly defined
- Ensure toolkit uses `DiscoverableToolkit`
- Verify `settings_config=True` in metadata

---

**Issue**: Tool not discovered by toolkit

**Solution**:
- Verify tool is registered in `toolkit.py`
- Check metadata is properly defined in `tools_vars.py`

---

**Issue**: Merge conflicts

**Solution**:
```bash
git fetch upstream
git rebase upstream/main
# Resolve conflicts
git add .
git rebase --continue
```

### Getting Help

If you're stuck:

1. Check [DEV_GUIDE.md](DEV_GUIDE.md) for technical details
2. Review reference implementations
3. Search [GitHub Issues](https://github.com/epam-gen-ai-run/codemie-tools/issues)
4. Ask in [GitHub Discussions](https://github.com/epam-gen-ai-run/codemie-tools/discussions)
5. Reach out to maintainers

---

## Community & Support

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions, ideas, and general discussion
- **Pull Requests**: Code contributions and reviews

### Issue Reporting

When reporting a bug, include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Python version, OS, etc.)
- Error messages and stack traces
- Minimal reproducible example

### Feature Requests

When suggesting a feature:
- Describe the use case
- Explain the expected behavior
- Provide examples if possible
- Consider implementation approach

### Contributor Recognition

All contributors are recognized in:
- Git history
- Release notes
- Project README (for significant contributions)

We appreciate every contribution, no matter how small!

---

## Additional Resources

### Key Documentation

- **[DEV_GUIDE.md](DEV_GUIDE.md)** - Comprehensive AI agent development guide
- **[Documentation Site](https://epam-gen-ai-run.github.io/codemie-tools/)** - Full documentation
- **Project README** - Available in the [GitHub repository](https://github.com/epam-gen-ai-run/codemie-tools)

### Reference Implementations

Study these excellent examples:
- **ITSM Toolkit** - `src/codemie_tools/itsm/`
- **Project Management** - `src/codemie_tools/core/project_management/`
- **Report Portal** - `src/codemie_tools/report_portal/`

### External Resources

- [LangChain Documentation](https://python.langchain.com/docs/get_started/introduction)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [Poetry Documentation](https://python-poetry.org/docs/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

---

## License

By contributing to CodeMie Tools, you agree that your contributions will be licensed under the [Apache License 2.0](https://github.com/epam-gen-ai-run/codemie-tools/blob/main/LICENSE).

---

## Thank You!

Thank you for contributing to CodeMie Tools! Your contributions help make this project better for everyone. We're excited to see what you build!

If you have any questions or need help, don't hesitate to reach out through GitHub Issues or Discussions.

Happy coding! 🚀
