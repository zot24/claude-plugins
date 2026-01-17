# Model Capabilities Reference

> **Source**: Official Claude Code Documentation & Anthropic
> **Source URL**: https://code.claude.com/docs/en/overview.md
> **Last Updated**: 2025-01-15

## Overview

Claude Code supports multiple Claude models, each with distinct capabilities and performance characteristics. This guide helps you understand which model to use for different scenarios.

## Core Model Comparison

| Capability | Sonnet 4.5 | Opus | Haiku |
|-----------|-----------|------|-------|
| **Speed** | Fast | Slower | Fastest |
| **Cost** | Medium | Highest | Lowest |
| **Reasoning** | Excellent | Superior | Good |
| **Coding** | Excellent | Excellent | Good |
| **Context Window** | 200K | 200K | 200K |
| **Multimodal** | ✅ Images | ✅ Images | ✅ Images |
| **Extended Thinking** | ✅ | ✅ | ✅ |

## Model-Specific Capabilities

### Claude Sonnet 4.5

**Strengths**:
- **Balanced performance**: Optimal speed-to-capability ratio
- **Code generation**: Excellent at writing and understanding code
- **Tool use**: Highly effective with Read, Write, Edit, Grep, Glob, Bash
- **Reasoning**: Strong analytical and problem-solving abilities
- **Context retention**: Excellent memory across long conversations
- **Latest features**: First to receive new capabilities

**Optimal Use Cases**:
- General software development
- Code reviews and refactoring
- API integration and testing
- Database query optimization
- Documentation generation
- Multi-file edits
- Agent orchestration
- Production deployments

**Performance Characteristics**:
- Response time: ~2-5 seconds for typical requests
- Token generation: ~40-60 tokens/second
- Context utilization: Efficient with large codebases
- Tool calling: Fast and accurate

### Claude Opus

**Strengths**:
- **Maximum capability**: Best for complex, nuanced tasks
- **Deep reasoning**: Superior analysis and planning
- **Complex code**: Handles intricate architectural decisions
- **Accuracy**: Highest correctness on difficult problems
- **Comprehensive**: Thorough and detailed responses

**Optimal Use Cases**:
- Critical security audits
- Complex system architecture design
- Research and advanced analysis
- High-stakes decisions
- Novel problem-solving
- Advanced algorithm design
- Compliance and regulatory review
- Mission-critical systems

**Performance Characteristics**:
- Response time: ~5-10 seconds for typical requests
- Token generation: ~30-40 tokens/second
- Context utilization: Most thorough analysis
- Tool calling: Highly accurate, more deliberate

**Trade-offs**:
- Higher latency than Sonnet
- Higher cost per request
- May provide more detail than needed for simple tasks

### Claude Haiku

**Strengths**:
- **Speed**: Fastest response times
- **Efficiency**: Lowest cost per request
- **Straightforward tasks**: Excellent for well-defined operations
- **High throughput**: Ideal for batch operations
- **Quick iterations**: Rapid feedback cycles

**Optimal Use Cases**:
- Simple code edits
- Format conversions
- Repetitive refactors
- Straightforward bug fixes
- Quick questions
- Batch file processing
- Cost-sensitive applications
- Development iteration

**Performance Characteristics**:
- Response time: ~1-2 seconds for typical requests
- Token generation: ~60-80 tokens/second
- Context utilization: Efficient for focused tasks
- Tool calling: Fast and effective for simple operations

**Trade-offs**:
- Less capable on complex reasoning
- May need more explicit instructions
- Better for well-defined tasks

## Capability Categories

### Code Understanding

**Sonnet 4.5**: ⭐⭐⭐⭐⭐
- Excellent comprehension of complex codebases
- Strong pattern recognition
- Good architectural understanding

**Opus**: ⭐⭐⭐⭐⭐
- Superior deep code analysis
- Best for understanding intricate systems
- Exceptional at finding subtle issues

