;;
(prelude-require-packages
 '(sublime-themes
   aggressive-indent
   align-cljlet
   ;; paredit
   nyan-mode
   clj-refactor
   helm-swoop
   git-gutter+
   xterm-color
   doom-themes
   magit-gh-pulls))

;;
;; (load-theme 'spolsky t)
;; (custom-theme-set-variables
;;  'spolsky
;;  '(linum-format " %i "))

(load-theme 'doom-one t)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

(set-default-font "Inconsolata-12")
;;(set-background-color "black")

;;
(aggressive-indent-global-mode t)
(scroll-bar-mode 0)
(nyan-mode 1)

;;
(setq cider-repl-history-file (concat user-emacs-directory "cider-history")
      cider-repl-history-size 1000)

;; modes
(add-hook 'clojure-mode-hook
          (lambda ()
            (rainbow-mode t)
            ;;(linum-mode t)
            (message "Hello, Clojure!")))

(add-hook 'magit-mode-hook
          'turn-on-magit-gh-pulls)

;; funcs
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

;; bindings
(eval-after-load 'cider
  '(progn
     (define-key cider-mode-map (kbd "C-c ,")   'cider-test-run-test)
     (define-key cider-mode-map (kbd "C-c C-,") 'cider-test-run-project-tests)))

(eval-after-load 'cider-repl
  '(progn
     (define-key cider-repl-mode-map (kbd "C-c #")   'cider-repl-clear-buffer)
     (define-key cider-repl-mode-map (kbd "C-c M-p") 'cider-repl-reset)))

(global-set-key (kbd "C-x /") 'helm-swoop)
(global-set-key (kbd "C-x C-/") 'helm-multi-swoop-all)
(global-set-key (kbd "C-x C-p") 'crux-swap-windows)

;; unbindings
;;(global-unset-key (kbd "<f11>"))

;; open buffer
(find-file "~/notes")
(split-window-right)

;; cljs
(setq cider-cljs-lein-repl
      "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; org mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

(setq org-src-fontify-natively t)

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

(message "acron is loaded. I <3 MC.")
(provide 'acron)

;;; acron.el ends here
