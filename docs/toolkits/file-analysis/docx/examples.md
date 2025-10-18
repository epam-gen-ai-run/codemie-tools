# DOCX Tool - Examples

## Basic Examples

### Extract Text

```python
from codemie_tools.file_analysis.docx_tool import DocxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("report.docx")
docx_tool = DocxTool(files=[file_obj])

text = docx_tool.execute(pages=None, query="Text")
print(text)
```

### Extract Tables

```python
tables = docx_tool.execute(pages=None, query="Table_Extraction")
for i, table in enumerate(tables):
    print(f"Table {i+1}:")
    print(table)
```

### Extract Images

```python
images = docx_tool.execute(pages=None, query="Image_Extraction")
print(f"Found {len(images)} images")
```

## Advanced Examples

### AI-Powered Summary

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4")
docx_tool = DocxTool(files=[file_obj], chat_model=llm)

summary = docx_tool.execute(
    pages=None,
    query="Summary",
    instructions="Provide 3-5 key bullet points"
)
print(summary)
```

### Process Multiple Files

```python
files = [
    FileObject.from_path("doc1.docx"),
    FileObject.from_path("doc2.docx")
]

docx_tool = DocxTool(files=files)
text = docx_tool.execute(pages=None, query="Text")
```

### Selective Page Processing

```python
# First 3 pages only
text = docx_tool.execute(pages="1-3", query="Text")

# Specific pages
text = docx_tool.execute(pages="1,5,10", query="Text")
```

## See Also

- [Overview](overview.md)
- [API Reference](api-reference.md)
