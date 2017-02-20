(defconst freereaper-code-packages
  '(
    etags-select
    ycmd
    )
  )


;; when many project has the need to use tags, I will give etags-table and etags-update a try
(defun freereaper-code/init-etags-select ()
  (use-package etags-select
    :init
    (progn
      (define-key evil-normal-state-map (kbd "gf")
        (lambda () (interactive) (find-tag (find-tag-default-as-regexp))))

      (define-key evil-normal-state-map (kbd "gb") 'pop-tag-mark)

      (define-key evil-normal-state-map (kbd "gn")
        (lambda () (interactive) (find-tag last-tag t)))

      (evilified-state-evilify etags-select-mode etags-select-mode-map))))


(defun freereaper-code/post-init-ycmd ()
  (global-company-mode)
  (global-ycmd-mode)
  (company-ycmd-setup)
  (set-variable
   'ycmd-server-command
   '("python" "/home/reaper/.vim/bundle/YouCompleteMe/third_party/ycmd/ycmd"))

  (set-variable 'ycmd-extra-conf-whitelist '("~/*"))
  (set-variable 'ycmd-global-modes 'all)
  (set-variable 'ycmd-parse-conditions
                '(save new-line mode-enabled idle-change buffer-focus))
  )
