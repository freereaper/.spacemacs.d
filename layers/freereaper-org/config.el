(defvar org-agenda-dir ""
  "gtd files")

(defvar deft-dir ""
  "deft org files locaiton")

(setq-default
 org-agenda-dir "~/org-notes"
 deft-dir "~/org-notes")

(defun freereaper/org-ispell ()
  "Configure `ispell-skip-region-alist' for `org-mode'."
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))

(add-hook 'org-mode-hook #'freereaper/org-ispell)
