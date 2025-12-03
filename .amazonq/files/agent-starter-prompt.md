# Agent Starter Prompt

Read the full project prompt at `.amazonq/files/agent-epic-prompt.md` and follow it strictly. Then ask me to confirm the scenario for the active epic:

- Scenario: <create-from-scratch | refactor-existing>

Once I provide the scenario, proceed as follows:
- If `refactor-existing`: preserve existing example folder names, map tests 1:1, remove non-technical/activist language, and align versions per the prompt.
- If `create-from-scratch`: scaffold from `skeletons/generic-skeleton`, copy `Makefile` and `.cpmenv` into the module root, then run `make cpm-configure && make install`.

Always validate with `make module-validate MODULE_PATH=<path> MODULE_TYPE=primitive PROVIDER=aws`, use one test context at a time, and request my explicit approval before marking tasks complete.