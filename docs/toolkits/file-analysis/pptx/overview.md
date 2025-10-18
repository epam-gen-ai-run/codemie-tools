# PPTX Tool - Overview

The PPTX Tool provides capabilities for processing PowerPoint presentations, including text extraction, slide analysis, and metadata retrieval.

## Features

- **Text Extraction**: Extract text content from slides
- **Markdown Conversion**: Convert slides to Markdown format
- **Metadata Support**: Access slide metadata and properties
- **Slide Selection**: Process specific slides or entire presentations
- **Multi-File Support**: Process multiple PPTX files simultaneously
- **Slide Counting**: Get total slide count

## Quick Start

```python
from codemie_tools.file_analysis.pptx_tool import PPTXTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("presentation.pptx")

# Initialize tool
pptx_tool = PPTXTool(files=[file_obj])

# Extract text from all slides
text = pptx_tool.execute(slides=[], query="Text")

# Extract specific slides
text = pptx_tool.execute(slides=[1, 2, 3], query="Text")

# Get total slides
total = pptx_tool.execute(slides=[], query="Total_Slides")
```

## Query Types

### Text
Extract text content in Markdown format.

```python
markdown = pptx_tool.execute(slides=[], query="Text")
```

### Text_with_Metadata
Extract text with structured metadata (JSON format).

```python
data = pptx_tool.execute(slides=[1], query="Text_with_Metadata")
```

### Total_Slides
Get the total number of slides.

```python
total = pptx_tool.execute(slides=[], query="Total_Slides")
```

## Use Cases

### Content Extraction
Extract presentation content for analysis or conversion.

```python
pptx_tool = PPTXTool(files=[FileObject.from_path("deck.pptx")])
content = pptx_tool.execute(slides=[], query="Text")
```

### Slide Analysis
Analyze specific slides with metadata.

```python
slide_data = pptx_tool.execute(slides=[1, 2], query="Text_with_Metadata")
```

### Batch Processing
Process multiple presentations.

```python
files = [
    FileObject.from_path("q1_results.pptx"),
    FileObject.from_path("q2_results.pptx")
]
pptx_tool = PPTXTool(files=files)
results = pptx_tool.execute(slides=[], query="Text")
```

## LangChain Integration

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
pptx_tool = PPTXTool(files=[file_obj], chat_model=llm)

prompt = ChatPromptTemplate.from_messages([
    ("system", "You analyze PowerPoint presentations."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[pptx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[pptx_tool])

result = executor.invoke({"input": "Summarize this presentation"})
```

## See Also

- [API Reference](api-reference.md)
- [Examples](examples.md)
