# Server Safety & Development Environment Policy

## CRITICAL RULES
1. **Live / Production Server (`51.79.156.216`) is STRICTLY READ-ONLY**:
   - DO NOT upload files, deploy binaries, modify configs, or execute service restarts on the Production server without prior explicit confirmation from the user.
2. **All Development & Testing MUST be on Dev Server (`100.92.14.48`)**:
   - Use the `helianz_dev` database and slave instance for all builds, tests, experiments, and verifications.
3. **Always advocate creating a Dev server / environment** for any new project or major subsystem before touching production assets.
