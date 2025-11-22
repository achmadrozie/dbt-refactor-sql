# New Generation Workspace

This folder contains new development work, separated from the legacy codebase.

## Structure

```
_new_generation/
├── models/     # dbt models
├── seeds/      # CSV seed files
├── snapshots/  # Snapshots
├── legacy/     # Old file - need to be refactored
├── tests/      # Test files
└── macros/     # Custom Jinja macros
```

## Notes

- This workspace runs alongside the existing `models/`, `seeds/`, and `macros/` folders
- All paths are configured in `dbt_project.yml`
- Macros defined here will be available globally across the project
