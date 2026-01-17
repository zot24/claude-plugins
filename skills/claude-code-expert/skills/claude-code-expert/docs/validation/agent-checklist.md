# Agent Validation Checklist

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/sub-agents.md
> **Last Updated**: 2025-01-15

## Pre-Creation Validation

### Purpose Definition
- [ ] Clear, specific purpose defined
- [ ] Distinct from existing agents
- [ ] Addresses real use case or workflow
- [ ] Value proposition is documented
- [ ] Scope is appropriately bounded

### Requirements Analysis
- [ ] Target users identified
- [ ] Required expertise documented
- [ ] Expected inputs defined
- [ ] Expected outputs specified
- [ ] Success criteria established

## Frontmatter Validation

### Required Fields
- [ ] `name` field present
- [ ] `name` uses lowercase-with-hyphens format
- [ ] `name` is unique across all agents
- [ ] `name` is descriptive and clear
- [ ] `description` field present
- [ ] `description` explains when to use agent
- [ ] `description` explains why to use agent
- [ ] `description` includes trigger keywords

### Optional Fields (if used)
- [ ] `tools` field uses comma-separated format
- [ ] `tools` lists only valid tool names
- [ ] `tools` includes all necessary tools
- [ ] `tools` excludes unnecessary tools
- [ ] `model` field uses valid value (`sonnet`, `opus`, `haiku`, or `'inherit'`)
- [ ] `model` choice is appropriate for task complexity:
  - Haiku: simple/repetitive tasks, high-frequency operations, well-defined scope, cost-sensitive
  - Sonnet: general-purpose, balanced complexity, standard development workflows (default)
  - Opus: critical decisions, complex analysis, security audits, high-stakes operations
- [ ] Frequency of agent invocation considered in model choice
- [ ] Error cost/impact analyzed and matched to model capability
- [ ] Speed vs accuracy trade-off evaluated for agent's purpose
- [ ] YAML frontmatter is valid and properly formatted
- [ ] Frontmatter delimiter `---` is correct

### Tool Selection Validation
- [ ] Tools align with agent purpose
- [ ] Read-only agents don't have Write/Edit
- [ ] File modification agents have appropriate tools
- [ ] MCP tool access considered (inherit if needed)
- [ ] Security implications reviewed

## System Prompt Validation

### Structure
- [ ] Clear role definition at start
- [ ] Organized with headers/sections
- [ ] Logical flow from role to instructions
- [ ] Appropriate length (not too short or verbose)
- [ ] Proper Markdown formatting

### Role Definition
- [ ] Expertise area clearly stated
- [ ] Responsibilities explicitly defined
- [ ] Authority level indicated
- [ ] Context provided for decisions
- [ ] Constraints acknowledged

### Instructions
- [ ] Step-by-step process provided
- [ ] Instructions are actionable
- [ ] Order of operations is logical
- [ ] Edge cases addressed
- [ ] Error handling included
- [ ] When-conditions specified (when to do what)

### Checklists (if included)
- [ ] Checklist items are specific
- [ ] Items are measurable or verifiable
- [ ] Checklist is comprehensive
- [ ] Priority/severity indicated where relevant
- [ ] Format is consistent

### Output Format
- [ ] Expected output structure defined
- [ ] Format examples provided
- [ ] Verbosity level specified
- [ ] Required sections listed
- [ ] Optional sections indicated

### Constraints
- [ ] What NOT to do is specified
- [ ] Limitations clearly stated
- [ ] Scope boundaries defined
- [ ] Security constraints included
- [ ] Performance considerations noted

### Examples
- [ ] Concrete examples provided
- [ ] Good vs bad examples shown
- [ ] Common scenarios covered
- [ ] Edge cases demonstrated
- [ ] Examples are accurate and relevant

## Content Quality

### Clarity
- [ ] Language is clear and unambiguous
- [ ] Technical terms defined when necessary
- [ ] Instructions are easy to follow
- [ ] No contradictory statements
- [ ] Consistent terminology throughout

### Completeness
- [ ] All necessary information included
- [ ] Dependencies documented
- [ ] Prerequisites specified
- [ ] Assumptions stated explicitly
- [ ] Related concepts referenced

### Accuracy
- [ ] Technical details are correct
- [ ] Code examples are valid
- [ ] References are accurate
- [ ] Tool names are correct
- [ ] File paths are appropriate

### Consistency
- [ ] Consistent with other agents
- [ ] Follows project conventions
- [ ] Style matches documentation standards
- [ ] Terminology aligns with codebase
- [ ] Formatting is uniform

