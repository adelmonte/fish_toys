function help
    set_color cyan
    echo "Emacs-Style Navigation Shortcuts:"
    set_color normal
    echo "  Ctrl + A: Move cursor to beginning of line"
    echo "  Ctrl + E: Move cursor to end of line"
    echo "  Alt + B or Ctrl + Left: Move back one word"
    echo "  Alt + F or Ctrl + Right: Move forward one word"
    echo "  Ctrl + B: Move back one character"
    echo "  Ctrl + F: Move forward one character"
    echo
    set_color cyan
    echo "Emacs-Style Editing Shortcuts:"
    set_color normal
    echo "  Ctrl + U: Cut everything before cursor"
    echo "  Ctrl + K: Cut everything after cursor"
    echo "  Ctrl + W: Cut word before cursor"
    echo "  Alt + D: Cut word after cursor"
    echo "  Ctrl + Y: Paste last cut text"
    echo "  Ctrl + _: Undo last edit"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Mode Shortcuts:"
    set_color normal
    echo "  ESC: Enter normal mode"
    echo "  i: Enter insert mode"
    echo "  v: Enter visual mode"
    echo "  :: Enter command mode"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Navigation Shortcuts (Normal Mode):"
    set_color normal
    echo "  h: Move left"
    echo "  j: Move down"
    echo "  k: Move up"
    echo "  l: Move right"
    echo "  w: Move forward one word"
    echo "  b: Move backward one word"
    echo "  e: Move to end of word"
    echo "  0: Move to beginning of line"
    echo "  \$: Move to end of line"
    echo "  gg: Move to beginning of file"
    echo "  G: Move to end of file"
    echo "  {: Move back one paragraph"
    echo "  }: Move forward one paragraph"
    echo "  Ctrl + f: Page down"
    echo "  Ctrl + b: Page up"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Text Deletion and Manipulation (Normal Mode):"
    set_color normal
    echo "  x: Delete character at cursor"
    echo "  dd: Delete current line"
    echo "  dw: Delete from cursor to end of word"
    echo "  db: Delete from cursor to beginning of word"
    echo "  diw: Delete inner word (entire word under cursor)"
    echo "  bdw: Delete inner word (back delete forward-word)"
    echo "  D: Delete from cursor to end of line"
    echo "  d0: Delete from cursor to beginning of line"
    echo "  d\$: Delete from cursor to end of line"
    echo "  cc: Change entire line"
    echo "  cw: Change from cursor to end of word"
    echo "  ciw: Change inner word (entire word under cursor)"
    echo "  C: Change from cursor to end of line"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Yanking and Pasting (Normal Mode):"
    set_color normal
    echo "  yy: Yank (copy) current line"
    echo "  yw: Yank from cursor to end of word"
    echo "  yiw: Yank inner word (entire word under cursor)"
    echo "  y\$: Yank from cursor to end of line"
    echo "  p: Paste after cursor"
    echo "  P: Paste before cursor"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Search and Replace (Normal Mode):"
    set_color normal
    echo "  /pattern: Search forward for pattern"
    echo "  ?pattern: Search backward for pattern"
    echo "  n: Repeat search in same direction"
    echo "  N: Repeat search in opposite direction"
    echo "  *: Search forward for word under cursor"
    echo "  #: Search backward for word under cursor"
    echo "  :%s/old/new/g: Replace all occurrences of 'old' with 'new'"
    echo "  :s/old/new/g: Replace all occurrences of 'old' with 'new' in current line"
    echo
    set_color cyan
    echo "Vi/Vim/Nvim Miscellaneous (Normal Mode):"
    set_color normal
    echo "  u: Undo last change"
    echo "  Ctrl + r: Redo change"
    echo "  .: Repeat last command"
    echo "  >: Indent selection"
    echo "  <: Unindent selection"
    echo "  =: Auto-indent selection"
    echo "  ZZ: Save and quit"
    echo "  ZQ: Quit without saving"
end