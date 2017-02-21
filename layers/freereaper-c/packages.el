(defconst freereaper-c-packages
  '(
    (cc-mode :location built-in)
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

  (dolist (mode '(c-mode c++-mode))
    (spacemacs/set-leader-keys-for-major-mode mode
      "gd" 'etags-select-find-tag-at-point))

  (add-hook 'c++-mode-hook 'freereaper/setup-coding-env)
  (add-hook 'c-mode-hook 'freereaper/setup-coding-env)

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
    (define-key c++-mode-map (kbd "s-.") 'company-ycmd))

  )
