(defun freereaper/comment-box (b e)
  "Draw a box comment around the region but arrange for the region
to extend to at least the fill column. Place the point after the
comment box."
  (interactive "r")
  (let ((e (copy-marker e t)))
    (goto-char b)
    (end-of-line)
    (insert-char ?  (- fill-column (current-column)))
    (comment-box b e 1)
    (goto-char e)
    (set-marker e nil)))


;; "http://stackoverflow.com/questions/2242572/emacs-todo-indicator-at-left-side"
(defun freereaper/annotate-todo ()
  "put fringe marker on TODO: lines in the curent buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "TODO:" nil t)
      (let ((overlay (make-overlay (- (point) 5) (point))))
        (overlay-put overlay 'before-string (propertize "A"
                                                        'display '(left-fringe right-triangle)))))))


(defun freereaper/run-current-file ()
  "Execute the current file.
For example, if the current buffer is the file x.py, then it'll call 「python x.py」 in a shell.
The file can be emacs lisp, php, perl, python, ruby, javascript, bash, ocaml, Visual Basic.
File suffix is used to determine what program to run.

If the file is modified, ask if you want to save first.

URL `http://ergoemacs.org/emacs/elisp_run_current_file.html'
version 2015-08-21"
  (interactive)
  (let* (
         (ξsuffix-map
          ;; (‹extension› . ‹shell program name›)
          `(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
            ("rb" . "ruby")
            ("js" . "node") ; node.js
            ("sh" . "bash")
            ;; ("clj" . "java -cp /home/xah/apps/clojure-1.6.0/clojure-1.6.0.jar clojure.main")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("tex" . "pdflatex")
            ("lua" . "lua")
            ;; ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
            ))
         (ξfname (buffer-file-name))
         (ξfSuffix (file-name-extension ξfname))
         (ξprog-name (cdr (assoc ξfSuffix ξsuffix-map)))
         (ξcmd-str (concat ξprog-name " \""   ξfname "\"")))

    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified. Do you want to save first?")
        (save-buffer)))

    (if (string-equal ξfSuffix "el") ; special case for emacs lisp
        (load ξfname)
      (if ξprog-name
          (progn
            (message "Running…")
            (async-shell-command ξcmd-str "*freereaper/run-current-file output*"))
        (message "No recognized program file suffix for this file.")))))

(defun font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.
This functions should be added to the hooks of major modes for programming."
  (font-lock-add-keywords
   nil
   '(("\\<\\(FIX\\(ME\\)?\\|DELME\\|BUG\\|HACK\\):" 1 font-lock-warning-face t)
     ("\\<\\(NOTE\\):" 1 'org-level-2 t)
     ("\\<\\(TODO\\):" 1 'org-todo t)
     ("\\<\\(DONE\\):" 1 'org-done t))
   ))



(defun freereaper/setup-development-environment ()
  (interactive)
  (when (find-and-ctags-current-path-match-pattern-p "reaper")
    (cond
     ((find-and-ctags-current-path-match-pattern-p "/Source_New/")
      ;; C++ project don't need html tags
      (message "load tags for Source_New  ...")
      (setq-local tags-table-list (list (find-and-ctags-run-ctags-if-needed "~/ws/p4ws/reaper_code/sw/s3gdrv/Source_New"))))

     ((or (find-and-ctags-current-path-match-pattern-p "/Source_New_ZX2000_TVOS2_0_Trunk/")
          (find-and-ctags-current-path-match-pattern-p "/ZXTVOS2_0_Trunk/")
        )
      ;; C++ project don't need html tags
      (message "load tags for Source_New_ZX2000_TVOS2_0_Trunk  ...")
      (setq-local tags-table-list (list (find-and-ctags-run-ctags-if-needed "~/ws/p4ws/reaper_code/sw/s3gdrv/Source_New_ZX2000_TVOS2_0_Trunk"))))

     ((find-and-ctags-current-path-match-pattern-p "/Source_New_ZX2000/")
      (message "load tags for Source_New_ZX2000 ...")
      ;; html project donot need C++ tags
      (setq-local tags-table-list (list (find-and-ctags-run-ctags-if-needed "~/ws/p4ws/reaper_code/sw/s3gdrv/Source_New_ZX2000")))))))


(defun freereaper/load-my-layout ()
  (interactive)
  (persp-load-state-from-file (concat persp-save-dir "freereaper")))

(defun freereaper/save-my-layout ()
  (interactive)
  (persp-save-state-to-file (concat persp-save-dir "freereaper")))

;; copy from spacemacs gtags layer
(defun helm-gtags-dwim-other-window ()
  "helm-gtags-dwim in the other window"
  (interactive)
  (let ((helm-gtags--use-otherwin t)
        (split-height-threshold nil)
        (split-width-threshold 140))
    (helm-gtags-dwim)))

(defun spacemacs/helm-gtags-maybe-dwim ()
  "Runs `helm-gtags-dwim' if `gtags-enable-by-default' is on.
Otherwise does nothing."
  (interactive)
  (when gtags-enable-by-default
    (call-interactively 'helm-gtags-dwim)))

(defun spacemacs/helm-gtags-define-keys-for-mode (mode)
  "Define key bindings for the specific MODE."
  ;; The functionality of `helm-gtags-mode' is pretty much entirely superseded
  ;; by `ggtags-mode', so we don't add this hook
  ;; (let ((hook (intern (format "%S-hook" mode))))
  ;;   (add-hook hook 'helm-gtags-mode))

  ;; `helm-gtags-dwim' is added to the end of the mode-specific jump handlers
  ;; Some modes have more sophisticated jump handlers that go to the beginning
  ;; It might be possible to add `helm-gtags-dwim' instead to the default
  ;; handlers, if it does a reasonable job in ALL modes.
  (let ((jumpl (intern (format "spacemacs-jump-handlers-%S" mode))))
    (when (boundp jumpl)
      (add-to-list jumpl 'spacemacs/helm-gtags-maybe-dwim 'append)))

  (spacemacs/set-leader-keys-for-major-mode mode
    "gC" 'helm-gtags-create-tags
    "gd" 'helm-gtags-find-tag
    "gD" 'helm-gtags-find-tag-other-window
    "gf" 'helm-gtags-select-path
    "gG" 'helm-gtags-dwim-other-window
    "gi" 'helm-gtags-tags-in-this-function
    "gl" 'helm-gtags-parse-file
    "gn" 'helm-gtags-next-history
    "gp" 'helm-gtags-previous-history
    "gr" 'helm-gtags-find-rtag
    "gR" 'helm-gtags-resume
    "gs" 'helm-gtags-select
    "gS" 'helm-gtags-show-stack
    "gy" 'helm-gtags-find-symbol
    "gu" 'helm-gtags-update-tags))

(defun spacemacs/ggtags-mode-enable ()
  "Enable ggtags and eldoc mode.

For eldoc, ggtags advises the eldoc function at the lowest priority
so that if the major mode has better support it will use it first."
  (when gtags-enable-by-default
    (ggtags-mode 1)
    (eldoc-mode 1)))
