# 🧠 ai-skills

This is a treasure box of **skills** for your AI helper (like Claude Code).

A "skill" is a small instruction file (`SKILL.md`) that teaches your AI helper
how to do one job really well — like doing research, writing React, or
planning projects.

## 📦 What's inside

| Skill | What it teaches your AI |
|-------|------------------------|
| `architecture` | Write design decision docs (ADRs) |
| `web-research` | Search the web properly and check facts |
| `python-data-analysis` | Analyze data with pandas |
| `academic-writing` | Write like a scientist |
| `coding-best-practices` | Write clean, tested code |
| `react` | Build React apps the right way |
| `project-planning` | Break big projects into small steps |

## ✨ The magic command

When you want a new skill, just type this in your terminal:

```bash
npx skills add https://github.com/anthropics/knowledge-work-plugins --skill architecture
```

(Put any GitHub repo after `add`, and any skill name after `--skill`.)

**What happens:** 🪄

1. The skill gets installed so your AI helper can use it.
2. **A copy is saved into this `ai-skills` folder.**
3. It is committed and pushed to GitHub automatically. Done! 🎉

## 🚀 How to set it up (do this only ONCE)

### Step 1 — Get this folder on your computer

Ask the terminal to download the repo:

```bash
git clone https://github.com/thisisvaishnav/ai-skills.git ~/ai-skills
```

### Step 2 — Tell your terminal about the magic

Copy this whole block, paste it into the Terminal, press Enter:

```bash
cat >> ~/.zshrc <<'EOF'

# >>> ai-skills mirror >>>
# Makes `npx skills add ...` also save a copy into ~/ai-skills and push to GitHub.
npx() {
  if [[ "$1" == "skills" && "$2" == "add" ]]; then
    shift 2
    "$HOME/ai-skills/bin/add-skill" "$@"
  else
    command npx "$@"
  fi
}
# <<< ai-skills mirror <<<
EOF
source ~/.zshrc
```

### Step 3 — Make sure the helper script can run

```bash
chmod +x ~/ai-skills/bin/add-skill
```

That's it! Now use the magic command any time. 🎉

## 💡 Useful tricks

```bash
# See what skills a repo has, without installing anything
npx skills add https://github.com/anthropics/knowledge-work-plugins --list

# Save a skill but DON'T upload it to GitHub
npx skills add <repo> --skill <name> --no-push

# Manually copy an already-installed skill into this repo
~/ai-skills/bin/add-skill --mirror-only <skill-name>
```

## 🧪 Check that everything works

```bash
bash ~/ai-skills/tests/add-skill-test.sh
```

If you see `RESULT: 23 passed, 0 failed`, everything is happy. ✅
The tests use a fake pretend-computer (a sandbox), so they never touch your
real files.

## 🩹 If something goes wrong

| Problem | Fix |
|---------|-----|
| `npx skills add` behaved like normal (no copy saved) | Run `source ~/.zshrc` and try again |
| It says "push failed" | You may have no internet, or you need to log in to GitHub. Try `git -C ~/ai-skills push` later |
| It says "No origin remote" | Run: `git -C ~/ai-skills remote add origin https://github.com/thisisvaishnav/ai-skills.git` |
| You broke something | Don't worry! Old versions are saved forever by git. Ask your AI helper to help |
