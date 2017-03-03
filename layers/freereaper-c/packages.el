(defconst freereaper-c-packages
  '(
    (cc-mode :location built-in)
    (doxymacs :location local)
    rtags
    ))

(defun freereaper-c/post-init-cc-mode ()
  (add-to-list 'auto-mode-alist '("\\.\\(c\\|h\\)\\'" . c-mode))
  (add-to-list 'auto-mode-alist '("\\.\\(cpp\\|hpp\\)\\'" . c++-mode))

  ;; use regexp to check if it's C++ header
  (add-to-list 'magic-mode-alist
                `(,(lambda ()
                    (and (string= (file-name-extension (or (buffer-file-name) "")) "h")
                          (or (re-search-forward "#include <\\w+>"
                                                magic-mode-regexp-match-limit t)
                              (re-search-forward "\\W\\(class\\|template\\namespace\\)\\W"
                                                magic-mode-regexp-match-limit t)
                              (re-search-forward "std::"
                                                magic-mode-regexp-match-limit t))))
                  . c++-mode))


  (add-hook 'c++-mode-hook 'freereaper/setup-development-environment)
  (add-hook 'c-mode-hook 'freereaper/setup-development-environment)

  ;; http://stackoverflow.com/questions/23553881/emacs-indenting-of-c11-lambda-functions-cc-mode
  (defadvice c-lineup-arglist (around my activate)
    "Improve indentation of continued C++11 lambda function opened as argument."
    (setq ad-return-value
          (if (and (equal major-mode 'c++-mode)
                   (ignore-errors
                     (save-excursion
                       (goto-char (c-langelem-pos langelem))
                       ;; Detect "[...](" or "[...]{". preceded by "," or "(",
                       ;;   and with unclosed brace.
                       (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))
              0                       ; no additional indent
            ad-do-it)))               ; default behavior

  ;; set style to "linux"
  (setq c-default-style "linux")
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)
  (with-eval-after-load 'c++-mode
    (define-key c++-mode-map (kbd "s-.") 'company-ycmd)))

(defun freereaper-c/init-doxymacs ()
  "Initialize doxymacs"
  (use-package doxymacs
    :init
    (add-hook 'c-mode-common-hook 'doxymacs-mode)
    (add-hook 'c++-mode-common-hook 'doxymacs-mode)
    :config
    (progn
      (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
(spacemacs|hide-lighter doxymacs-mode))))

(defun freereaper-c/init-rtags ()
  (use-package rtags
    :defer f
    :init
    (progn
      (require 'rtags-helm)
      (spacemacs/set-leader-keys-for-major-mode 'c-mode
        "fg" 'freereaper/rtags-find-symbol-at-point
        "fG" 'freereaper/rtags-find-symbol-at-point-other-file
        "fs" 'freereaper/rtags-find-symbol
        "fc" 'freereaper/rtags-find-references-at-point
        )

      (spacemacs/set-leader-keys-for-major-mode 'c++-mode
        "fd" 'freereaper/rtags-find-symbol-at-point
        "fD" 'freereaper/rtags-find-symbol-at-point-other-file
        "fs" 'rtags-find-symbol
        "fc" 'rtags-find-references-at-point
        ;; "r" 'rtags-find-references-at-point-in-file to implement
        "v" 'rtags-find-virtuals-at-point
        "C-r" 'rtags-rename-symbol

        ;; print prefix
        "pt" 'rtags-print-class-hierarchy
        "pe" 'rtags-print-enum-value-at-point
        "pi" 'rtags-print-dependencies
        "ps" 'rtags-print-symbol-info
        "pp" 'rtags-preprocess-file

        ;; TODO: planned micro state
        ;; "o" (rtags-occurence-transient state)
        ;; "n" 'rtags-next-match
        ;; "N/p" 'rtags-previous-match
        ))
    :config
    (progn
      (require 'rtags-helm)
      (setq rtags-jump-to-first-match nil)
      (setq rtags-use-helm t)
      (add-hook 'rtags-jump-hook 'evil-set-jump)
      (add-to-list 'spacemacs-jump-handlers-c++-mode
                   '(rtags-find-symbol-at-point :async t)))
    )
)
