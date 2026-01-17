# Code Execution with MCP

> **Source**: Official Claude Engineering Blog & MCP Documentation
> **Source URL**: https://www.anthropic.com/engineering/code-execution-with-mcp
> **Last Updated**: 2025-01-15

## Overview

Claude Code supports direct code execution through MCP (Model Context Protocol) integration with execution environments. This enables interactive programming, data analysis, testing, and prototyping directly within conversations.

## What is Code Execution?

Code execution allows Claude to:
- Run code snippets in live environments
- Interact with execution results
- Iterate based on output
- Perform data analysis
- Test implementations
- Debug interactively

### Supported Environments

**Jupyter Kernels** (via MCP):
- Python
- R
- Julia
- JavaScript/Node.js
- Other Jupyter-compatible languages

**Sandbox Environments**:
- Isolated execution contexts
- Controlled resource access
- Safe experimentation

## MCP Code Execution Tool

### Tool: `mcp__ide__executeCode`

**Purpose**: Execute code in the current Jupyter kernel for notebook files.

**Capabilities**:
- Execute arbitrary code in active kernel
- Access execution results
- Maintain state across calls
- Support for standard output, errors, and rich media

**Parameters**:
```typescript
{
  code: string;  // The code to execute
}
```

**Behavior**:
- All code executes in persistent kernel
- State persists across multiple calls
- Avoid declaring variables unless user requests
- Kernel retains state until restart

**Important Characteristics**:
- **Stateful**: Variables and imports persist
- **Synchronous**: Waits for execution completion
- **Interactive**: Can use results in subsequent calls
- **Limited**: Runs only in notebook context

### Example Usage

```python
# First execution - setup
mcp__ide__executeCode:
  code: |
    import pandas as pd
    import numpy as np

    data = pd.DataFrame({
        'name': ['Alice', 'Bob', 'Charlie'],
        'score': [85, 92, 78]
    })

# Second execution - uses previous state
mcp__ide__executeCode:
  code: |
    mean_score = data['score'].mean()
    print(f"Average score: {mean_score}")

# Third execution - builds on results
mcp__ide__executeCode:
  code: |
    data['above_average'] = data['score'] > mean_score
    data
```

## Use Cases

### 1. Data Analysis

**Exploratory Data Analysis**:
```python
# Load and explore data
mcp__ide__executeCode:
  code: |
    import pandas as pd
    df = pd.read_csv('data.csv')

    print("Shape:", df.shape)
    print("\nFirst rows:")
    print(df.head())
    print("\nSummary statistics:")
    print(df.describe())
```

**Visualization**:
```python
mcp__ide__executeCode:
  code: |
    import matplotlib.pyplot as plt

    df.plot(x='date', y='value', figsize=(12, 6))
    plt.title('Time Series Analysis')
    plt.show()
```

**Statistical Analysis**:
```python
mcp__ide__executeCode:
  code: |
    from scipy import stats

    # Correlation analysis
    correlation = df.corr()

    # Hypothesis testing
    statistic, pvalue = stats.ttest_ind(group_a, group_b)

    print(f"T-statistic: {statistic}")
    print(f"P-value: {pvalue}")
```

### 2. Algorithm Development

**Iterative Implementation**:
```python
# First attempt
mcp__ide__executeCode:
  code: |
    def fibonacci(n):
        if n <= 1:
            return n
        return fibonacci(n-1) + fibonacci(n-2)

    # Test
    result = [fibonacci(i) for i in range(10)]
    print(result)

# Optimized version
mcp__ide__executeCode:
  code: |
    def fibonacci_optimized(n, memo={}):
        if n in memo:
            return memo[n]
        if n <= 1:
            return n
        memo[n] = fibonacci_optimized(n-1, memo) + fibonacci_optimized(n-2, memo)
        return memo[n]

    # Performance test
    import time
    start = time.time()
    result = fibonacci_optimized(35)
    elapsed = time.time() - start
    print(f"Result: {result}, Time: {elapsed:.4f}s")
```

### 3. Testing and Validation

