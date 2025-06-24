# Semantic Release Templates

This directory contains templates for `python-semantic-release` changelog generation.

## Files

- `CHANGELOG.md.j2` - Base changelog template
- `template.md.j2` - Custom template for formatting changelog entries

## Configuration

The semantic release configuration is defined in `.github/semantic-release-config.toml` and uses the templates in this directory to generate formatted changelogs.

## Usage

These templates are automatically used by the release workflow when processing non-Terraform releases through semantic-release v10.1.0.
