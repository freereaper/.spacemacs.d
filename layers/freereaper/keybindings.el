(global-set-key (kbd "C-c b") 'org-iswitchb)

;; run current file function
(global-set-key (kbd "<f5>") 'freereaper/run-current-file)


;; helm-hotspots
(global-set-key (kbd "<f1>") 'freereaper/helm-hotspots)
(spacemacs/set-leader-keys "oo" 'freereaper/helm-hotspots)


(bind-keys :prefix-map  my-prefix-map
           :prefix "C-c c"
           ("v". customize-face))
