# PDF Tool - API Reference

Complete API reference for the PDF Tool.

## PDFTool

Main tool class for processing PDF documents.

::: codemie_tools.file_analysis.pdf_tool.PDFTool
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - __init__
        - execute

---

## PDFToolInput

Input schema for PDF Tool operations.

::: codemie_tools.file_analysis.pdf_tool.PDFToolInput
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3

---

## QueryType

Enum defining available query types.

::: codemie_tools.file_analysis.pdf_tool.QueryType
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3

**Available Query Types**:

- `TEXT` - Extract plain text from PDF pages
- `TEXT_WITH_METADATA` - Extract text with document metadata
- `TEXT_WITH_OCR` - Extract text from images using LLM (requires chat_model)
- `TOTAL_PAGES` - Get total number of pages

---

## Usage Examples

### Basic Text Extraction

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool, QueryType
from codemie_tools.base.file_object import FileObject

# Load PDF
file_obj = FileObject.from_path("document.pdf")
pdf_tool = PDFTool(files=[file_obj])

# Extract all pages
text = pdf_tool.execute(pages=[], query=QueryType.TEXT)
print(text)

# Extract specific pages
text = pdf_tool.execute(pages=[1, 2, 3], query=QueryType.TEXT)
```

### Text Extraction with Metadata

```python
# Get text with metadata
result = pdf_tool.execute(pages=[1], query=QueryType.TEXT_WITH_METADATA)
print(result)
```

### Image Text Extraction

```python
from langchain_openai import ChatOpenAI

# Configure LLM for image text extraction
llm = ChatOpenAI(model="gpt-4o", temperature=0)
pdf_tool = PDFTool(files=[file_obj], chat_model=llm)

# Extract text from images
text = pdf_tool.execute(pages=[1], query=QueryType.TEXT_WITH_OCR)
```

### Get Page Count

```python
# Get total pages
total_pages = pdf_tool.execute(pages=[], query=QueryType.TOTAL_PAGES)
print(f"Total pages: {total_pages}")
```

### Multi-File Processing

```python
# Process multiple PDFs
files = [
    FileObject.from_path("doc1.pdf"),
    FileObject.from_path("doc2.pdf")
]

pdf_tool = PDFTool(files=files)
text = pdf_tool.execute(pages=[], query=QueryType.TEXT)
```

---

## Error Handling

```python
try:
    pdf_tool = PDFTool(files=[file_obj])
    result = pdf_tool.execute(pages=[1], query=QueryType.TEXT)
except ValueError as e:
    print(f"Validation error: {e}")
except Exception as e:
    print(f"Processing error: {e}")
```

---

## See Also

- [Overview](overview.md) - Tool overview and features
- [Examples](examples.md) - Practical examples
