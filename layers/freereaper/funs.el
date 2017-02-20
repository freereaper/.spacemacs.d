;;------------------------------------------------------------------------------
;; Return first file found from a list
;;------------------------------------------------------------------------------
(defun freereaper/return-first-file-found (options)
    (let ((option-found nil)
          (i 0)
          (len (length options)))
      (while (and (not option-found) (< i len))
        (if (file-exists-p (elt options i))
            (setq option-found (elt options i)))
        (setq i (1+ i)))
option-found))



(defun freereaper/empty-line-below ()
  (interactive)
  (call-interactively (key-binding (kbd "o")))
  (evil-normal-state)
  (call-interactively (key-binding (kbd "k")))
  )


(defun freereaper/empty-line-above ()
  (interactive)
  (call-interactively (key-binding (kbd "O")))
  (evil-normal-state)
  (call-interactively (key-binding (kbd "j")))
  )

