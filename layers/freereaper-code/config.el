(add-hook 'prog-mode-hook 'font-lock-comment-annotations)


(defmacro freereaper|toggle-company-backends (backend)
  "Push or delete the backend to company-backends"
  (let ((funsymbol (intern (format "freereaper/company-toggle-%S" backend))))
    `(defun ,funsymbol ()
       (interactive)
       (if (eq (car company-backends) ',backend)
           (setq-local company-backends (delete ',backend company-backends))
         (push ',backend company-backends)))))


(defadvice
    helm-cscope-find-calling-this-funtcion
    (after helm-cscope-find-calling-this-function-recenter activate)
  (recenter))


(defadvice
    helm-cscope-find-global-definition
    (after helm-cscope-find-global-definition-recenter activate)
  (recenter))

(defadvice
    dumb-jump-go-other-window
    (after dumb-jump-go-other-window-recenter activate)
  (recenter))


(defadvice
    etags-select-goto-tag
    (after etags-select-goto-tag-recenter activate)
  (recenter))
