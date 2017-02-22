(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))

;; return nil to write content to file
(defun freereaper/untabify-buffer ()
  (interactive)
  (save-excursion
    (untabify (point-min) (point-max)) nil))

(add-hook 'c++-mode-hook
          #'(lambda ()
             (add-hook 'write-contents-hooks
                       'freereaper/untabify-buffer nil t)))

(setq auto-mode-alist
      (append
       '(("\\.mak\\'" . makefile-bsdmake-mode))
       auto-mode-alist))

;; Extra hightlight for stdint.h
(dolist (m '(c-mode c++-mode))
  (font-lock-add-keywords
   m
   '(("\\<\\(int8_t\\|int16_t\\|int32_t\\|int64_t\\|uint8_t\\|uint16_t\\|uint32_t\\|uint64_t\\)\\>" . font-lock-keyword-face))))
