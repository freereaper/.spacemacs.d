(defconst freereaper-code-packages
  '(
    etags-select
    (xcscope :location local)
    (helm-cscope :location local)
    ycmd
    flycheck
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
  (spacemacs/add-to-hooks 'ycmd-mode '(c++-mode-hook c-mode-hook))
  (add-hook 'ycmd-mode-hook 'company-ycmd-setup)
  (add-hook 'ycmd-mode-hook 'flycheck-ycmd-setup)

  (set-variable 'ycmd-parse-conditions '(save new-line buffer-focus))
  (set-variable 'ycmd-idle-change-delay 0.1)
  (set-variable 'url-show-status nil)
  (set-variable 'ycmd-request-message-level -1)
  (set-variable 'ycmd-confirm-fixit nil)

  (set-variable
   'ycmd-server-command
   '("python" "/home/reaper/.vim/bundle/YouCompleteMe/third_party/ycmd/ycmd"))

  (set-variable 'ycmd-extra-conf-whitelist '("~/ws/*"))

  (freereaper|toggle-company-backends company-ycmd)


  (spacemacs/set-leader-keys-for-major-mode 'c-mode
    "tb" 'freereaper/company-toggle-company-ycmd)
  (spacemacs/set-leader-keys-for-major-mode 'c++-mode
    "tb" 'freereaper/company-toggle-company-ycmd)

  )


(defun freereaper-code/init-xcscope ()
  (use-package xcscope
   :commands (cscope-index-files cscope/run-pycscope)
   :init
   (progn
     ;; for python projects, we don't want xcscope to rebuild the databse,
     ;; because it uses cscope instead of pycscope
     (setq cscope-option-do-not-update-database t
           cscope-display-cscope-buffer nil)

     (defun cscope//safe-project-root ()
       "Return project's root, or nil if not in a project."
       (and (fboundp 'projectile-project-root)
            (projectile-project-p)
            (projectile-project-root)))

     (defun cscope/run-pycscope (directory)
       (interactive (list (file-name-as-directory
                           (read-directory-name "Run pycscope in directory: "
                                                (cscope//safe-project-root)))))
       (let ((default-directory directory))
         (shell-command
          (format "pycscope -R -f '%s'"
                  (expand-file-name "cscope.out" directory)))))))
  )

(defun freereaper-code/init-helm-cscope ()
  (use-package helm-cscope
    :defer t
    :init
    (defun spacemacs/setup-helm-cscope (mode)
      "Setup `helm-cscope' for MODE"
      (require 'helm-cscope)
      (spacemacs/set-leader-keys-for-major-mode mode
        "gc" 'helm-cscope-find-calling-this-funtcion
        "gC" 'helm-cscope-find-called-function
        "gd" 'helm-cscope-find-global-definition
        "ge" 'helm-cscope-find-egrep-pattern
        "gf" 'helm-cscope-find-this-file
        "gF" 'helm-cscope-find-files-including-file
        "gr" 'helm-cscope-find-this-symbol
        "gx" 'helm-cscope-find-this-text-string))
    :config
    (defadvice helm-cscope-find-this-symbol (before cscope/goto activate)
(evil--jumps-push))))

(defun freereaper-code/post-init-flycheck ()
  (dolist (mode '(c-mode c++-mode))
    (spacemacs/add-flycheck-hook mode))

  (with-eval-after-load 'flycheck
    (progn
      (setq flycheck-display-errors-delay 0.4)
      (setq flycheck-idle-change-delay 2.0)
      ))
  )
