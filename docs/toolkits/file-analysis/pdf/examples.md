# PDF Tool - Examples

Practical examples for using the PDF Tool.

## Basic Examples

### Extract All Text

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool, QueryType
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("report.pdf")
pdf_tool = PDFTool(files=[file_obj])

text = pdf_tool.execute(pages=[], query=QueryType.TEXT)
print(text)
```

### Extract Specific Pages

```python
# Extract first 5 pages
text = pdf_tool.execute(pages=[1, 2, 3, 4, 5], query=QueryType.TEXT)
```

### Get Page Count

```python
total = pdf_tool.execute(pages=[], query=QueryType.TOTAL_PAGES)
print(f"Document has {total} pages")
```

## Advanced Examples

### OCR with LLM

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o")
pdf_tool = PDFTool(files=[file_obj], chat_model=llm)

# Extract text from scanned document
text = pdf_tool.execute(pages=[], query=QueryType.TEXT_WITH_OCR)
```

### Batch Processing

```python
files = [FileObject.from_path(f"doc{i}.pdf") for i in range(1, 11)]
pdf_tool = PDFTool(files=files)
results = pdf_tool.execute(pages=[], query=QueryType.TEXT)
```

### LangChain Agent

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
pdf_tool = PDFTool(files=[file_obj], chat_model=llm)

prompt = ChatPromptTemplate.from_messages([
    ("system", "Extract and analyze PDF content."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[pdf_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[pdf_tool])

result = executor.invoke({"input": "Summarize this document"})
print(result["output"])
```

## See Also

- [Overview](overview.md)
- [API Reference](api-reference.md)
