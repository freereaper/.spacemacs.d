(defun freereaper/rtags-find-symbol-at-point-other-file ()
  (interactive)
  (let((current-prefix-arg '(4)))
    (call-interactively 'rtags-find-symbol-at-point)
    )
)

(defun freereaper/rtags-find-symbol-at-point ()
  (interactive)
  (freereaper/followize 'rtags-find-symbol-at-point rtags-helm-source)
  )

(defun freereaper/rtags-find-symbol ()
  (interactive)
  (freereaper/followize 'rtags-find-symbol rtags-helm-source)
  )


(defun freereaper/rtags-find-references-at-point ()
  (interactive)
  (freereaper/followize 'rtags-find-references-at-point rtags-helm-source)
 )

(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
(doxymacs-font-lock)))
