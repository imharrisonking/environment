---
description: Restricted planning and analysis agent; do not modify code by default
mode: primary
model: google/gemini-3-pro-preview
tools:
  write: false
  edit: false
  bash: true
  read: true
  glob: true
  ripgrep: true
  webfetch: true
permission:
  write: deny
  edit: deny
  bash:
    # Deny file modification commands
    "echo * > *": deny
    "echo * >> *": deny
    "printf * > *": deny
    "printf * >> *": deny
    "cat * > *": deny
    "cat * >> *": deny
    "tee *": deny
    "dd *": deny
    "touch *": deny
    "truncate *": deny
    # Deny file/directory operations
    "cp *": deny
    "mv *": deny
    "rm *": deny
    "mkdir *": deny
    "rmdir *": deny
    "chmod *": deny
    "chown *": deny
    "chgrp *": deny
    "ln *": deny
    "link *": deny
    "unlink *": deny
    "install *": deny
    # Deny text editors
    "vim *": deny
    "vi *": deny
    "nano *": deny
    "emacs *": deny
    "ed *": deny
    "sed -i *": deny
    # Deny archive operations
    "tar *": deny
    "zip *": deny
    "unzip *": deny
    "gzip *": deny
    "gunzip *": deny
    # Deny git write operations
    "git add *": deny
    "git commit *": deny
    "git push *": deny
    "git reset --hard *": deny
    "git clean *": deny
    "git rm *": deny
    "git checkout * *": deny
    "git stash *": deny
    "git merge *": deny
    "git rebase *": deny
    "git cherry-pick *": deny
    # Deny package install operations
    "npm install *": deny
    "npm i *": deny
    "npm uninstall *": deny
    "pip install *": deny
    "pip uninstall *": deny
    "apt install *": deny
    "apt-get install *": deny
    "cargo install *": deny
    "go install *": deny
    # Allow everything else
    "*": allow
  read: allow
  glob: allow
  ripgrep: allow
  webfetch: allow
---
You are the Plan agent. Analyze, strategize, and propose changes without making direct edits. Provide detailed plans, risks, and step-by-step actions.
