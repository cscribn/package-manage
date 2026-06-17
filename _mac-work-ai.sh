#!/usr/bin/env bash

# cursor instructions - download
mkdir -p "${HOME}/.config/cursor"; \
{ printf '%s\n' '---' 'alwaysApply: true' '---' ''; \
    curl -fsSL https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/github/copilot-instructions.md; } > "${HOME}/.config/cursor/instructions.mdc"

# cursor instructions - copy
src="${HOME}/.config/cursor/instructions.mdc"; \
for dir in "${HOME}/projects"/*/; do \
    [[ -d "$dir" ]] || continue; \
    target="${dir}.cursor/rules/instructions.mdc"; \
    if [[ -f "$target" ]]; then \
        if [[ "$(shasum -a 256 "$target" | awk '{print $1}')" != "$(shasum -a 256 "$src" | awk '{print $1}')" ]]; then \
            cp "$src" "$target"; \
            cd "$dir" || exit 1; \
            git add .cursor/rules/instructions.mdc && git commit -m "Update cursor rules" && git remote | grep -q '^origin$' && git push origin HEAD; \
            cd - || exit 1; \
        fi; \
    fi; \
done
