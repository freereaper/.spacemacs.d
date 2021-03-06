(global-set-key (kbd "C-c b") 'org-iswitchb)

;; run current file function
(global-set-key (kbd "<f5>") 'freereaper/run-current-file)


;; helm-hotspots
(global-set-key (kbd "<f1>") 'freereaper/helm-hotspots)
(spacemacs/set-leader-keys "oo" 'freereaper/helm-hotspots)

;; ivy specific keybindings
(if (configuration-layer/layer-usedp 'ivy)
    (progn
      (spacemacs/set-leader-keys "ff" 'counsel-find-file)
      (spacemacs/set-leader-keys "fL" 'counsel-locate)
      (spacemacs/set-leader-keys "hi" 'counsel-info-lookup-symbol)
      (spacemacs/set-leader-keys "pb" 'projectile-switch-to-buffer)))


(spacemacs/set-leader-keys "rh" 'helm-resume)

(spacemacs/set-leader-keys "nl" 'spacemacs/evil-search-clear-highlight)

(define-key evil-normal-state-map (kbd "zj") 'freereaper/empty-line-below)
(define-key evil-normal-state-map (kbd "zk") 'freereaper/empty-line-above)

(nvmap :prefix ","
       "+"  'spacemacs/scale-up-font
       "-"  'spacemacs/scale-down-font
       "aa" 'copy-to-x-clipboard
       "zz" 'paste-from-x-clipboard
       )
