(defconst freereaper-packages
  '(
    general
    )
)

(defun freereaper/init-general ()
  (use-package general
    :config
      (general-evil-setup t)
    ))
