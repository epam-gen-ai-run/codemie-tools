# PPTX Tool - Examples

## Basic Examples

### Extract All Slides

```python
from codemie_tools.file_analysis.pptx_tool import PPTXTool, QueryType
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("quarterly_review.pptx")
pptx_tool = PPTXTool(files=[file_obj])

markdown = pptx_tool.execute(slides=[], query=QueryType.TEXT)
print(markdown)
```

### Extract Specific Slides

```python
# Extract title and summary slides
text = pptx_tool.execute(slides=[1, 2], query=QueryType.TEXT)
```

### Get Slide Count

```python
total = pptx_tool.execute(slides=[], query=QueryType.TOTAL_SLIDES)
print(f"Presentation has {total} slides")
```

## Advanced Examples

### Extract with Metadata

```python
# Get structured data with metadata
data = pptx_tool.execute(slides=[1, 2, 3], query=QueryType.TEXT_WITH_METADATA)

for slide in data:
    print(f"Slide {slide['slide_number']}:")
    print(slide['content'])
```

### Batch Processing

```python
files = [FileObject.from_path(f"deck{i}.pptx") for i in range(1, 6)]
pptx_tool = PPTXTool(files=files)

results = pptx_tool.execute(slides=[], query=QueryType.TEXT)
```

### LangChain Integration

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
pptx_tool = PPTXTool(files=[file_obj], chat_model=llm)

prompt = ChatPromptTemplate.from_messages([
    ("system", "Analyze PowerPoint presentations."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[pptx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[pptx_tool])

result = executor.invoke({
    "input": "Extract key points from the first 5 slides"
})
print(result["output"])
```

## See Also

- [Overview](overview.md)
- [API Reference](api-reference.md)
