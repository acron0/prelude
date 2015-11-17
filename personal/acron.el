;;
(load-theme 'ample-zen t)

;;
(aggressive-indent-global-mode t)

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

;;
;; (require 'rainbow-blocks)
;; (add-hook 'clojure-mode-hook 'rainbow-blocks-mode)
