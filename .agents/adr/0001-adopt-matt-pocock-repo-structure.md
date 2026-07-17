# ADR 0001: Adopt Domain-Based Bucket Structure

**Status:** Accepted
**Date:** 2026-07-14

## Context

The repo had skills flattened at root, no categorization, and no distinction between shipped and experimental skills.

## Decision

Adopt the structure from mattpocock/skills: skills live under skills/<bucket>/<name>, with promoted and non-promoted buckets, bucket READMEs, docs/ pages, and plugin manifests.

## Consequences

- Skills are discoverable by domain
- Clear distinction between shipped and experimental
- All metadata files (plugin.json, README, docs) must be kept in sync
