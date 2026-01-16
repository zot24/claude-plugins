# Skill Validation Checklist

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/skills.md
> **Last Updated**: 2025-01-15

## Pre-Creation Validation

### Purpose Definition
- [ ] Skill purpose is clearly defined
- [ ] Skill solves specific problem or workflow
- [ ] Skill is distinct from existing skills
- [ ] Use cases are documented
- [ ] Value proposition is clear

### Scope Analysis
- [ ] Skill scope is appropriate (not too broad or narrow)
- [ ] Required expertise identified
- [ ] Expected workflows mapped
- [ ] Success criteria established
- [ ] Performance requirements defined

## Skill Metadata Validation

### JSON Configuration
- [ ] File extension is `.json`
- [ ] Valid JSON syntax
- [ ] All required fields present
- [ ] Field values have correct types
- [ ] No extraneous fields

### Required Fields
- [ ] `name` field present and unique
- [ ] `name` uses kebab-case format
- [ ] `description` field present
- [ ] `description` is clear and concise
- [ ] `description` explains when to invoke skill
- [ ] `location` field specifies "managed" or "plugin"

### Trigger Configuration
- [ ] `trigger` object present
- [ ] `type` field specifies trigger mechanism
- [ ] Trigger patterns are specific enough
- [ ] Trigger patterns are not too restrictive
- [ ] Multiple trigger patterns provided when appropriate

### State Management (if applicable)
- [ ] `persistentState` field configured correctly
- [ ] State schema defined
- [ ] State initialization handled
- [ ] State persistence verified
- [ ] State cleanup considered

### SKILL.md Frontmatter (Optional Fields)
- [ ] `model` field uses valid value (`sonnet`, `opus`, `haiku`) if specified
- [ ] `model` choice appropriate for skill's operational profile:
  - Haiku: high-frequency skills, simple operations, repetitive tasks, cost-sensitive
  - Sonnet: moderate-frequency skills, balanced analysis, most monitoring/tracking (default)
  - Opus: low-frequency skills, critical operations, security audits, high-stakes decisions
- [ ] Skill invocation frequency considered in model selection
- [ ] Error impact assessed and matched to model capability
- [ ] Auto-invoke frequency analyzed for cost implications (Haiku for frequent auto-invokes)
- [ ] `allowed-tools` restricts tools appropriately if specified
- [ ] `context_persistence` set correctly for stateful skills
- [ ] `auto_invoke` and `triggers` configured for automatic activation

## Skill Prompt Validation

### Structure
- [ ] Markdown file exists matching skill name
- [ ] File organization is logical
- [ ] Headers create clear sections
- [ ] Content flows naturally
- [ ] Length is appropriate for complexity

### Content Sections
- [ ] **Purpose**: Why this skill exists
- [ ] **Triggers**: When skill activates
- [ ] **Responsibilities**: What skill does
- [ ] **Workflow**: Step-by-step process
- [ ] **State Management**: If skill is stateful
- [ ] **Tool Usage**: Which tools to use
- [ ] **Output Format**: Expected deliverables
- [ ] **Examples**: Concrete demonstrations

### Instructions Quality
- [ ] Instructions are actionable
- [ ] Steps are in logical order
- [ ] Conditions are clearly specified
- [ ] Alternatives are provided where relevant
- [ ] Edge cases are addressed

### Constraints
- [ ] What NOT to do is specified
- [ ] Limitations documented
- [ ] Boundaries clearly defined
- [ ] Security constraints included
- [ ] Performance considerations noted

## File Organization Validation

### Directory Structure
- [ ] Skill located in correct directory:
  - `.claude/skills/{skill-name}/` for project skills
  - `~/.claude/skills/{skill-name}/` for user skills
  - Plugin directory for plugin skills
- [ ] Directory name matches skill name
- [ ] JSON config file present
- [ ] Markdown prompt file present
- [ ] Supporting files organized logically

### Supporting Documentation
- [ ] README explaining skill purpose (if complex)
- [ ] Examples directory (if applicable)
- [ ] Templates directory (if applicable)
- [ ] Reference data organized properly
- [ ] Version information included

