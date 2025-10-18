# PPTX Tool - API Reference

Complete API reference for the PPTX Tool.

## PPTXTool

Main tool class for processing PowerPoint presentations.

::: codemie_tools.file_analysis.pptx_tool.PPTXTool
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - __init__
        - execute

---

## PPTXToolInput

Input schema for PPTX Tool operations.

::: codemie_tools.file_analysis.pptx_tool.PPTXToolInput
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3

---

## QueryType

::: codemie_tools.file_analysis.pptx_tool.QueryType
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3

**Available Query Types**:

- `TEXT` - Extract text as Markdown
- `TEXT_WITH_METADATA` - Extract text with metadata (JSON)
- `TOTAL_SLIDES` - Get total slide count

---

## Usage Examples

### Extract All Slides

```python
from codemie_tools.file_analysis.pptx_tool import PPTXTool, QueryType
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("presentation.pptx")
pptx_tool = PPTXTool(files=[file_obj])

# Get all slides as markdown
markdown = pptx_tool.execute(slides=[], query=QueryType.TEXT)
print(markdown)
```

### Extract Specific Slides

```python
# Extract slides 1, 3, and 5
text = pptx_tool.execute(slides=[1, 3, 5], query=QueryType.TEXT)
```

### Get Structured Data

```python
# Get slides with metadata
data = pptx_tool.execute(slides=[1, 2], query=QueryType.TEXT_WITH_METADATA)
```

### Get Slide Count

```python
total_slides = pptx_tool.execute(slides=[], query=QueryType.TOTAL_SLIDES)
print(f"Total slides: {total_slides}")
```

### Process Multiple Files

```python
files = [
    FileObject.from_path("deck1.pptx"),
    FileObject.from_path("deck2.pptx")
]

pptx_tool = PPTXTool(files=files)
results = pptx_tool.execute(slides=[], query=QueryType.TEXT)
```

---

## Error Handling

```python
try:
    pptx_tool = PPTXTool(files=[file_obj])
    result = pptx_tool.execute(slides=[1], query=QueryType.TEXT)
except ValueError as e:
    print(f"Validation error: {e}")
except Exception as e:
    print(f"Processing error: {e}")
```

---

## See Also

- [Overview](overview.md)
- [Examples](examples.md)
