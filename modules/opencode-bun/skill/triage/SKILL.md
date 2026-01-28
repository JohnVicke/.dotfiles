---
name: triage
description: Triage production issues from error tracking systems. Use when analyzing errors, prioritizing bugs, or investigating production incidents.
---

# Issue Triage Workflow

## Analysis Steps

1. **Gather context**: Error message, stack trace, affected users, frequency
2. **Assess severity**:
   - Critical: data loss, security, complete outage
   - High: feature broken for many users
   - Medium: degraded experience, workaround exists
   - Low: edge case, cosmetic
3. **Identify root cause**: Don't fix symptoms, find actual source
4. **Determine blast radius**: Which users/features/environments affected?
5. **Propose fix direction**: Minimal change that addresses root cause

## Output Format

```
## Summary
[One-line description]

## Severity: [Critical|High|Medium|Low]
Justification: [why this severity]

## Impact
- Users affected: [count/percentage]
- Environments: [production/staging/etc]
- First seen: [timestamp]
- Frequency: [events/hour or total count]

## Root Cause Analysis
[Explanation of what's happening and why]

## Stack Trace Analysis
[Key frames, what they reveal about the failure path]

## Suggested Fix
[Code direction - specific files/functions to change, approach to take]

## Next Steps
[Diagnostic steps if root cause unclear, or implementation steps if clear]

## Related Issues
[Similar patterns, potential duplicates]
```

## Rules

- **Read-only**: Show fixes, never auto-apply
- **Evidence-based**: Every claim backed by data from the issue
- **Minimal**: Smallest fix that solves the problem
- **No scope creep**: Triage one issue at a time
- **Actionable**: End with clear next steps
