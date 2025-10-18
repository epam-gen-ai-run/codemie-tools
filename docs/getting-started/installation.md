# Installation

Get started with CodeMie Tools in minutes.

## Requirements

- **Python**: 3.12 or 3.13
- **Package Manager**: pip or Poetry

## Installation Methods

### Using pip (Recommended)

Install the latest stable version from PyPI:

```bash
pip install codemie-tools
```

### Using Poetry

If you're using Poetry for dependency management:

```bash
poetry add codemie-tools
```

### From Source

For development or to use the latest features:

```bash
# Clone the repository
git clone https://github.com/epam-gen-ai-run/codemie-tools.git
cd codemie-tools

# Install with Poetry
make install

# Or install with pip in editable mode
pip install -e .
```

## Verify Installation

Verify that CodeMie Tools is installed correctly:

```python
import codemie_tools
print(codemie_tools.__version__)
```

Or check specific components:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

print("CodeMie Tools installed successfully!")
```

## Optional Dependencies

CodeMie Tools has different optional dependencies for specific toolkits:

### LangChain Integration

```bash
pip install codemie-tools langchain langchain-openai
```

### Vision and OCR

For image processing and OCR capabilities:

```bash
pip install codemie-tools opencv-python-headless
```

### Cloud Services

For AWS integration:

```bash
pip install codemie-tools boto3
```

For Kubernetes:

```bash
pip install codemie-tools kubernetes
```

## Development Installation

For contributing to CodeMie Tools:

```bash
# Clone repository
git clone https://github.com/epam-gen-ai-run/codemie-tools.git
cd codemie-tools

# Install with development dependencies
make install

# Install pre-commit hooks (optional)
pre-commit install

# Run tests to verify
make test
```

### Development Dependencies

Development installation includes:

- **pytest**: Testing framework
- **ruff**: Linting and formatting
- **pytest-cov**: Coverage reporting
- **pytest-asyncio**: Async test support

## Troubleshooting

### Python Version Issues

If you get a Python version error:

```bash
# Check your Python version
python --version

# Should be 3.12 or 3.13
# If not, install the correct version or use pyenv
```

### Dependency Conflicts

If you encounter dependency conflicts:

```bash
# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install in the clean environment
pip install codemie-tools
```

### Import Errors

If you get import errors after installation:

```bash
# Ensure the package is installed
pip show codemie-tools

# Reinstall if needed
pip uninstall codemie-tools
pip install codemie-tools
```

### Building from Source

If building from source fails:

```bash
# Ensure Poetry is installed
pip install poetry

# Clear cache and reinstall
poetry cache clear . --all
poetry install
```

## Platform-Specific Notes

### macOS

```bash
# Install Python 3.12 via Homebrew if needed
brew install python@3.12

# Install CodeMie Tools
pip3 install codemie-tools
```

### Linux

```bash
# Install Python 3.12 if not available
sudo apt-get update
sudo apt-get install python3.12 python3.12-venv

# Install CodeMie Tools
pip3 install codemie-tools
```

### Windows

```bash
# Using PowerShell
pip install codemie-tools

# If you get SSL errors, try:
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org codemie-tools
```

## Docker

Run CodeMie Tools in Docker:

```dockerfile
FROM python:3.12-slim

# Install CodeMie Tools
RUN pip install codemie-tools

# Your application code
COPY . /app
WORKDIR /app

CMD ["python", "your_script.py"]
```

Build and run:

```bash
docker build -t codemie-tools-app .
docker run codemie-tools-app
```

## Next Steps

- [Quick Start Guide](quick-start.md): Get up and running in 5 minutes

## Getting Help

- **Documentation**: You're reading it!
- **GitHub Issues**: [Report bugs or request features](https://github.com/epam-gen-ai-run/codemie-tools/issues)
- **PyPI**: [Package information](https://pypi.org/project/codemie-tools/)
