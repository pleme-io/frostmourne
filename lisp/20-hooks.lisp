;; frostmourne :: 20-hooks
;; ---------------------
;; preexec stamps the start time of each command; precmd derives the
;; duration from it. That is ALL these hooks do, and they do it with
;; zero subprocesses.
;;
;; NOTE: shell `#` line comments inside a Lisp `:body "..."` string trip
;; tatara-lisp's parser, so bodies use no `#` comments. Leading-colon
;; `:` null-commands are the zsh-idiomatic alternative when a body needs
;; an inline reminder.
;;
;; ── 2026-08-07: three forks per prompt deleted, one fixed ──────────
;;
;; What was here before ran on EVERY prompt and cost ~30 ms of forks
;; whose results nothing read:
;;
;;   git branch --show-current   ->  FROST_GIT_BRANCH   (7.0 ms)
;;   git status --porcelain      ->  FROST_GIT_BRANCH   (never ran, see below)
;;   date +%s  x2                ->  FROST_CMD_DURATION (7.8 ms each)
;;
;; FROST_GIT_BRANCH and FROST_LAST_STATUS_GLYPH have NO live reader.
;; Their only consumer was `10-prompt.lisp`'s two-liner, which has been
;; fully commented out since seki became the default prompt (2026-05-21),
;; and the active `(defprompt :command "seki prompt …")` renders git and
;; exit-status from seki's own modules. A fleet-wide sweep found no other
;; reader. So both are deleted outright, forks included.
;;
;; The `git status --porcelain` fork is worth naming separately, because
;; it was never a cost — it was a WRONG ANSWER. It was written as
;;     if [ -n "$(git status --porcelain 2>/dev/null)" ]
;; and frost does not expand `$(…)` inside double quotes (verified against
;; zsh 5.9 on 2026-08-07; tracked as a frost parity bug). So `-n` tested
;; the non-empty LITERAL string `$(git status --porcelain 2>/dev/null)`,
;; which is always true: the dirty marker was pinned on for every repo,
;; clean or not, and git never actually ran. Deleting the block removes a
;; false signal, not a feature.
;;
;; FROST_CMD_DURATION_MS is DIFFERENT — it has a live reader: the
;; `(defnotify …)` form in `05-notify.lisp` synthesizes a precmd that
;; compares it against a 30 s threshold. So it is fixed rather than
;; deleted, and fixed twice over:
;;
;;   * no fork — `$EPOCHREALTIME` is a frost-native parameter
;;     (frost-expand/src/lib.rs:330), so the two `date +%s` spawns go away;
;;   * real precision — `date +%s` is whole SECONDS, so the value was
;;     always a multiple of 1000 and every sub-second command reported 0.
;;
;; Deriving integer milliseconds without floating point, and without
;; tripping octal parsing on a zero-padded fraction:
;;   $EPOCHREALTIME is `<seconds>.<9-digit-nanoseconds>` (width verified
;;   constant at 9). Strip the last six digits of the fraction to get
;;   exactly three digits of milliseconds, then CONCATENATE rather than
;;   multiply — "1786127091" + "510" is already 1786127091510. A leading
;;   zero inside the fraction (`.051…` -> "051") is harmless in a
;;   concatenation but would be an invalid octal literal in `$((…))`.
;;   The concatenation is quoted because frost currently drops the second
;;   of two adjacent expansions in a BARE assignment word (same 2026-08-07
;;   parity sweep); inside double quotes it is correct in both shells.
;;   Each `$EPOCHREALTIME` reference re-reads the clock, so it is captured
;;   into `__t` once per stamp.
;;
;; SEKI_CMD_DURATION_MS is exported alongside it: seki's `cmd_duration`
;; module reads exactly that name (seki-modules/src/cmd_duration.rs:44)
;; and nothing in the fleet was setting it, so the segment could never
;; render. One export turns a shipped-but-dead module on.

(defhook
  :event "preexec"
  :body "
__t=$EPOCHREALTIME
__s=${__t%.*}
__f=${__t#*.}
FROST_CMD_START_MS=\"${__s}${__f%??????}\"
unset __t __s __f")

(defhook
  :event "precmd"
  :body "
FROST_LAST_EXIT=$?
: the capture above MUST be the first line — `:` itself succeeds and so
: would reset $? to 0, which is why this reminder sits below it
export FROST_LAST_EXIT
if [ -n \"$FROST_CMD_START_MS\" ]; then
  __t=$EPOCHREALTIME
  __s=${__t%.*}
  __f=${__t#*.}
  __now_ms=\"${__s}${__f%??????}\"
  FROST_CMD_DURATION_MS=$((__now_ms - FROST_CMD_START_MS))
  unset __t __s __f __now_ms FROST_CMD_START_MS
else
  FROST_CMD_DURATION_MS=0
fi
export FROST_CMD_DURATION_MS
SEKI_CMD_DURATION_MS=$FROST_CMD_DURATION_MS
export SEKI_CMD_DURATION_MS")