**Unit Testing**:
```python
mcp__ide__executeCode:
  code: |
    def add(a, b):
        return a + b

    # Test cases
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

    print("All tests passed!")
```

**Property Testing**:
```python
mcp__ide__executeCode:
  code: |
    from hypothesis import given, strategies as st

    @given(st.integers(), st.integers())
    def test_addition_commutative(a, b):
        assert add(a, b) == add(b, a)

    test_addition_commutative()
    print("Property tests passed!")
```

### 4. Data Transformation

**ETL Operations**:
```python
mcp__ide__executeCode:
  code: |
    # Extract
    raw_data = pd.read_json('raw_data.json')

    # Transform
    cleaned = raw_data.dropna()
    cleaned['date'] = pd.to_datetime(cleaned['date'])
    cleaned['value'] = cleaned['value'].astype(float)

    # Load
    cleaned.to_parquet('processed_data.parquet')

    print(f"Processed {len(cleaned)} records")
```

### 5. Machine Learning

**Model Training**:
```python
mcp__ide__executeCode:
  code: |
    from sklearn.model_selection import train_test_split
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.metrics import accuracy_score

    # Prepare data
    X = df.drop('target', axis=1)
    y = df['target']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

    # Train model
    model = RandomForestClassifier(n_estimators=100)
    model.fit(X_train, y_train)

    # Evaluate
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)

    print(f"Model accuracy: {accuracy:.2%}")
```

**Feature Engineering**:
```python
mcp__ide__executeCode:
  code: |
    # Create new features
    df['hour'] = df['timestamp'].dt.hour
    df['day_of_week'] = df['timestamp'].dt.dayofweek
    df['is_weekend'] = df['day_of_week'].isin([5, 6])

    # Encode categorical variables
    df_encoded = pd.get_dummies(df, columns=['category'])

    print("New features created:", df_encoded.columns.tolist())
```

### 6. Debugging

**Interactive Debugging**:
```python
# Reproduce error
mcp__ide__executeCode:
  code: |
    def problematic_function(data):
        result = []
        for item in data:
            result.append(item['value'] * 2)
        return result

    test_data = [{'value': 1}, {'name': 'broken'}]
    try:
        problematic_function(test_data)
    except Exception as e:
        print(f"Error: {e}")
        print(f"Type: {type(e)}")

# Test fix
mcp__ide__executeCode:
  code: |
    def fixed_function(data):
        result = []
        for item in data:
            if 'value' in item:
                result.append(item['value'] * 2)
            else:
                print(f"Skipping item without value: {item}")
        return result

    fixed_function(test_data)
```

## Best Practices

### State Management

```python
✅ DO:
# Clean state when needed
mcp__ide__executeCode:
  code: |
    # Clear specific variables
    del large_dataframe

    # Import fresh modules
    import importlib
    import my_module
    importlib.reload(my_module)

❌ DON'T:
# Don't assume clean state
mcp__ide__executeCode:
  code: |
    # This might fail if 'data' doesn't exist
    print(data)
```

### Error Handling

```python
✅ DO:
mcp__ide__executeCode:
  code: |
    try:
        result = risky_operation()
        print(f"Success: {result}")
    except ValueError as e:
        print(f"Value error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")
        import traceback
        traceback.print_exc()

❌ DON'T:
mcp__ide__executeCode:
  code: |
    # Unhandled errors stop execution
    result = risky_operation()
```

### Resource Management

```python
✅ DO:
mcp__ide__executeCode:
  code: |
    # Use context managers
    with open('file.txt', 'r') as f:
        data = f.read()

    # Clean up large objects
    import gc
    del large_array
    gc.collect()

❌ DON'T:
mcp__ide__executeCode:
  code: |
    # Leave resources open
    f = open('file.txt', 'r')
    data = f.read()
    # File never closed
```

### Output Quality

```python
✅ DO:
mcp__ide__executeCode:
  code: |
    # Provide clear, formatted output
    print(f"Processing {len(items)} items...")
    for i, item in enumerate(items, 1):
        if i % 100 == 0:
            print(f"  Processed {i}/{len(items)}")
    print("Complete!")

❌ DON'T:
mcp__ide__executeCode:
  code: |
    # Unclear output
    print(items)
    print("done")
```

