;;
(prelude-require-packages
 '(noctilux-theme
   aggressive-indent
   align-cljlet
   paredit
   clj-refactor))

;;
(load-theme 'noctilux t)
(set-default-font "Inconsolata-12")

;;
(aggressive-indent-global-mode t)
(scroll-bar-mode 0)

;; modes
(add-hook 'clojure-mode-hook #'rainbow-mode)
(add-hook 'clojure-mode-hook #'linum-mode)

;; funcs
(defun cider-repl-reset ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset)")
    (cider-repl-return)))

;; bindings
(eval-after-load 'cider
  '(progn
     (define-key cider-mode-map (kbd "C-c ,")   'cider-test-run-test)))

(eval-after-load 'cider-repl
  '(progn
     (define-key cider-repl-mode-map (kbd "C-c #")   'cider-repl-clear-buffer)
     (define-key cider-repl-mode-map (kbd "C-c M-p") 'cider-repl-reset)))

;; unbindings
(global-unset-key (kbd "<f11>"))

(message "acron is loaded. I <3 MC.")
(provide 'acron)

;;; acron.el ends here
