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

(defun freereaper/helm-hotspots ()
  "helm interface to my hotspots, which includes my locations,
org-files and bookmarks"
  (interactive)
  (helm :buffer "*helm: hotspots*"
        :sources `(,(freereaper//hotspots-sources))))

(defun freereaper//hotspots-sources ()
  "Construct the helm sources for my hotspots"
  `((name . "Mail and News")
    (candidates . (("Calendar" . (lambda ()  (browse-url "https://www.google.com/calendar/render")))
                   ("RSS" . elfeed)
                   ("Blog" . org-octopress)
                   ("Github" . (lambda() (helm-github-stars)))
                   ("Calculator" . (lambda () (helm-calcul-expression)))
                   ("Run current flie" . (lambda () (zilongshanren/run-current-file)))
                   ("Agenda" . (lambda () (org-agenda "" "a")))
                   ("sicp" . (lambda() (browse-url "http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-4.html#%_toc_start")))))
    (candidate-number-limit)
    (action . (("Open" . (lambda (x) (funcall x)))))))


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

(defun freereaper/my-swiper-search (p)
  (interactive "P")
  (let ((current-prefix-arg nil))
    (call-interactively
     (if p #'spacemacs/swiper-region-or-symbol
       #'counsel-grep-or-swiper))))