## Workflow Patterns

### Analysis Workflow

```markdown
1. Setup environment
   - Import libraries
   - Configure settings
   - Define helper functions

2. Load data
   - Read from source
   - Validate structure
   - Check data quality

3. Explore data
   - Summary statistics
   - Distributions
   - Correlations

4. Transform data
   - Clean missing values
   - Feature engineering
   - Normalization

5. Analyze
   - Statistical tests
   - Visualizations
   - Insights extraction

6. Report results
   - Formatted output
   - Conclusions
   - Recommendations
```

### Development Workflow

```markdown
1. Define requirements
   - Understand problem
   - Identify constraints
   - Plan approach

2. Implement solution
   - Write initial code
   - Test basic functionality
   - Handle edge cases

3. Test thoroughly
   - Unit tests
   - Integration tests
   - Performance tests

4. Refine implementation
   - Optimize performance
   - Improve readability
   - Add documentation

5. Validate
   - Final testing
   - Edge case verification
   - Performance validation
```

### Debugging Workflow

```markdown
1. Reproduce error
   - Minimal test case
   - Capture error message
   - Identify conditions

2. Investigate cause
   - Check variable states
   - Trace execution flow
   - Review assumptions

3. Test hypothesis
   - Modify specific parts
   - Verify behavior
   - Isolate issue

4. Implement fix
   - Apply solution
   - Test fix
   - Verify no regressions

5. Prevent recurrence
   - Add tests
   - Update validation
   - Document lesson
```

## Integration with Other Tools

### Combined with File Operations

```python
# Read file content
Read: /path/to/data.csv

# Process with code execution
mcp__ide__executeCode:
  code: |
    import pandas as pd
    df = pd.read_csv('/path/to/data.csv')

    # Analyze
    summary = df.describe()
    print(summary)

    # Save results
    summary.to_csv('/path/to/summary.csv')

# Verify output
Read: /path/to/summary.csv
```

### Combined with Search

```python
# Find relevant files
Grep: pattern "class.*Model", glob "**/*.py", output_mode "files_with_matches"

# Execute analysis on found files
mcp__ide__executeCode:
  code: |
    import ast
    import glob

    model_files = glob.glob('**/*model*.py', recursive=True)

    for file in model_files:
        with open(file) as f:
            tree = ast.parse(f.read())
            classes = [node.name for node in ast.walk(tree) if isinstance(node, ast.ClassDef)]
            print(f"{file}: {classes}")
```

### Combined with Git Operations

```python
# Get changed files
Bash: "git diff --name-only HEAD~1"

# Analyze changes
mcp__ide__executeCode:
  code: |
    import subprocess

    # Get diff stats
    result = subprocess.run(
        ['git', 'diff', '--stat', 'HEAD~1'],
        capture_output=True,
        text=True
    )

    print(result.stdout)
```

## Limitations and Considerations

### Execution Constraints

**Time Limits**:
- Long-running operations may timeout
- Consider breaking into smaller steps
- Use progress indicators

**Memory Limits**:
- Large datasets may exceed available memory
- Process data in chunks
- Clean up intermediate results

**Kernel State**:
- State persists across executions
- Variables can be overwritten
- Restart kernel if needed

### Security Considerations

**Code Safety**:
- Avoid executing untrusted code
- Validate inputs before execution
- Limit access to sensitive resources

**Data Privacy**:
- Don't execute code with sensitive data in logs
- Be cautious with API calls
- Manage credentials securely

**Resource Protection**:
- Avoid infinite loops
- Limit network requests
- Manage file system access

### When NOT to Use Code Execution

```markdown
❌ Avoid for:
- Simple string manipulation (use Edit)
- File reading (use Read)
- Code search (use Grep)
- File discovery (use Glob)
- Git operations (use Bash)

✅ Use for:
- Data analysis and visualization
- Algorithm development and testing
- Mathematical computations
- Statistical analysis
- Interactive debugging
- Rapid prototyping
```

