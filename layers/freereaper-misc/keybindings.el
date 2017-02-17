(global-set-key (kbd "C-x f") 'find-file-in-project)

(spacemacs/set-leader-keys-for-major-mode 'c-mode
  "," 'find-file-in-project)
(spacemacs/set-leader-keys-for-major-mode 'c++-mode
  "," 'find-file-in-project)

(spacemacs/set-leader-keys "nl" 'spacemacs/evil-search-clear-highlight)

