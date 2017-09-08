(defconst freereaper-code-packages
  '(
    etags-select
    ;; (xcscope :location local)
    ;; (helm-cscope :location local)
    ggtags
    (helm-gtags :location local)
    ;;git clone --depth=1 https://github.com/melpa/melpa.git ~/.emacs.d/.cache/quelpa/melpa
    ;; (counsel-gtags :location :fetcher github
    ;;                                  :repo "freereaper/emacs-counsel-gtags"
    ;;                                  ))
    (counsel-gtags :location local)
    (find-and-ctags :location local)
    ycmd
    dumb-jump
    flycheck)
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

      (dolist (mode '(c-mode c++-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "gg" 'etags-select-find-tag-at-point))

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
  (set-variable 'ycmd-global-config "/home/reaper/.vim/.ycm_extra_conf_global.py")

  (set-variable 'ycmd-extra-conf-whitelist '("~/ws/*"))

  (freereaper|toggle-company-backends company-ycmd)

  (eval-after-load 'ycmd
    '(spacemacs|hide-lighter ycmd-mode))

  (spacemacs/set-leader-keys-for-major-mode 'c-mode
    "tb" 'freereaper/company-toggle-company-ycmd)
  (spacemacs/set-leader-keys-for-major-mode 'c++-mode
    "tb" 'freereaper/company-toggle-company-ycmd)

  )

(defun freereaper-code/init-find-and-ctags ()
  (use-package find-and-ctags)

  )

(defun freereaper-code/init-counsel-gtags ()
  (use-package counsel-gtags
    ;; :config
    ;; (progn
    ;;   (eval-after-load 'general
    ;;     (progn
    ;;       (general-define-key :states   'normal
    ;;                           :prefix ","
    ;;                           "ft" 'counsel-gtags-dwim
    ;;                           "fr" 'counsel-gtags-find-symbol
    ;;                           "fu" 'counsel-gtags-update-tags
    ;;        ))))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun freereaper-code/init-xcscope ()                                           ;;
;;   (use-package xcscope                                                           ;;
;;    :commands (cscope-index-files cscope/run-pycscope)                            ;;
;;    :init                                                                         ;;
;;    (progn                                                                        ;;
;;      ;; for python projects, we don't want xcscope to rebuild the databse,       ;;
;;      ;; because it uses cscope instead of pycscope                               ;;
;;      (setq cscope-option-do-not-update-database t                                ;;
;;            cscope-display-cscope-buffer nil)                                     ;;
;;                                                                                  ;;
;;      (defun cscope//safe-project-root ()                                         ;;
;;        "Return project's root, or nil if not in a project."                      ;;
;;        (and (fboundp 'projectile-project-root)                                   ;;
;;             (projectile-project-p)                                               ;;
;;             (projectile-project-root)))                                          ;;
;;                                                                                  ;;
;;      (defun cscope/run-pycscope (directory)                                      ;;
;;        (interactive (list (file-name-as-directory                                ;;
;;                            (read-directory-name "Run pycscope in directory: "    ;;
;;                                                 (cscope//safe-project-root)))))  ;;
;;        (let ((default-directory directory))                                      ;;
;;          (shell-command                                                          ;;
;;           (format "pycscope -R -f '%s'"                                          ;;
;;                   (expand-file-name "cscope.out" directory)))))))                ;;
;;   )                                                                              ;;
;;                                                                                  ;;
;; (defun freereaper-code/init-helm-cscope ()                                       ;;
;;   (use-package helm-cscope                                                       ;;
;;     :defer t                                                                     ;;
;;     :init                                                                        ;;
;;     (defun spacemacs/setup-helm-cscope (mode)                                    ;;
;;       "Setup `helm-cscope' for MODE"                                             ;;
;;       (require 'helm-cscope)                                                     ;;
;;       (spacemacs/set-leader-keys-for-major-mode mode                             ;;
;;         "gc" 'helm-cscope-find-calling-this-funtcion                             ;;
;;         "gC" 'helm-cscope-find-called-function                                   ;;
;;         "gd" 'helm-cscope-find-global-definition                                 ;;
;;         "ge" 'helm-cscope-find-egrep-pattern                                     ;;
;;         "gf" 'helm-cscope-find-this-file                                         ;;
;;         "gF" 'helm-cscope-find-files-including-file                              ;;
;;         "gr" 'helm-cscope-find-this-symbol                                       ;;
;;         "gx" 'helm-cscope-find-this-text-string))                                ;;
;;     :config                                                                      ;;
;;     (defadvice helm-cscope-find-this-symbol (before cscope/goto activate)        ;;
;; (evil--jumps-push))))                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun freereaper-code/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (progn
      (setq flycheck-display-errors-delay 0.4)
      (setq flycheck-idle-change-delay 2.0)
      ))
  )

(defun freereaper-code/post-init-dumb-jump ()
  (setq dumb-jump-selector 'ivy)
  ;; if project root not found, this is the default project root.
  (setq dumb-jump-default-project "~/ws")
  (defun my-dumb-jump ()
    (interactive)
    (evil-set-jump)
    (dumb-jump-go)
    (recenter))

  (bind-key* "M-g j" 'my-dumb-jump)
  (bind-key* "M-g o" 'dumb-jump-go-other-window)
  )


(defun freereaper-code/init-ggtags ()
  (use-package ggtags
    :defer t
    :init
    (progn
      ;; modes that do not have a layer, add here.
      (add-hook 'awk-mode-local-vars-hook #'spacemacs/ggtags-mode-enable)
      (add-hook 'shell-mode-local-vars-hook #'spacemacs/ggtags-mode-enable)
      (add-hook 'tcl-mode-local-vars-hook #'spacemacs/ggtags-mode-enable)
      (add-hook 'vhdl-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))
    :config
    (when (configuration-layer/package-used-p 'helm-gtags)
      ;; If anyone uses helm-gtags, they would want to use these key bindings.
      ;; These are bound in `ggtags-mode-map', since the functionality of
      ;; `helm-gtags-mode' is basically entirely contained within
      ;; `ggtags-mode-map' --- this way we don't have to enable both.
      ;; Note: all of these functions are autoloadable.
      (define-key ggtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
      (define-key ggtags-mode-map (kbd "C-x 4 .") 'helm-gtags-find-tag-other-window)
      (define-key ggtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
      (define-key ggtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack))))

(defun freereaper-code/init-helm-gtags ()
  (use-package helm-gtags
    :init
    (progn
      (setq helm-gtags-ignore-case t
            helm-gtags-auto-update t
            helm-gtags-use-input-at-cursor t
            helm-gtags-pulse-at-cursor t)
      ;; modes that do not have a layer, define here
      (spacemacs/helm-gtags-define-keys-for-mode 'tcl-mode)
      (spacemacs/helm-gtags-define-keys-for-mode 'vhdl-mode)
      (spacemacs/helm-gtags-define-keys-for-mode 'awk-mode)
      (spacemacs/helm-gtags-define-keys-for-mode 'dired-mode)
      (spacemacs/helm-gtags-define-keys-for-mode 'compilation-mode)
      (spacemacs/helm-gtags-define-keys-for-mode 'shell-mode))))


(defun freereaper-code/post-init-helm-gtags ()

  (spacemacs/set-leader-keys-for-major-mode 'c-mode
    "ff" 'helm-gtags-dwim
    "fs" 'helm-gtags-dwim-other-window
    )

  (spacemacs/set-leader-keys-for-major-mode 'c++-mode
    "ff" 'helm-gtags-dwim
    "fs" 'helm-gtags-dwim-other-window
    )

  )