## Advanced Patterns

### Parameterized Analysis

```python
# Define reusable analysis function
mcp__ide__executeCode:
  code: |
    def analyze_column(df, column_name):
        """Comprehensive column analysis"""
        col = df[column_name]

        analysis = {
            'dtype': str(col.dtype),
            'missing': col.isna().sum(),
            'unique': col.nunique(),
        }

        if col.dtype in ['int64', 'float64']:
            analysis.update({
                'mean': col.mean(),
                'median': col.median(),
                'std': col.std(),
                'min': col.min(),
                'max': col.max()
            })

        return analysis

# Use function multiple times
mcp__ide__executeCode:
  code: |
    for col in df.columns:
        result = analyze_column(df, col)
        print(f"\n{col}:")
        for key, value in result.items():
            print(f"  {key}: {value}")
```

### Incremental Data Processing

```python
# Process in chunks
mcp__ide__executeCode:
  code: |
    chunk_size = 10000
    results = []

    for chunk in pd.read_csv('large_file.csv', chunksize=chunk_size):
        # Process chunk
        processed = chunk.groupby('category')['value'].mean()
        results.append(processed)

    # Combine results
    final = pd.concat(results).groupby(level=0).mean()
    print(final)
```

### Caching Expensive Operations

```python
mcp__ide__executeCode:
  code: |
    import functools
    import pickle
    from pathlib import Path

    def disk_cache(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            cache_file = Path(f'.cache/{func.__name__}.pkl')

            if cache_file.exists():
                with open(cache_file, 'rb') as f:
                    return pickle.load(f)

            result = func(*args, **kwargs)

            cache_file.parent.mkdir(exist_ok=True)
            with open(cache_file, 'wb') as f:
                pickle.dump(result, f)

            return result
        return wrapper

    @disk_cache
    def expensive_computation(data):
        # Long-running analysis
        return complex_analysis(data)
```

## Jupyter Notebook Integration

### Working with Notebooks

**Reading Notebooks**:
```python
Read: /path/to/notebook.ipynb
# Returns all cells with outputs, code, text, and visualizations
```

**Editing Notebook Cells**:
```python
NotebookEdit:
  notebook_path: /path/to/notebook.ipynb
  cell_id: "cell-123"
  new_source: |
    import pandas as pd
    df = pd.read_csv('data.csv')
    df.head()
```

**Executing in Notebook Context**:
```python
# Code executes in the notebook's kernel
mcp__ide__executeCode:
  code: |
    # Access variables from notebook
    print(f"Dataset has {len(df)} rows")

    # Results available in notebook
    summary = df.describe()
```

### Notebook Workflows

1. **Read** notebook to understand context
2. **Execute** code to test or analyze
3. **Edit** cells to update notebook
4. **Read** again to verify changes

## Best Practices Summary

1. **State Awareness**: Remember kernel state persists
2. **Error Handling**: Always handle potential errors
3. **Resource Cleanup**: Free memory for large objects
4. **Clear Output**: Provide informative messages
5. **Incremental Testing**: Test small pieces before combining
6. **Documentation**: Comment complex logic
7. **Reproducibility**: Make analysis reproducible
8. **Security**: Validate inputs and protect resources

## Quick Reference

### Execute Code
```python
mcp__ide__executeCode:
  code: |
    # Your code here
    print("Hello, World!")
```

### Common Libraries
```python
import pandas as pd          # Data manipulation
import numpy as np           # Numerical computing
import matplotlib.pyplot as plt  # Visualization
from scipy import stats      # Statistical analysis
from sklearn import model_selection  # Machine learning
```

### Error Handling Template
```python
try:
    # Your code
    result = operation()
except SpecificError as e:
    print(f"Expected error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
    import traceback
    traceback.print_exc()
finally:
    # Cleanup
    pass
```

### State Management
```python
# Check what's defined
print(dir())

# Clear variables
del variable_name

# Restart kernel (when needed)
# Use notebook interface or restart Claude Code
```