### File Permissions
- [ ] Files have correct read permissions
- [ ] No unnecessary write permissions
- [ ] Directory structure is accessible
- [ ] Files are in version control (if project skill)

## Trigger Validation

### Trigger Types
- [ ] Trigger type is appropriate for use case
- [ ] Trigger patterns are well-defined
- [ ] Trigger priority is set correctly
- [ ] Trigger conflicts checked with other skills
- [ ] Fallback triggers defined if needed

### Pattern Matching
- [ ] Patterns match intended scenarios
- [ ] Patterns don't match unintended scenarios
- [ ] Case sensitivity considered
- [ ] Regex patterns tested (if used)
- [ ] Keyword coverage is complete

### User Experience
- [ ] Skill activates when expected
- [ ] Skill doesn't activate unexpectedly
- [ ] Activation is timely
- [ ] User can override if needed
- [ ] Activation message is clear

## State Management Validation

### State Schema
- [ ] State structure is well-defined
- [ ] Required state fields identified
- [ ] Optional state fields documented
- [ ] Default values specified
- [ ] State versioning considered

### State Persistence
- [ ] State saves correctly
- [ ] State loads correctly
- [ ] State updates are atomic
- [ ] State corruption handled
- [ ] State migration path exists (if needed)

### State Access
- [ ] Read operations are safe
- [ ] Write operations are validated
- [ ] Concurrent access handled
- [ ] State cleanup implemented
- [ ] State size monitored

## Workflow Validation

### Process Flow
- [ ] Workflow steps are clearly defined
- [ ] Decision points are explicit
- [ ] Branching logic is correct
- [ ] Loop conditions are safe
- [ ] Exit conditions are defined

### Phase Management
- [ ] Phases are logically separated
- [ ] Phase transitions are clear
- [ ] Phase state is tracked
- [ ] Phase completion is verified
- [ ] Phase rollback is possible (if needed)

### Error Handling
- [ ] Error conditions identified
- [ ] Error recovery steps defined
- [ ] User notification on errors
- [ ] Graceful degradation implemented
- [ ] Critical vs non-critical errors distinguished

## Tool Integration Validation

### Tool Selection
- [ ] Required tools identified
- [ ] Tool restrictions appropriate
- [ ] Tool usage patterns documented
- [ ] Tool sequence optimized
- [ ] Tool alternatives considered

### Tool Usage
- [ ] Tools used correctly
- [ ] Parallel operations utilized
- [ ] Sequential dependencies respected
- [ ] Error handling for tool failures
- [ ] Tool output validated

### MCP Integration
- [ ] Required MCP servers documented
- [ ] MCP tool access configured
- [ ] MCP resources utilized appropriately
- [ ] MCP prompts integrated if relevant
- [ ] MCP failures handled gracefully

## Output Validation

### Format Consistency
- [ ] Output format is well-defined
- [ ] Format is consistent across invocations
- [ ] Format is machine-readable (if needed)
- [ ] Format is human-readable
- [ ] Format examples provided

### Content Quality
- [ ] Output is complete
- [ ] Output is accurate
- [ ] Output is relevant
- [ ] Output is actionable
- [ ] Output includes context

### Deliverables
- [ ] All promised deliverables produced
- [ ] Deliverables are well-organized
- [ ] Deliverables are properly formatted
- [ ] Deliverables are accessible
- [ ] Deliverables are documented

## Testing Validation

### Unit Testing
- [ ] Test skill activation
- [ ] Test each workflow phase
- [ ] Test state transitions
- [ ] Test error conditions
- [ ] Test edge cases
- [ ] Test tool interactions
- [ ] Test output generation

### Integration Testing
- [ ] Test with real project data
- [ ] Test with other skills
- [ ] Test with agents
- [ ] Test state persistence across sessions
- [ ] Test MCP integration
- [ ] Test performance under load

### User Acceptance Testing
- [ ] Test with target users
- [ ] Verify solves intended problem
- [ ] Collect usability feedback
- [ ] Validate output quality
- [ ] Confirm value delivery