**Haiku**: ⭐⭐⭐⭐
- Good for standard code patterns
- Effective for straightforward analysis
- Best with clear, well-structured code

### Code Generation

**Sonnet 4.5**: ⭐⭐⭐⭐⭐
- Excellent code quality
- Good design patterns
- Efficient implementations

**Opus**: ⭐⭐⭐⭐⭐
- Highest quality output
- Best architectural decisions
- Most robust error handling

**Haiku**: ⭐⭐⭐⭐
- Good code for simple tasks
- Fast generation
- May need more guidance for complex tasks

### Debugging

**Sonnet 4.5**: ⭐⭐⭐⭐⭐
- Excellent root cause analysis
- Effective error diagnosis
- Good fix suggestions

**Opus**: ⭐⭐⭐⭐⭐
- Superior at complex bugs
- Best for subtle issues
- Most thorough analysis

**Haiku**: ⭐⭐⭐⭐
- Good for straightforward bugs
- Quick identification
- Effective for common patterns

### Refactoring

**Sonnet 4.5**: ⭐⭐⭐⭐⭐
- Excellent refactoring suggestions
- Good balance of quality and speed
- Effective for most scenarios

**Opus**: ⭐⭐⭐⭐⭐
- Best for major refactors
- Superior architectural improvements
- Most comprehensive approaches

**Haiku**: ⭐⭐⭐⭐
- Good for simple refactors
- Fast execution
- Effective for targeted changes

### Testing

**Sonnet 4.5**: ⭐⭐⭐⭐⭐
- Excellent test generation
- Good edge case coverage
- Effective test strategies

**Opus**: ⭐⭐⭐⭐⭐
- Most comprehensive test suites
- Best edge case identification
- Superior test architecture

**Haiku**: ⭐⭐⭐⭐
- Good for standard tests
- Fast test generation
- Effective for happy paths

## Tool Usage Capabilities

### Read Tool Proficiency

**All Models**: Excellent
- All models effectively read and comprehend files
- Sonnet 4.5 and Opus better at synthesizing across many files
- Haiku efficient for focused file reads

### Write Tool Proficiency

**All Models**: Excellent
- All models create well-structured files
- Opus provides most thorough documentation
- Haiku fastest for simple file creation

### Edit Tool Proficiency

**All Models**: Excellent
- All models make precise edits
- Sonnet 4.5 best balance for most edits
- Opus best for critical changes
- Haiku fastest for simple replacements

### Grep Tool Proficiency

**All Models**: Excellent
- All models construct effective search patterns
- Sonnet 4.5 and Opus better at complex regex
- Haiku effective for straightforward searches

### Glob Tool Proficiency

**All Models**: Excellent
- All models use glob patterns effectively
- Minimal difference between models

### Bash Tool Proficiency

**Sonnet 4.5**: Excellent
- Strong command construction
- Good error handling
- Effective chaining

**Opus**: Excellent
- Most robust command construction
- Best error prevention
- Superior safety considerations

**Haiku**: Very Good
- Effective for standard commands
- May need more explicit guidance
- Good for well-known patterns

## MCP Integration Capabilities

**All Models**: Full MCP support
- All models can use MCP servers effectively
- Opus may provide more thorough integrations
- Haiku fastest for simple MCP operations
- Sonnet 4.5 best balance for most MCP workflows

## Extended Thinking

**All Models Support Extended Thinking**:
- Activated with Tab key or "thinking keywords"
- Enables deeper analysis before responding
- Particularly valuable for:
  - Complex architectural decisions
  - Intricate debugging
  - Novel problem-solving
  - Planning multi-step implementations

**Model Behavior with Extended Thinking**:
- **Opus**: Most comprehensive thinking, deepest analysis
- **Sonnet 4.5**: Thorough thinking, excellent balance
- **Haiku**: Focused thinking, efficient analysis

## Multimodal Capabilities

