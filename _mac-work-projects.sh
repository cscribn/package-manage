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

# requirements - download
git_dir="${HOME}/.config/dotfiles-misc"; \
if [ -d "$git_dir" ]; then \
    cd "$git_dir" || exit 1; \
    git pull origin || exit 1; cd - || exit 1; \
else \
    git init "$git_dir"; \
    cd "$git_dir" || exit 1; \
    git checkout -b main; \
    git remote add origin "https://github.com/cscribn/dotfiles-misc"; \
    git sparse-checkout set "requirements"; \
    git pull --set-upstream origin main; \
    cd - || exit 1; \
fi

# requirements - sync
src_dir="$HOME/.config/dotfiles-misc/requirements"; \
mapfile -t md_files < <(find "$src_dir" -maxdepth 1 -type f -name "*.md"); \
find "$HOME/Projects" -maxdepth 1 -mindepth 1 -type d | while read -r project_root; do \
    [[ -d "$project_root/requirements" ]] || continue; \
    has_changes="false"; \
    for src in "${md_files[@]}"; do \
        file_name=$(basename "$src"); \
        target="$project_root/requirements/$file_name"; \
        if [[ -f "$target" ]]; then \
            src_hash=$(sha256sum "$src" | awk '{print $1}'); \
            tgt_hash=$(sha256sum "$target" | awk '{print $1}'); \
            if [[ "$src_hash" != "$tgt_hash" ]]; then \
                cp "$src" "$target"; \
                has_changes="true"; \
            fi; \
        fi; \
    done; \
    if [[ "$has_changes" == "true" ]]; then \
        cd "$project_root" || exit 1; \
        git add requirements/; \
        git commit -m "Update requirements"; \
        if git remote | grep -qx "origin"; then git push origin HEAD; fi; \
        cd - || exit 1; \
    fi; \
done

