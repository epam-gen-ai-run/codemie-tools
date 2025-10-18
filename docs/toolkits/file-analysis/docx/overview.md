# DOCX Tool - Overview

The DOCX Tool provides comprehensive capabilities for processing Microsoft Word documents, including text extraction, image extraction, table extraction, and AI-powered document analysis.

## Features

- **Text Extraction**: Extract formatted text from Word documents
- **Image Extraction**: Extract embedded images from documents
- **Table Extraction**: Extract tables in structured format
- **Metadata Support**: Access document properties and metadata
- **Page Selection**: Process specific pages or entire documents
- **AI-Powered Analysis**: Summary and custom analysis using LLM
- **Multi-File Support**: Process multiple DOCX files simultaneously

## Quick Start

```python
from codemie_tools.file_analysis.docx_tool import DocxTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("document.docx")

# Initialize tool
docx_tool = DocxTool(files=[file_obj])

# Extract text
text = docx_tool.execute(pages=None, query="Text")

# Extract tables
tables = docx_tool.execute(pages=None, query="Table_Extraction")

# Extract images
images = docx_tool.execute(pages=None, query="Image_Extraction")
```

## Query Types

### Text
Extract plain text content from the document.

```python
text = docx_tool.execute(pages=None, query="Text")
```

### Text_with_Metadata
Extract text along with document metadata.

```python
result = docx_tool.execute(pages=None, query="Text_with_Metadata")
```

### Image_Extraction
Extract all images from the document.

```python
images = docx_tool.execute(pages=None, query="Image_Extraction")
```

### Table_Extraction
Extract all tables in structured format.

```python
tables = docx_tool.execute(pages=None, query="Table_Extraction")
```

### Summary
Generate AI-powered summary of the document.

**Requires**: chat_model configured

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4")
docx_tool = DocxTool(files=[file_obj], chat_model=llm)

summary = docx_tool.execute(
    pages=None,
    query="Summary",
    instructions="Provide a concise executive summary"
)
```

### Total_Pages
Get the total number of pages in the document.

```python
total = docx_tool.execute(pages=None, query="Total_Pages")
```

## LangChain Integration

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
docx_tool = DocxTool(files=[file_obj], chat_model=llm)

prompt = ChatPromptTemplate.from_messages([
    ("system", "You analyze Word documents."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[docx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[docx_tool])

result = executor.invoke({"input": "Extract key findings from this report"})
```

## See Also

- [API Reference](api-reference.md)
- [Examples](examples.md)
