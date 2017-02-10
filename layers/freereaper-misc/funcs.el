(defun paste-from-clipboard-and-cc-kill-ring ()
  "paste from clipboard and cc the content into kill ring"
  (interactive)
  (let (str)
    (with-temp-buffer
      (paste-from-x-clipboard)
      (setq str (buffer-string)))
    ;; finish the paste
    (insert str)
    ;; cc the content into kill ring at the same time
    (kill-new str)
    ))

(defun freereaper/open-file-with-projectile-or-counsel-git ()
  (interactive)
  (if (or (freereaper/vcs-project-root)
          (projectile-project-p))
      (projectile-find-file)
    (counsel-file-jump)))

(defun freereaper/vcs-project-root ()
  "Return the project root for current buffer."
  (let ((directory default-directory))
    (or (locate-dominating-file directory ".git")
        (locate-dominating-file directory ".svn")
        (locate-dominating-file directory ".hg"))))
