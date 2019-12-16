;; fns
(defun wh-start-executor-cmd ()
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (insert "(do (require 'wh.executor.core) (wh.executor.core/start))")
    (execute-kbd-macro (kbd "<return>"))))

(defun wh-start-app-cmd ()
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (insert "(do (require 'wh.dev) (wh.dev/go))")
    (execute-kbd-macro (kbd "<return>"))))

(defun wh-clear-subs-cmd ()
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (insert "(do (require 're-frame.subs) (re-frame.subs/clear-subscription-cache!))")
    (execute-kbd-macro (kbd "<return>"))))

(defun wh-prt-fn (prefix)
  (interactive "sString for prefix: ")
  (insert "(defn prt [x] (println \"" prefix "\" x) x)")
  (cider-repl-return))

(eval-after-load 'cider-repl
  '(progn
     (define-key cider-repl-mode-map (kbd "C-x w s") 'wh-start-app-cmd)
     (define-key cider-repl-mode-map (kbd "C-x w x") 'wh-start-executor-cmd)
     (define-key cider-repl-mode-map (kbd "C-x w c") 'wh-clear-subs-cmd)))

;; done
(message "wh is loaded.")
(provide 'wh)