**All Models**: Image understanding
- Screenshots for UI/UX feedback
- Diagrams for architectural discussions
- Error screenshots for debugging
- Mockups for design implementation
- Charts and graphs for data analysis

**Best Practices**:
- Use Sonnet 4.5 or Opus for complex visual analysis
- Haiku effective for straightforward image tasks

## Context Management

**All Models**: 200K token context window

**Context Utilization**:
- **Opus**: Most thorough use of available context
- **Sonnet 4.5**: Efficient context utilization
- **Haiku**: Focused context use

**Best Practices**:
- All models benefit from progressive information disclosure
- Use @ references for quick file inclusion
- Leverage Read tool for selective file access
- Employ subagents for context isolation

## Agent and Skill Support

**All Models**: Full agent and skill support

**Agent Performance**:
- **Opus**: Best for complex agent workflows
- **Sonnet 4.5**: Optimal for most agent scenarios
- **Haiku**: Effective for simple agent tasks

**Skill Execution**:
- All models auto-invoke skills based on descriptions
- Sonnet 4.5 and Opus better at nuanced skill selection
- Haiku effective for clearly defined skill triggers

## Model Selection Decision Tree

```
Task Complexity?
├─ Simple, well-defined
│  └─ Speed critical? → Haiku
│     Cost critical? → Haiku
│     Otherwise → Sonnet 4.5
│
├─ Medium complexity
│  └─ Always → Sonnet 4.5
│
└─ High complexity
   ├─ Critical accuracy? → Opus
   ├─ Novel problem? → Opus
   ├─ High stakes? → Opus
   └─ Otherwise → Sonnet 4.5 with Extended Thinking
```

## Cost Optimization Strategies

### Use Haiku For:
- Formatting and linting
- Simple refactors
- Straightforward questions
- Batch operations
- Development iterations

### Use Sonnet 4.5 For:
- Most development tasks
- Code reviews
- Feature implementation
- Bug fixing
- General agent workflows

### Use Opus For:
- Security audits
- Critical decisions
- Complex architecture
- High-stakes situations
- When accuracy is paramount

## Performance Optimization

### Maximize Speed
1. Use Haiku for simple tasks
2. Use clear, specific prompts
3. Limit file inclusions
4. Use parallel tool calls

### Maximize Quality
1. Use Opus for critical tasks
2. Enable Extended Thinking
3. Provide comprehensive context
4. Use iterative refinement

### Balance Both
1. Use Sonnet 4.5 as default
2. Reserve Opus for complex decisions
3. Use Haiku for quick iterations
4. Match model to task complexity

## Model Configuration

### In Agents
```yaml
---
model: sonnet  # or opus, haiku
---
```

### In Skills
```yaml
---
model: haiku  # for frequent, simple operations
---
```

### In Commands
```yaml
---
model: opus  # for critical operations
---
```

### Inheritance
Omit model field to use parent conversation's model.

## Best Practices Summary

1. **Default to Sonnet 4.5**: Best balance for most scenarios
2. **Use Haiku for speed**: Simple, repetitive, or high-volume tasks
3. **Use Opus for quality**: Critical, complex, or high-stakes work
4. **Match model to task**: Consider complexity, stakes, and budget
5. **Enable Extended Thinking**: For complex reasoning regardless of model
6. **Test different models**: Performance varies by specific use case
7. **Monitor costs**: Track usage and optimize model selection

## Limitations and Considerations

### All Models
- Knowledge cutoff: January 2025
- Cannot browse internet (use MCP for external data)
- Cannot modify files outside Claude Code permissions
- Subject to rate limits based on usage tier

### Model-Specific
- **Opus**: Higher latency and cost
- **Haiku**: Less capable on highly complex tasks
- **Sonnet 4.5**: May occasionally need Opus for maximum accuracy

---

**For latest capabilities**: https://code.claude.com/docs
**For model updates**: https://www.anthropic.com/engineering
