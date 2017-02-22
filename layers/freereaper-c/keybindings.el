(dolist (mode '(c-mode c++-mode))
  (spacemacs/set-leader-keys-for-major-mode mode
    "tc" 'helm-imenu
    "ta" 'helm-imenu-in-all-buffers)
  )
