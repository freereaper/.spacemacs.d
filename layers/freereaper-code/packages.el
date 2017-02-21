(defconst freereaper-code-packages
  '(
    etags-select
    ;; ycmd
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
  (set-variable
   'ycmd-server-command
   '("python" "/home/reaper/.vim/bundle/YouCompleteMe/third_party/ycmd/ycmd"))

  (set-variable 'ycmd-extra-conf-whitelist '("~/ws/p4ws/reaper_code/sw/s3gdrv/Source_New/*"))
  (freereaper|toggle-company-backends company-ycmd)
  (eval-after-load 'ycmd
    '(spacemacs|hide-lighter ycmd-mode))

  (spacemacs/set-leader-keys-for-major-mode 'c-mode
    "tb" 'freereaper/company-toggle-company-ycmd)
  (spacemacs/set-leader-keys-for-major-mode 'c++-mode
    "tb" 'freereaper/company-toggle-company-ycmd))
