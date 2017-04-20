(global-set-key (kbd "C-x f") 'find-file-in-project)


(global-set-key (kbd "C-c r") 'freereaper/revert-buffer-no-confirm)

(spacemacs/set-leader-keys-for-major-mode 'c-mode
  "," 'find-file-in-project)
(spacemacs/set-leader-keys-for-major-mode 'c++-mode
  "," 'find-file-in-project)

(spacemacs/set-leader-keys "nl" 'spacemacs/evil-search-clear-highlight)

;; make C-i consistent
(define-key evil-normal-state-map (kbd "TAB") 'evil-jump-forward)
