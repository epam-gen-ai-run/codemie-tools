# PDF Tool - Overview

The PDF Tool provides comprehensive capabilities for extracting and processing content from PDF documents, including text extraction, OCR support, and metadata retrieval.

## Features

- **Text Extraction**: Extract text from PDF pages with high fidelity
- **Image Text Recognition**: Extract text from images within PDFs using LLM-based recognition
- **Metadata Support**: Access document metadata alongside content
- **Page Selection**: Process specific pages or entire documents
- **Multi-File Support**: Handle multiple PDF files in a single operation
- **Page Counting**: Get total page count of PDF documents

## Quick Start

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("document.pdf")

# Initialize tool
pdf_tool = PDFTool(files=[file_obj])

# Extract text from all pages
text = pdf_tool.execute(pages=[], query="Text")

# Extract text from specific pages
text = pdf_tool.execute(pages=[1, 2, 3], query="Text")

# Get total pages
total = pdf_tool.execute(pages=[], query="Total_Pages")
```

## Query Types

The PDF Tool supports several query types:

### Text
Extract plain text from PDF pages.

```python
result = pdf_tool.execute(pages=[1], query="Text")
```

### Text_with_Metadata
Extract text along with document metadata.

```python
result = pdf_tool.execute(pages=[1], query="Text_with_Metadata")
```

### Text_with_Image
Extract text from images within the PDF using LLM-based image recognition.

**Note**: Requires a chat model to be configured.

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o", temperature=0)
pdf_tool = PDFTool(files=[file_obj], chat_model=llm)

result = pdf_tool.execute(pages=[1], query="Text_with_Image")
```

### Total_Pages
Get the total number of pages in the PDF.

```python
total_pages = pdf_tool.execute(pages=[], query="Total_Pages")
```

## Use Cases

### Document Analysis
Extract and analyze text from reports, contracts, and academic papers.

```python
# Extract text from a research paper
pdf_tool = PDFTool(files=[FileObject.from_path("research_paper.pdf")])
content = pdf_tool.execute(pages=[], query="Text")
```

### OCR Processing
Extract text from scanned documents or PDFs with embedded images.

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o")
pdf_tool = PDFTool(files=[FileObject.from_path("scanned.pdf")], chat_model=llm)
text = pdf_tool.execute(pages=[], query="Text_with_Image")
```

### Batch Processing
Process multiple PDF files simultaneously.

```python
files = [
    FileObject.from_path("doc1.pdf"),
    FileObject.from_path("doc2.pdf"),
    FileObject.from_path("doc3.pdf")
]

pdf_tool = PDFTool(files=files)
results = pdf_tool.execute(pages=[], query="Text")
```

### Selective Extraction
Extract content from specific pages only.

```python
# Extract only the executive summary (pages 1-3)
summary = pdf_tool.execute(pages=[1, 2, 3], query="Text")
```

## LangChain Integration

The PDF Tool integrates seamlessly with LangChain agents:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

# Setup
llm = ChatOpenAI(model="gpt-4", temperature=0)
file_obj = FileObject.from_path("contract.pdf")
pdf_tool = PDFTool(files=[file_obj], chat_model=llm)

# Create agent
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a document analysis assistant. Extract and analyze PDF content."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[pdf_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[pdf_tool], verbose=True)

# Execute
result = executor.invoke({
    "input": "Summarize the key points from the contract"
})
```

## Performance Considerations

### Memory Usage
- Large PDFs with many pages can consume significant memory
- Consider processing pages in batches for very large documents
- Image text extraction requires additional memory for LLM processing

### Processing Speed
- Text extraction is fast for text-based PDFs
- Image text extraction is slower (requires LLM inference)
- Processing time scales linearly with number of pages

### Optimization Tips

1. **Process specific pages**: Only extract pages you need
2. **Use appropriate query type**: Don't use image extraction if not needed
3. **Batch efficiently**: Group related pages together
4. **Cache results**: Store extracted text for reuse

## Error Handling

The PDF Tool raises `ValueError` for invalid inputs:

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool

try:
    # This will raise ValueError - no files provided
    pdf_tool = PDFTool(files=[])
except ValueError as e:
    print(f"Error: {e}")

try:
    result = pdf_tool.execute(pages=[999], query="Text")
except Exception as e:
    print(f"Processing error: {e}")
```

## See Also

- [API Reference](api-reference.md) - Complete API documentation
- [Examples](examples.md) - Practical code examples
- [File Analysis Overview](../index.md) - Overview of all file analysis tools
