---
description: Triage a Sentry issue - analyze root cause and suggest fixes
argument-hint: <issue-url-or-id>
---

Load the "triage" skill and analyze the Sentry issue.

## Input

Accepts:
- Full Sentry URL: `https://org.sentry.io/issues/PROJ-123/...`
- Short issue ID: `PROJ-123` (requires org context from conversation)

Extract organization slug from URL when provided.

## Sentry-Specific Workflow

1. **Fetch issue details**: Use `mcp_Sentry_get_issue_details` with the issue URL/ID
2. **Get AI analysis**: Use `mcp_Sentry_analyze_issue_with_seer` for root cause insights
3. **Check tag distribution**: Use `mcp_Sentry_get_issue_tag_values` for:
   - `environment` - which environments affected
   - `browser` - browser distribution
   - `url` - affected URLs/endpoints
4. **Search related**: Use `mcp_Sentry_search_issues` to find similar patterns

## MCP Tools

- `mcp_Sentry_get_issue_details` - Full issue with stacktrace, metadata
- `mcp_Sentry_analyze_issue_with_seer` - AI-powered root cause analysis and fix suggestions
- `mcp_Sentry_get_issue_tag_values` - Tag distribution (browser, url, environment, release)
- `mcp_Sentry_search_issues` - Find related issues by pattern
- `mcp_Sentry_search_events` - Event counts and aggregations

## Output

Follow the triage skill's output format. Enhance with:
- Seer's root cause analysis and suggested fixes (if available)
- Tag distribution insights (which environments, browsers, URLs most affected)
- Links to related issues

## Rules

- **Read-only**: Show suggested fixes from Seer, do NOT auto-apply
- **Infer org from URL**: Don't hardcode organization, extract from provided URL
- **Be specific**: Reference exact file:line from stacktrace in fix suggestions

$ARGUMENTS
