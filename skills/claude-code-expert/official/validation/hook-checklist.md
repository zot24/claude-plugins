# Hook Validation Checklist

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/hooks-guide.md
> **Last Updated**: 2025-01-15

## Pre-Creation Validation

### Purpose Definition
- [ ] Hook purpose is clearly defined
- [ ] Hook intercepts appropriate lifecycle event
- [ ] Hook adds clear value to workflow
- [ ] Use cases are documented
- [ ] Impact on user experience is positive

### Event Selection
- [ ] Correct hook event identified
- [ ] Event timing is appropriate
- [ ] Event frequency is acceptable
- [ ] Event context provides needed information
- [ ] Alternative events considered

## Hook Configuration Validation

### File Location
- [ ] Hook in correct directory:
  - `.claude/hooks/` for project hooks
  - `~/.claude/hooks/` for user hooks
  - Plugin directory for plugin hooks
- [ ] File name follows `{event}.{name}.md` pattern
- [ ] Event name is valid (e.g., `beforeStart`, `afterEdit`, etc.)
- [ ] Hook name is descriptive
- [ ] File extension is `.md`

### File Structure
- [ ] YAML frontmatter present
- [ ] Frontmatter delimiters `---` correct
- [ ] Required fields included
- [ ] Valid YAML syntax
- [ ] Markdown content follows frontmatter

## Frontmatter Validation

### Required Fields
- [ ] `name` field present
- [ ] `name` is descriptive and unique
- [ ] `name` uses kebab-case format
- [ ] `description` field present
- [ ] `description` explains hook purpose
- [ ] `description` explains when hook runs

### Optional Fields (if used)
- [ ] `enabled` field is boolean (true/false)
- [ ] `priority` field is numeric (default: 0, higher = earlier)
- [ ] `condition` field contains valid logic
- [ ] `tools` field lists available tool names
- [ ] All field values are correct types

### Hook Priority
- [ ] Priority value is appropriate:
  - Higher (10+) for early execution
  - Default (0) for normal execution
  - Lower (-10) for late execution
- [ ] Priority doesn't conflict with other hooks
- [ ] Priority order tested with multiple hooks

## Hook Prompt Validation

### Structure
- [ ] Clear role/purpose statement
- [ ] Organized with logical sections
- [ ] Instructions are actionable
- [ ] Output format defined
- [ ] Length is appropriate

### Content Quality
- [ ] Instructions are specific to hook event
- [ ] Context from event is utilized
- [ ] Processing steps are clear
- [ ] Edge cases addressed
- [ ] Error handling defined

### Constraints
- [ ] What NOT to do is specified
- [ ] Scope boundaries defined
- [ ] Time constraints noted (if quick hook)
- [ ] Resource limits documented
- [ ] Security constraints included

## Hook Type Validation

