;; frostmourne :: 20-hooks
;; ---------------------
;; preexec stamps the start time of each command.
;; precmd  derives duration, git branch/dirty marker, last-status glyph.
;; chpwd   clears the cached duration after a bare `cd`.
;;
;; NOTE: shell `#` line comments inside a Lisp `:body "..."` string trip
;; tatara-lisp's parser, so bodies use no `#` comments. Leading-colon
;; `:` null-commands are the zsh-idiomatic alternative when a body needs
;; an inline reminder.

(defhook
  :event "preexec"
  :body "FROST_CMD_START=$(date +%s)")

(defhook
  :event "precmd"
  :body "
rc=$?
if [ -n \"$FROST_CMD_START\" ]; then
  now=$(date +%s)
  dur=$((now - FROST_CMD_START))
  FROST_CMD_DURATION_MS=$((dur * 1000))
  if [ \"$dur\" -ge 1 ]; then
    FROST_CMD_DURATION=\" ${dur}s\"
  else
    FROST_CMD_DURATION=\"\"
  fi
  unset FROST_CMD_START
else
  FROST_CMD_DURATION=\"\"
  FROST_CMD_DURATION_MS=0
fi
export FROST_CMD_DURATION
export FROST_CMD_DURATION_MS
branch=$(git branch --show-current 2>/dev/null)
if [ -n \"$branch\" ]; then
  dirty=\"\"
  if [ -n \"$(git status --porcelain 2>/dev/null)\" ]; then
    dirty=\"*\"
  fi
  FROST_GIT_BRANCH=\" ⎇ ${branch}${dirty}\"
else
  FROST_GIT_BRANCH=\"\"
fi
export FROST_GIT_BRANCH
if [ \"$rc\" -eq 0 ]; then
  FROST_LAST_STATUS_GLYPH=\"✓\"
else
  FROST_LAST_STATUS_GLYPH=\"✗ ${rc}\"
fi
export FROST_LAST_STATUS_GLYPH")

(defhook
  :event "chpwd"
  :body "FROST_CMD_DURATION=\"\"; export FROST_CMD_DURATION")