## Functional Validation

### File System
- [ ] Agent file location is appropriate:
  - `.claude/agents/` for project-specific
  - `~/.claude/agents/` for user-wide
  - Plugin directory for plugin agents
- [ ] File extension is `.md` (Markdown)
- [ ] File name matches agent name in frontmatter
- [ ] File permissions are correct
- [ ] File is readable by Claude Code

### Invocation
- [ ] Description enables automatic selection
- [ ] Trigger keywords are effective:
  - "use PROACTIVELY" for automatic use
  - "MUST BE USED when..." for mandatory use
  - Clear domain indicators
- [ ] Agent appears in agent listings
- [ ] Agent can be explicitly invoked by name
- [ ] Agent loads without errors

### Execution
- [ ] Agent starts successfully
- [ ] Context window is appropriately used
- [ ] Agent follows instructions correctly
- [ ] Agent uses specified tools only (if restricted)
- [ ] Agent respects constraints
- [ ] Agent handles errors gracefully

## Testing Validation

### Unit Testing
- [ ] Test basic invocation
- [ ] Test with minimal input
- [ ] Test with typical input
- [ ] Test with complex input
- [ ] Test with edge cases
- [ ] Test with invalid input
- [ ] Verify tool restrictions work
- [ ] Verify output format

### Integration Testing
- [ ] Test with real project files
- [ ] Test with actual data
- [ ] Test coordination with other agents
- [ ] Test MCP tool access (if applicable)
- [ ] Test state persistence
- [ ] Test resumption capability
- [ ] Verify performance is acceptable

### User Acceptance Testing
- [ ] Test with target users
- [ ] Verify meets use case requirements
- [ ] Collect feedback on clarity
- [ ] Validate output quality
- [ ] Confirm agent adds value
- [ ] Check ease of use

## Performance Validation

### Efficiency
- [ ] Response time is acceptable
- [ ] Token usage is appropriate
- [ ] Tool calls are optimized
- [ ] No unnecessary operations
- [ ] Parallel operations used when possible

### Resource Usage
- [ ] Memory usage is reasonable
- [ ] File operations are efficient
- [ ] API calls are minimized
- [ ] MCP server usage is appropriate
- [ ] No resource leaks

### Scalability
- [ ] Works with small inputs
- [ ] Handles large inputs
- [ ] Performs well under load
- [ ] Degrades gracefully
- [ ] Timeout handling is appropriate

## Security Validation

### Access Control
- [ ] Tool restrictions are appropriate
- [ ] File access is limited correctly
- [ ] Sensitive operations require confirmation
- [ ] No unauthorized data access
- [ ] MCP access is properly scoped

### Data Safety
- [ ] No hardcoded secrets
- [ ] Sensitive data handling is secure
- [ ] Credentials are not exposed
- [ ] Audit trail is maintained
- [ ] Data retention policies followed

### Code Safety
- [ ] No destructive operations without confirmation
- [ ] Git operations are safe (no force push to main)
- [ ] File deletions are protected
- [ ] Database operations are safe (if applicable)
- [ ] External API calls are validated

## Documentation Validation

### Internal Documentation
- [ ] Comments explain complex logic
- [ ] Rationale for decisions is documented
- [ ] Limitations are noted
- [ ] Version information included
- [ ] Change log maintained (if versioned)

### External Documentation
- [ ] Usage guide exists
- [ ] Setup instructions provided
- [ ] Examples are available
- [ ] Troubleshooting section included
- [ ] FAQ addresses common questions

### Team Documentation
- [ ] Purpose documented in team wiki/docs
- [ ] Configuration requirements specified
- [ ] Environment setup explained
- [ ] Best practices shared
- [ ] Contact for support identified

## Organizational Validation

### Categorization
- [ ] Placed in correct category:
  - `core/` for generic patterns
  - `domain/` for business knowledge
  - Project level for specific configs
- [ ] Subcategory is appropriate
- [ ] Naming follows conventions
- [ ] Related agents are cross-referenced

### Dependencies
- [ ] Required tools documented
- [ ] Required MCP servers listed
- [ ] Plugin dependencies specified
- [ ] Environment requirements noted
- [ ] Version dependencies stated

### Coordination
- [ ] Works well with other agents
- [ ] No overlap with existing agents
- [ ] Complementary to related agents
- [ ] Handoff points defined
- [ ] Communication patterns established

## Maintenance Validation

