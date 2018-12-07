;;(directory-files-recursively default-directory "")

(defun cider-repl-reset ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset)")
    (cider-repl-return)))

(defun insert-date-time ()
  (interactive)
  (insert (shell-command-to-string "bash -c 'echo -n $(date +%Y%m%d%H%M)'")))

(defun clojure-sort-ns-on-file (f)
  (save-excursion
    (find-file f)
    (clojure-sort-ns)
    (write-file f)
    (kill-buffer (current-buffer))))

(defun clojure-sort-all-ns ()
  (interactive)
  (mapc #'clojure-sort-ns-on-file (directory-files-recursively "~/projects/wh/works-hub/" ".clj$" t)))

(message "functions are loaded")
(provide 'functions)
