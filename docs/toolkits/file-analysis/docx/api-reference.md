# DOCX Tool - API Reference

Complete API reference for the DOCX Tool.

## DocxTool

Main tool class for processing Word documents.

::: codemie_tools.file_analysis.docx_tool.DocxTool
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - __init__
        - execute

---

## DocxToolInput

Input schema defined in `codemie_tools.file_analysis.docx.models`.

**Fields**:

- `pages` (str | None): Page range specification (e.g., "1-5", "1,3,5")
- `query` (QueryType): Type of operation to perform
- `instructions` (str | None): Additional instructions for AI-powered operations

---

## QueryType

Available query types:

- `TEXT` - Extract plain text
- `TEXT_WITH_METADATA` - Extract text with metadata
- `IMAGE_EXTRACTION` - Extract images
- `TABLE_EXTRACTION` - Extract tables
- `SUMMARY` - AI-powered summary (requires chat_model)
- `TOTAL_PAGES` - Get page count

---

## Usage Examples

### Basic Text Extraction

```python
from codemie_tools.file_analysis.docx_tool import DocxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("document.docx")
docx_tool = DocxTool(files=[file_obj])

text = docx_tool.execute(pages=None, query="Text")
```

### Extract Tables

```python
tables = docx_tool.execute(pages=None, query="Table_Extraction")
for table in tables:
    print(table)
```

### Extract Images

```python
images = docx_tool.execute(pages=None, query="Image_Extraction")
```

### AI Summary

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4")
docx_tool = DocxTool(files=[file_obj], chat_model=llm)

summary = docx_tool.execute(
    pages=None,
    query="Summary",
    instructions="Focus on key findings and recommendations"
)
```

### Process Specific Pages

```python
# Process pages 1-5
text = docx_tool.execute(pages="1-5", query="Text")

# Process specific pages
text = docx_tool.execute(pages="1,3,5", query="Text")
```

---

## See Also

- [Overview](overview.md)
- [Examples](examples.md)
