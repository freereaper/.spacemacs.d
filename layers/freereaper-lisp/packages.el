(defconst freereaper-lisp-packages
  '(
    paredit
    lispy
    (emacs-lisp :location built-in)
    ))

(defun freereaper-lisp/init-paredit ()
  (use-package paredit
    :commands (paredit-wrap-round
               paredit-wrap-square
               paredit-wrap-curly
               paredit-splice-sexp-killing-backward)
    :init
    (progn
      (bind-key* "s-(" #'paredit-wrap-round)
      (bind-key* "s-[" #'paredit-wrap-square)
      (bind-key* "s-{" #'paredit-wrap-curly)
      (with-eval-after-load 'lispy
        (define-key lispy-mode-map (kbd "s-k") 'paredit-splice-sexp-killing-backward))
      )))

(defun freereaper-lisp/init-lispy ()
  (use-package lispy
    :defer t
    :diminish (lispy-mode)
    :init
    (progn
      (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
      )
    :config
    (progn
      (define-key lispy-mode-map (kbd "s-j") 'lispy-splice)
      (define-key lispy-mode-map (kbd "s-m") 'lispy-mark-symbol)
      (define-key lispy-mode-map (kbd "s-1") 'lispy-describe-inline)
      (define-key lispy-mode-map (kbd "s-2") 'lispy-arglist-inline)

      (add-hook 'minibuffer-setup-hook 'freereaper/conditionally-enable-lispy))))

(defun freereaper-lisp/post-init-emacs-lisp ()
    (remove-hook 'emacs-lisp-mode-hook 'auto-compile-mode))