### beforeStart Hooks
- [ ] Runs before conversation starts
- [ ] Setup/initialization tasks defined
- [ ] Environment checks performed
- [ ] Dependencies validated
- [ ] Quick execution (doesn't delay start)

### afterEdit Hooks
- [ ] Runs after file edits
- [ ] Receives file path information
- [ ] Receives edit details (old/new content)
- [ ] Processing is efficient
- [ ] Doesn't interfere with editing flow

### beforeToolCall Hooks
- [ ] Runs before tool execution
- [ ] Receives tool name and parameters
- [ ] Validation logic is correct
- [ ] Can prevent tool execution if needed
- [ ] Fast execution to avoid delays

### afterToolCall Hooks
- [ ] Runs after tool execution
- [ ] Receives tool result information
- [ ] Post-processing is appropriate
- [ ] Error handling for failed tools
- [ ] Logging/tracking implemented correctly

### beforeResponse Hooks
- [ ] Runs before Claude responds
- [ ] Context analysis is relevant
- [ ] Response guidance is helpful
- [ ] Quick execution required
- [ ] Doesn't delay user experience

### afterResponse Hooks
- [ ] Runs after Claude responds
- [ ] Response analysis is valuable
- [ ] Follow-up actions are appropriate
- [ ] Async operations considered
- [ ] User experience not degraded

## Functional Validation

### Event Context
- [ ] Hook accesses available context correctly
- [ ] Context data is validated before use
- [ ] Missing context is handled gracefully
- [ ] Context is not modified inappropriately
- [ ] Context usage is documented

### Tool Usage
- [ ] Appropriate tools are specified
- [ ] Tools are used correctly
- [ ] Tool restrictions are enforced
- [ ] Tool errors are handled
- [ ] Tool calls are optimized

### Condition Logic (if applicable)
- [ ] Condition expression is valid
- [ ] Condition accurately determines when to run
- [ ] Condition edge cases handled
- [ ] Condition doesn't cause errors
- [ ] Condition performance is acceptable

## Performance Validation

### Execution Speed
- [ ] Hook executes quickly
- [ ] No blocking operations
- [ ] Async operations used appropriately
- [ ] Timeout handling implemented
- [ ] Performance impact measured

### Resource Usage
- [ ] Memory usage is reasonable
- [ ] File operations are minimal
- [ ] API calls are necessary
- [ ] No resource leaks
- [ ] Cleanup is performed

### Frequency Impact
- [ ] Hook frequency is acceptable
- [ ] High-frequency hooks are optimized
- [ ] Caching used when appropriate
- [ ] Redundant operations eliminated
- [ ] Batch processing considered

## Testing Validation

### Unit Testing
- [ ] Test hook activation
- [ ] Test with expected context
- [ ] Test with missing context
- [ ] Test with invalid context
- [ ] Test condition logic (if applicable)
- [ ] Test tool interactions
- [ ] Test error scenarios

### Integration Testing
- [ ] Test with real events
- [ ] Test with multiple hooks
- [ ] Test hook priority ordering
- [ ] Test with other lifecycle components
- [ ] Test end-to-end workflow
- [ ] Test performance impact

### User Experience Testing
- [ ] Hook doesn't interrupt workflow
- [ ] Hook adds value to experience
- [ ] Hook notifications are appropriate
- [ ] Hook errors don't break functionality
- [ ] Hook can be disabled easily

## Security Validation

### Access Control
- [ ] File access is scoped correctly
- [ ] Tool permissions are appropriate
- [ ] External access is controlled
- [ ] User data access is validated
- [ ] Sensitive operations protected

### Data Safety
- [ ] No sensitive data exposed
- [ ] Logging doesn't leak information
- [ ] Temporary data is cleaned up
- [ ] Data validation performed
- [ ] Injection attacks prevented

### Code Safety
- [ ] No arbitrary code execution
- [ ] Input sanitization applied
- [ ] Output validation performed
- [ ] Error messages don't leak details
- [ ] Dependencies are trusted

## Output Validation

### Output Format
- [ ] Format is consistent
- [ ] Format is appropriate for hook type
- [ ] Format is documented
- [ ] Format is parseable (if needed)
- [ ] Format includes necessary context

### Output Quality
- [ ] Output is accurate
- [ ] Output is relevant
- [ ] Output is actionable
- [ ] Output is concise
- [ ] Output provides value

### User Notifications
- [ ] Notifications are appropriate
- [ ] Notification verbosity is correct
- [ ] Important information highlighted
- [ ] Errors are clearly communicated
- [ ] Success confirmations provided

## Error Handling Validation

### Error Detection
- [ ] Expected errors identified
- [ ] Unexpected errors caught
- [ ] Error conditions tested
- [ ] Error messages are clear
- [ ] Error severity appropriate

### Error Recovery
- [ ] Graceful degradation implemented
- [ ] Fallback behavior defined
- [ ] Retry logic appropriate (if applicable)
- [ ] User notified of errors
- [ ] Errors don't break workflow

### Error Logging
- [ ] Errors are logged appropriately
- [ ] Log level is correct
- [ ] Stack traces available (when needed)
- [ ] Logs don't expose sensitive data
- [ ] Logs aid debugging

## Documentation Validation

### User Documentation
- [ ] Purpose clearly explained
- [ ] Trigger conditions documented
- [ ] Expected behavior described
- [ ] Configuration options explained
- [ ] Examples provided

### Developer Documentation
- [ ] Implementation details documented
- [ ] Context structure explained
- [ ] Tool usage patterns described
- [ ] Extension points identified
- [ ] Testing approach documented

### Troubleshooting Documentation
- [ ] Common issues listed
- [ ] Solutions provided
- [ ] Debug steps outlined
- [ ] Logs to check specified
- [ ] Support contacts listed

## Integration Validation

### Hook Coordination
- [ ] Works independently
- [ ] Coordinates with other hooks
- [ ] Priority order is correct
- [ ] No conflicts with other hooks
- [ ] Handoff points defined (if applicable)

### System Integration
- [ ] Compatible with Claude Code version
- [ ] Works with all supported tools
- [ ] MCP integration works (if applicable)
- [ ] Plugin compatibility verified
- [ ] OS compatibility confirmed

### Workflow Integration
- [ ] Fits into user workflows naturally
- [ ] Doesn't disrupt existing patterns
- [ ] Enhances productivity
- [ ] Can be disabled without issues
- [ ] Configuration is straightforward

## Maintenance Validation

### Versioning
- [ ] Version tracked in comments or metadata
- [ ] Changes documented
- [ ] Breaking changes noted
- [ ] Migration path provided (if needed)
- [ ] Deprecation communicated (if applicable)

### Updates
- [ ] Update process documented
- [ ] Backward compatibility considered
- [ ] Testing requirements defined
- [ ] User communication planned
- [ ] Rollback procedure available

### Monitoring
- [ ] Usage tracked (if appropriate)
- [ ] Errors monitored
- [ ] Performance tracked
- [ ] User feedback collected
- [ ] Improvement opportunities identified

## Quality Gates

### Minimum Viable Hook (MVH)
- [x] Valid frontmatter
- [x] Basic prompt content
- [x] Correct file naming
- [x] Can be activated
- [x] Produces output

### Production Ready
- [x] All MVH criteria met
- [x] Comprehensive prompt
- [x] Error handling implemented
- [x] Performance validated
- [x] Documentation complete
- [x] Testing performed
- [x] Security reviewed

### Excellence Standard
- [x] All production ready criteria met
- [x] Optimized performance
- [x] Graceful error handling
- [x] Comprehensive testing
- [x] User feedback incorporated
- [x] Maintains quality over time

## Hook-Specific Validation

### beforeStart Hooks
- [ ] Environment setup complete
- [ ] Configuration validated
- [ ] Dependencies checked
- [ ] Fast execution (<1s)
- [ ] No blocking operations

### afterEdit Hooks
- [ ] File path validation
- [ ] Edit context utilized
- [ ] Processing is efficient
- [ ] No interference with editing
- [ ] Useful post-processing

### beforeToolCall Hooks
- [ ] Tool validation logic correct
- [ ] Parameter checking thorough
- [ ] Can prevent execution if needed
- [ ] Fast validation (<100ms)
- [ ] Clear validation messages

### afterToolCall Hooks
- [ ] Result processing appropriate
- [ ] Error results handled
- [ ] Success results utilized
- [ ] Logging is useful
- [ ] No performance impact

### beforeResponse Hooks
- [ ] Context analysis valuable
- [ ] Response guidance helpful
- [ ] Very fast execution (<50ms)
- [ ] No delay to user
- [ ] Improves response quality

### afterResponse Hooks
- [ ] Response analysis useful
- [ ] Follow-up actions appropriate
- [ ] Async processing used (if slow)
- [ ] User experience preserved
- [ ] Adds value to workflow

## Common Issues Checklist

### Configuration Issues
- [ ] No YAML syntax errors
- [ ] File naming correct
- [ ] Required fields present
- [ ] Field types correct
- [ ] Paths are valid

### Performance Issues
- [ ] No slow operations
- [ ] No blocking calls
- [ ] Caching implemented (if needed)
- [ ] Async operations used (if needed)
- [ ] Resource cleanup performed

### Logic Issues
- [ ] Condition logic correct
- [ ] Error handling complete
- [ ] Edge cases covered
- [ ] No infinite loops
- [ ] Exit conditions defined

### Integration Issues
- [ ] Event context accessed correctly
- [ ] Tools used properly
- [ ] No conflicts with other hooks
- [ ] Priority order correct
- [ ] Dependencies available

## Pre-Deployment Checklist

### Final Review
- [ ] All validation sections completed
- [ ] All tests passing
- [ ] Documentation reviewed
- [ ] Security audit completed
- [ ] Performance benchmarks met

### Deployment Preparation
- [ ] Location confirmed
- [ ] Backup created
- [ ] Team notified
- [ ] Configuration documented
- [ ] Support plan ready

### Post-Deployment
- [ ] Hook active
- [ ] Monitoring in place
- [ ] Feedback mechanism ready
- [ ] First activations validated
- [ ] Team informed

## Monitoring Checklist

### Operational Monitoring
- [ ] Activation frequency tracked
- [ ] Execution time monitored
- [ ] Error rate measured
- [ ] Resource usage tracked
- [ ] User impact assessed

### Quality Monitoring
- [ ] Output quality validated
- [ ] Error patterns identified
- [ ] Performance trends tracked
- [ ] User satisfaction measured
- [ ] Improvement opportunities noted

### Alert Configuration
- [ ] Error rate alerts set
- [ ] Performance degradation alerts
- [ ] Unusual activity alerts
- [ ] Failure alerts configured
- [ ] Notification recipients defined

## Quick Validation

### 30-Second Check
1. Valid YAML frontmatter?
2. Correct file naming?
3. Hook event is valid?
4. Basic prompt present?

### 5-Minute Check
1. 30-second check passed?
2. All required fields present?
3. Instructions are clear?
4. Can activate successfully?
5. Performance is acceptable?

### 30-Minute Check
1. 5-minute check passed?
2. Comprehensive testing done?
3. Error handling works?
4. Documentation complete?
5. Security reviewed?
6. Integration tested?
7. User experience validated?

## Validation Status Template

```markdown
# Hook Validation Report

**Hook Name**: [event].[name]
**Event Type**: [beforeStart/afterEdit/etc]
**Validation Date**: [date]
**Validator**: [name]

## Status Summary
- [ ] Passed MVH criteria
- [ ] Passed Production Ready criteria
- [ ] Passed Excellence Standard criteria

## Configuration
- File Location: [Pass/Fail]
- Frontmatter: [Pass/Fail]
- Prompt: [Pass/Fail]
- Condition: [Pass/Fail] or N/A

## Performance
- Execution Time: [Xms]
- Resource Usage: [Low/Medium/High]
- Impact on Workflow: [Minimal/Moderate/Significant]

## Testing Results
- Unit Tests: [Pass/Fail]
- Integration Tests: [Pass/Fail]
- Performance Tests: [Pass/Fail]
- UX Tests: [Pass/Fail]

## Issues Found
1. [Issue 1]
2. [Issue 2]

## Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## Overall Assessment
[Pass/Fail/Needs Revision]

## Next Steps
- [ ] [Action 1]
- [ ] [Action 2]
```

## Best Practices Summary

### Design
- [ ] Single responsibility per hook
- [ ] Minimal scope and impact
- [ ] Fast execution
- [ ] Graceful failure
- [ ] Clear documentation

### Implementation
- [ ] Efficient code
- [ ] Proper error handling
- [ ] Resource cleanup
- [ ] Logging appropriate
- [ ] Testing comprehensive

### Deployment
- [ ] Gradual rollout
- [ ] Monitoring active
- [ ] Feedback collected
- [ ] Issues addressed quickly
- [ ] Continuous improvement

## Prompt-Based Hook Validation (v2.1.0+)

### Prompt Configuration
- [ ] `type` field is `"prompt"`
- [ ] `prompt` field contains clear instructions
- [ ] Prompt includes expected response format (APPROVE/BLOCK)
- [ ] Variable substitution uses correct syntax ($FILE_PATH, $TOOL_INPUT, etc.)
- [ ] `timeout` is appropriate for prompt complexity
- [ ] `model` selection matches task complexity (haiku/sonnet/opus)

### Prompt Quality
- [ ] Instructions are specific and actionable
- [ ] Response format is clearly defined
- [ ] Edge cases are addressed in prompt
- [ ] Security considerations included
- [ ] Prompt is not overly verbose (token efficiency)

### Prompt Performance
- [ ] Timeout is sufficient but not excessive
- [ ] Model choice balances speed vs accuracy
- [ ] Fast-path command hook added for common cases
- [ ] Caching considered for repeated evaluations

## Agent Hook Validation (v2.1.0+)

### Agent Configuration
- [ ] `type` field is `"agent"`
- [ ] `agent` field references existing subagent
- [ ] Referenced agent exists in `.claude/agents/`
- [ ] Agent has required tools for the task
- [ ] `timeout` is sufficient for agent complexity (60-120s typical)
- [ ] Additional `prompt` context provided if needed

### Agent Integration
- [ ] Agent can access required context
- [ ] Agent output is actionable
- [ ] Agent errors are handled gracefully
- [ ] Agent doesn't duplicate main conversation work
- [ ] Agent scope is appropriate (not too broad)

### Agent Performance
- [ ] Agent is only invoked when necessary
- [ ] Simpler hook type considered first (command → prompt → agent)
- [ ] Agent timeout matches expected execution time
- [ ] Agent results don't block user experience excessively

## PermissionRequest Hook Validation (v2.1.0+)

### Configuration
- [ ] Event is `PermissionRequest`
- [ ] Matcher targets specific tools (not overly broad)
- [ ] Response is one of: ALLOW, DENY, ASK
- [ ] Logic for response decision is sound

### Security
- [ ] ALLOW is not granted too broadly
- [ ] Dangerous operations default to ASK or DENY
- [ ] User override capability preserved
- [ ] Audit logging considered for ALLOW decisions

## Advanced Pattern Validation

### once: true Hooks
- [ ] `once: true` used only for initialization tasks
- [ ] Hook idempotent if accidentally run twice
- [ ] Session state doesn't depend on hook running exactly once

### Frontmatter Scoped Hooks
- [ ] `paths` patterns are specific (not `**/*`)
- [ ] `exclude` patterns cover test files if appropriate
- [ ] Path patterns tested with sample files
- [ ] Priority doesn't conflict with other hooks

### Multi-Stage Validation
- [ ] Stages are ordered correctly (fast → slow)
- [ ] Early stages can short-circuit expensive checks
- [ ] State is passed correctly between stages
- [ ] Failure in any stage handled appropriately

### Hook Chaining
- [ ] State file paths are absolute or consistent
- [ ] State cleanup occurs in appropriate event (SessionEnd)
- [ ] Race conditions considered for concurrent hooks
- [ ] State file permissions are appropriate
