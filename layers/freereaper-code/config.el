(add-hook 'prog-mode-hook 'font-lock-comment-annotations)


(defmacro freereaper|toggle-company-backends (backend)
  "Push or delete the backend to company-backends"
  (let ((funsymbol (intern (format "freereaper/company-toggle-%S" backend))))
    `(defun ,funsymbol ()
       (interactive)
       (if (eq (car company-backends) ',backend)
           (setq-local company-backends (delete ',backend company-backends))
         (push ',backend company-backends)))))
