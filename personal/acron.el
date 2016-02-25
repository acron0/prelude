;;
(prelude-require-packages
 '(farmhouse-theme
   aggressive-indent))

(load-theme 'farmhouse-dark t)

;;
(aggressive-indent-global-mode t)

;; font size
(set-default-font "Inconsolata-12")

;;;;
(defun sw1nn-nrepl-current-server-buffer ()
  (let ((nrepl-server-buf (with-current-buffer (cider-current-repl-buffer)
                            nrepl-server-buffer)))
    (when nrepl-server-buf
      (get-buffer nrepl-server-buf))))

(defun sw1nn-cider-perspective ()
  (interactive)
  (cider-switch-to-last-clojure-buffer)
  (delete-other-windows)
  (split-window-below)
  (windmove-down)
  (shrink-window 15)
  (switch-to-buffer (sw1nn-nrepl-current-server-buffer))
  (windmove-up)
  (cider-switch-to-relevant-repl-buffer))

(defun def-clojure-key ()
  (define-key cider-mode-map (kbd "C-c C-z") 'sw1nn-cider-perspective))

(add-hook 'clojure-mode-hook #'def-clojure-keys)

(provide 'acron)

;;; acron.el ends here
