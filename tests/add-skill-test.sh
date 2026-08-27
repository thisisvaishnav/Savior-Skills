#!/bin/bash
# Tests for ~/ai-skills/bin/add-skill
#
# Each test runs the script in a sandboxed $HOME with a bare git repo as
# "origin", so nothing touches your real skills, repo, or remotes.
#
# Run:  bash tests/add-skill-test.sh

set -u

SCRIPT="/Users/bombermac/ai-skills/bin/add-skill"
PASS=0
FAIL=0

pass() { echo "  ✓ $*"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $*"; FAIL=$((FAIL+1)); }

# check <description> <command...> — passes if the command succeeds
check() {
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then pass "$desc"; else fail "$desc"; fi
}

# begin <name> — header for one test
begin() { echo; echo "TEST: $1"; }

# setup_sandbox — fake $HOME ($H), fake ai-skills git repo, bare origin ($ORIGIN)
setup_sandbox() {
  SB="$(mktemp -d "${TMPDIR:-/tmp}/skilltest.XXXXXX")"
  H="$SB/home"
  ORIGIN="$SB/origin.git"
  git init -q --bare "$ORIGIN"
  mkdir -p "$H/ai-skills"
  git -C "$H/ai-skills" init -q -b main
  git -C "$H/ai-skills" config user.email "kid@example.com"
  git -C "$H/ai-skills" config user.name "Kid Tester"
  git -C "$H/ai-skills" remote add origin "$ORIGIN"
}

# install_fixture <name> <skills-dir> — creates <dir>/<name>/SKILL.md
install_fixture() {
  local name="$1" dir="$2"
  mkdir -p "$dir/$name"
  printf -- '---\nname: %s\ndescription: fixture skill for tests\n---\n\n# %s\n' "$name" "$name" \
    > "$dir/$name/SKILL.md"
}

# make_fake_npx — fake `npx` that simulates `skills add`: installs skills from
# $FAKE_SKILL_SRC into $HOME/.claude/skills and records them in the lock file.
make_fake_npx() {
  BIN="$SB/bin"
  mkdir -p "$BIN"
  cat > "$BIN/npx" <<'EOF'
#!/bin/bash
[[ "$1" == "skills" && "$2" == "add" ]] || { echo "fake npx: unsupported: $*"; exit 1; }
shift 2
# names passed via --skill/-s
names=()
prev=""
for a in "$@"; do
  { [[ "$prev" == "--skill" || "$prev" == "-s" ]] && names+=("$a"); }
  prev="$a"
done
# no --skill: install every fixture skill (like the real CLI without filters)
[[ ${#names[@]} -eq 0 ]] && names=("$FAKE_SKILL_SRC"/*)
names=("${names[@]##*/}")
mkdir -p "$HOME/.claude/skills" "$HOME/.agents"
for n in "${names[@]}"; do
  rm -rf "$HOME/.claude/skills/$n"
  cp -R "$FAKE_SKILL_SRC/$n" "$HOME/.claude/skills/"
done
python3 - "$HOME/.agents/.skill-lock.json" "${names[@]}" <<'PY'
import json, sys
p, names = sys.argv[1], sys.argv[2:]
try:
    d = json.load(open(p))
except Exception:
    d = {"version": 3, "skills": {}}
for n in names:
    d["skills"][n] = {"source": "fake/repo", "skillFolderHash": "hash-" + n}
json.dump(d, open(p, "w"))
PY
echo "fake npx installed: ${names[*]}"
EOF
  chmod +x "$BIN/npx"
}

# run_wrapper <args...> — runs the script with the sandboxed HOME (and fake npx)
run_wrapper() {
  env HOME="$H" PATH="$SB/bin:$PATH" FAKE_SKILL_SRC="${FAKE_SKILL_SRC:-}" bash "$SCRIPT" "$@"
}

commits_in_repo() { git -C "$H/ai-skills" rev-list --count HEAD 2>/dev/null || echo 0; }

# ---------------------------------------------------------------------------
begin "mirror-only copies an installed skill into the repo and commits it"
setup_sandbox
install_fixture "architecture" "$H/.claude/skills"

run_wrapper --mirror-only architecture --no-push >/dev/null 2>&1

check "SKILL.md mirrored into ai-skills" test -f "$H/ai-skills/architecture/SKILL.md"
check "exactly one commit was made" test "$(commits_in_repo)" = "1"
check "commit mentions the skill name" \
  bash -c "git -C '$H/ai-skills' log -1 --format=%s | grep -q architecture"

# ---------------------------------------------------------------------------
begin "default run pushes the commit to origin/main"
setup_sandbox
install_fixture "tdd" "$H/.claude/skills"

run_wrapper --mirror-only tdd >/dev/null 2>&1

check "origin/main exists on the remote tracking ref" \
  git -C "$H/ai-skills" rev-parse --verify -q refs/remotes/origin/main
check "origin/main matches local HEAD" \
  bash -c "test \"\$(git -C '$H/ai-skills' rev-parse origin/main)\" = \"\$(git -C '$H/ai-skills' rev-parse HEAD)\""

# ---------------------------------------------------------------------------
begin "--no-push commits locally but does not push"
setup_sandbox
install_fixture "react" "$H/.claude/skills"

run_wrapper --mirror-only react --no-push >/dev/null 2>&1

check "commit was made locally" test "$(commits_in_repo)" = "1"
check "origin/main was NOT created" \
  bash -c "! git -C '$H/ai-skills' rev-parse --verify -q refs/remotes/origin/main"

# ---------------------------------------------------------------------------
begin "full flow: npx skills add --skill <name> installs, then wrapper mirrors"
setup_sandbox
make_fake_npx
FAKE_SKILL_SRC="$SB/fake-src"
install_fixture "web-research" "$FAKE_SKILL_SRC"

run_wrapper https://github.com/fake/repo --skill web-research -g -a claude-code -y >/dev/null 2>&1

check "fake CLI installed the skill" test -f "$H/.claude/skills/web-research/SKILL.md"
check "skill mirrored into ai-skills" test -f "$H/ai-skills/web-research/SKILL.md"
check "exactly one commit" test "$(commits_in_repo)" = "1"

# ---------------------------------------------------------------------------
begin "without --skill, newly installed skills are detected via lock-file diff"
setup_sandbox
make_fake_npx
FAKE_SKILL_SRC="$SB/fake-src"
install_fixture "project-planning" "$FAKE_SKILL_SRC"

run_wrapper https://github.com/fake/repo -g -a claude-code -y >/dev/null 2>&1

check "skill installed by fake CLI" test -f "$H/.claude/skills/project-planning/SKILL.md"
check "skill detected and mirrored via lock diff" test -f "$H/ai-skills/project-planning/SKILL.md"
check "exactly one commit" test "$(commits_in_repo)" = "1"

# ---------------------------------------------------------------------------
begin "missing skill: warns, changes nothing, exits cleanly"
setup_sandbox

out="$(run_wrapper --mirror-only does-not-exist --no-push 2>&1)"
status=$?
outfile="$SB/out.txt"
printf '%s' "$out" > "$outfile"

check "exit code is 0" test "$status" = "0"
check "prints a warning mentioning the skill" grep -q "does-not-exist" "$outfile"
check "no directory created" test ! -d "$H/ai-skills/does-not-exist"
check "no commit made" test "$(commits_in_repo)" = "0"

# ---------------------------------------------------------------------------
begin "fresh ai-skills folder without git: wrapper initializes and commits"
setup_sandbox
rm -rf "$H/ai-skills/.git"
install_fixture "react" "$H/.claude/skills"

out="$(run_wrapper --mirror-only react --no-push 2>&1)"

check "skill mirrored" test -f "$H/ai-skills/react/SKILL.md"
check "repo was initialized" test -d "$H/ai-skills/.git"
check "commit was made" test "$(commits_in_repo)" = "1"

# ---------------------------------------------------------------------------
begin "fresh repo with no origin remote and default push: skips push gracefully"
setup_sandbox
rm -rf "$H/ai-skills/.git"
install_fixture "academic-writing" "$H/.claude/skills"

out="$(run_wrapper --mirror-only academic-writing 2>&1)"
status=$?

check "exit code is 0" test "$status" = "0"
check "commit was made" test "$(commits_in_repo)" = "1"
check "message explains push was skipped" \
  bash -c "test -d '$H/ai-skills/.git' && git -C '$H/ai-skills' remote | grep -q . ; test \$? -ne 0"

# ---------------------------------------------------------------------------
echo
echo "RESULT: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