## Performance Validation

### Execution Performance
- [ ] Activation time is acceptable
- [ ] Execution time is reasonable
- [ ] Token usage is optimized
- [ ] Tool calls are minimized
- [ ] No unnecessary operations

### Resource Usage
- [ ] Memory usage is appropriate
- [ ] File I/O is optimized
- [ ] API calls are efficient
- [ ] State size is managed
- [ ] Cleanup is performed

### Scalability
- [ ] Works with small projects
- [ ] Handles large projects
- [ ] Scales with data size
- [ ] Performs under concurrent use
- [ ] Degrades gracefully

## Security Validation

### Access Control
- [ ] File access is scoped correctly
- [ ] Tool permissions are appropriate
- [ ] MCP access is limited properly
- [ ] External API access is controlled
- [ ] User data access is validated

### Data Protection
- [ ] No hardcoded secrets
- [ ] Sensitive data is protected
- [ ] Credentials are handled securely
- [ ] Audit trail maintained
- [ ] Data retention policies followed

### Code Safety
- [ ] No destructive operations without confirmation
- [ ] Input validation performed
- [ ] Output sanitization applied
- [ ] Injection attacks prevented
- [ ] External dependencies verified

## Documentation Validation

### User Documentation
- [ ] Clear description of purpose
- [ ] Usage instructions provided
- [ ] Examples included
- [ ] Common scenarios covered
- [ ] Troubleshooting guide available

### Developer Documentation
- [ ] Architecture documented
- [ ] State schema explained
- [ ] Workflow diagrams provided
- [ ] Integration points documented
- [ ] Extension points identified

### Maintenance Documentation
- [ ] Update procedures documented
- [ ] Testing procedures defined
- [ ] Monitoring guidelines provided
- [ ] Debugging tips included
- [ ] Support contacts listed

## Integration Validation

### Skill Coordination
- [ ] Works independently
- [ ] Coordinates with related skills
- [ ] No conflicts with other skills
- [ ] Handoff points defined
- [ ] Complementary functionality identified

### Agent Compatibility
- [ ] Can be invoked from agents
- [ ] Agents can use skill tools
- [ ] State visible to agents (if needed)
- [ ] Agent coordination patterns defined

### Plugin Integration
- [ ] Plugin dependencies documented
- [ ] Plugin versions specified
- [ ] Plugin features utilized correctly
- [ ] Plugin failures handled
- [ ] Plugin updates considered

## Versioning Validation

### Version Management
- [ ] Version number included
- [ ] Semantic versioning used
- [ ] Change log maintained
- [ ] Breaking changes documented
- [ ] Migration guides provided

### Backward Compatibility
- [ ] State migration handled
- [ ] API changes managed
- [ ] Deprecation warnings added
- [ ] Sunset timeline communicated
- [ ] Legacy support considered

### Update Process
- [ ] Update procedure documented
- [ ] Testing requirements defined
- [ ] Rollback plan available
- [ ] User communication planned
- [ ] Gradual rollout strategy

## Quality Gates

### Minimum Viable Skill (MVS)
- [x] Valid JSON configuration
- [x] Basic markdown prompt
- [x] Can be activated
- [x] Produces output
- [x] Handles basic scenarios

### Production Ready
- [x] All MVS criteria met
- [x] Comprehensive workflow
- [x] Error handling implemented
- [x] Documentation complete
- [x] Testing performed
- [x] Security reviewed
- [x] Performance validated

### Excellence Standard
- [x] All production ready criteria met
- [x] State management robust
- [x] Edge cases handled
- [x] Performance optimized
- [x] User feedback incorporated
- [x] Maintains quality over time

## Common Issues Checklist

### Configuration Issues
- [ ] No JSON syntax errors
- [ ] All required fields present
- [ ] Field types correct
- [ ] Paths are valid
- [ ] Names are unique

### Workflow Issues
- [ ] No infinite loops
- [ ] All branches tested
- [ ] Exit conditions defined
- [ ] State transitions valid
- [ ] Error paths work