### Versioning
- [ ] Version number included (if applicable)
- [ ] Changes are tracked
- [ ] Breaking changes documented
- [ ] Migration guide provided (if needed)
- [ ] Deprecation notices added (if applicable)

### Updates
- [ ] Update frequency determined
- [ ] Update process documented
- [ ] Stakeholders identified
- [ ] Testing after updates planned
- [ ] Rollback procedure defined

### Monitoring
- [ ] Usage metrics tracked
- [ ] Error rates monitored
- [ ] Performance metrics collected
- [ ] User feedback gathered
- [ ] Improvement opportunities identified

## Quality Gates

### Minimum Viable Agent (MVP)
- [x] Required frontmatter fields present
- [x] Basic role definition provided
- [x] Can be invoked successfully
- [x] Produces expected output format

### Production Ready
- [x] All MVP criteria met
- [x] Comprehensive system prompt
- [x] Tested with real use cases
- [x] Documentation complete
- [x] Security reviewed
- [x] Performance validated

### Excellence Standard
- [x] All production ready criteria met
- [x] Examples and checklists included
- [x] Edge cases handled gracefully
- [x] Performance optimized
- [x] User feedback incorporated
- [x] Maintains high quality over time

## Common Issues Checklist

### Configuration Issues
- [ ] No YAML syntax errors
- [ ] All quotes properly closed
- [ ] Indentation is correct
- [ ] Special characters escaped
- [ ] Field names spelled correctly

### Logic Issues
- [ ] No circular dependencies
- [ ] No contradictory instructions
- [ ] All branches covered
- [ ] Exit conditions defined
- [ ] Infinite loops prevented

### Usability Issues
- [ ] Instructions are not ambiguous
- [ ] Technical jargon explained
- [ ] Steps are not too granular or too high-level
- [ ] Examples match instructions
- [ ] Error messages are helpful

### Integration Issues
- [ ] Tool names are correct
- [ ] File paths are valid
- [ ] MCP servers are available (if needed)
- [ ] Dependencies are installed
- [ ] Permissions are adequate

## Pre-Deployment Checklist

### Final Review
- [ ] All validation sections completed
- [ ] All tests passing
- [ ] Documentation reviewed
- [ ] Security audit completed
- [ ] Performance benchmarks met

### Deployment Preparation
- [ ] Deployment location confirmed
- [ ] Backup of existing agents created
- [ ] Team notified of new agent
- [ ] Training materials prepared (if needed)
- [ ] Support plan established

### Post-Deployment
- [ ] Agent accessible to users
- [ ] Monitoring in place
- [ ] Feedback mechanism established
- [ ] First-use validation completed
- [ ] Team onboarding scheduled

## Review Cycles

### Initial Creation
- [ ] Self-review by creator
- [ ] Peer review by teammate
- [ ] Security review (if handling sensitive data)
- [ ] Documentation review

### Regular Maintenance
- [ ] Monthly usage review
- [ ] Quarterly effectiveness review
- [ ] Annual comprehensive review
- [ ] Ad-hoc review when issues arise

### Major Updates
- [ ] Impact analysis
- [ ] Regression testing
- [ ] User communication
- [ ] Gradual rollout (if applicable)
- [ ] Rollback plan ready

## Success Metrics

### Usage Metrics
- [ ] Invocation frequency tracked
- [ ] Success rate measured
- [ ] User satisfaction recorded
- [ ] Time savings quantified
- [ ] Error rate monitored

### Quality Metrics
- [ ] Output accuracy measured
- [ ] Completeness validated
- [ ] Consistency verified
- [ ] Performance benchmarked
- [ ] User feedback positive

### Business Metrics
- [ ] ROI calculated
- [ ] Productivity improvement measured
- [ ] Cost savings identified
- [ ] Quality improvement demonstrated
- [ ] Team adoption tracked

## Quick Validation

### 30-Second Check
1. Valid YAML frontmatter?
2. Name and description present?
3. Clear role definition?
4. File in correct location?

### 5-Minute Check
1. 30-second check passed?
2. System prompt comprehensive?
3. Tool selection appropriate?
4. Examples included?
5. Can invoke successfully?

### 30-Minute Check
1. 5-minute check passed?
2. All sections complete?
3. Tested with real scenarios?
4. Documentation adequate?
5. Security reviewed?
6. Performance acceptable?

## Validation Status Template

```markdown
# Agent Validation Report

**Agent Name**: [name]
**Validation Date**: [date]
**Validator**: [name]

## Status Summary
- [ ] Passed MVP criteria
- [ ] Passed Production Ready criteria
- [ ] Passed Excellence Standard criteria

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