### State Issues
- [ ] State schema complete
- [ ] Persistence works
- [ ] No state leaks
- [ ] Migrations tested
- [ ] Cleanup implemented

### Integration Issues
- [ ] Tools available
- [ ] MCP servers accessible
- [ ] Dependencies installed
- [ ] Permissions adequate
- [ ] Versions compatible

## Pre-Deployment Checklist

### Final Review
- [ ] All validation sections completed
- [ ] All tests passing
- [ ] Documentation reviewed
- [ ] Security audit done
- [ ] Performance benchmarks met

### Deployment Preparation
- [ ] Location confirmed
- [ ] Backups created
- [ ] Team notified
- [ ] Training prepared
- [ ] Support plan ready

### Post-Deployment
- [ ] Skill accessible
- [ ] Monitoring active
- [ ] Feedback mechanism ready
- [ ] First use validated
- [ ] Team onboarded

## Monitoring and Maintenance

### Usage Monitoring
- [ ] Activation frequency tracked
- [ ] Success rate measured
- [ ] Error rate monitored
- [ ] Performance metrics collected
- [ ] User satisfaction recorded

### Regular Maintenance
- [ ] Monthly review scheduled
- [ ] Quarterly assessment planned
- [ ] Annual comprehensive review
- [ ] Issue tracking active
- [ ] Improvement backlog maintained

### Update Management
- [ ] Update schedule defined
- [ ] Testing procedures ready
- [ ] Communication plan prepared
- [ ] Rollback tested
- [ ] Post-update validation planned

## Success Metrics

### Operational Metrics
- [ ] Activation rate
- [ ] Completion rate
- [ ] Error rate
- [ ] Performance benchmarks
- [ ] Resource utilization

### Quality Metrics
- [ ] Output accuracy
- [ ] Completeness
- [ ] Consistency
- [ ] User satisfaction
- [ ] Feedback scores

### Business Metrics
- [ ] Time saved
- [ ] Productivity improvement
- [ ] Cost reduction
- [ ] Quality improvement
- [ ] Adoption rate

## Quick Validation

### 30-Second Check
1. Valid JSON config?
2. Markdown prompt exists?
3. Name and description clear?
4. Files in correct location?

### 5-Minute Check
1. 30-second check passed?
2. Trigger configuration complete?
3. Workflow defined?
4. Can activate successfully?
5. Produces expected output?

### 30-Minute Check
1. 5-minute check passed?
2. All sections complete?
3. Tested with real scenarios?
4. State management works?
5. Documentation adequate?
6. Security reviewed?
7. Performance acceptable?

## Validation Status Template

```markdown
# Skill Validation Report

**Skill Name**: [name]
**Validation Date**: [date]
**Validator**: [name]

## Status Summary
- [ ] Passed MVS criteria
- [ ] Passed Production Ready criteria
- [ ] Passed Excellence Standard criteria

## Configuration
- JSON: [Pass/Fail]
- Prompt: [Pass/Fail]
- Triggers: [Pass/Fail]
- State: [Pass/Fail]

## Testing Results
- Unit Tests: [Pass/Fail]
- Integration Tests: [Pass/Fail]
- UAT: [Pass/Fail]
- Performance: [Pass/Fail]

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

## Skill-Specific Checklists

### Stateful Skills
- [ ] State schema documented
- [ ] Persistence tested
- [ ] Migration path defined
- [ ] State cleanup implemented
- [ ] Concurrent access handled

### Multi-Phase Skills
- [ ] All phases defined
- [ ] Transitions validated
- [ ] Phase state tracked
- [ ] Resume capability tested
- [ ] Phase rollback works

### MCP-Dependent Skills
- [ ] Server dependencies listed
- [ ] Server availability checked
- [ ] Fallback behavior defined
- [ ] Connection failures handled
- [ ] Alternative paths available

### Orchestration Skills
- [ ] Sub-task delegation clear
- [ ] Coordination logic tested
- [ ] Progress tracking works
- [ ] Failure recovery defined
- [ ] Results aggregation correct
