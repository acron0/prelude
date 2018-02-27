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
   magit-gh-pulls
   ;;flycheck-clojure ;; way too slow to be usable
   ;;flycheck-pos-tip
   ))

;;
;; (load-theme 'spolsky t)
;; (custom-theme-set-variables
;;  'spolsky
;;  '(linum-format " %i "))

(load-theme 'doom-one t)
(disable-theme 'zenburn)
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
            (idle-highlight-mode t)
            ;;(linum-mode t)
            (message "Hello, Clojure!")))

(add-hook 'magit-mode-hook
          'turn-on-magit-gh-pulls)

;; (eval-after-load 'flycheck '(flycheck-clojure-setup))
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

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
(global-set-key (kbd "C-c c o") 'org-capture)

;; unbindings
;;(global-unset-key (kbd "<f11>"))

;; cljs
(setq cider-cljs-lein-repl
      "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; org
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)
   (shell . t)
   (clojure . t)))

(setq org-src-fontify-natively t)

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; stolen from here: https://github.com/otfrom/otfrom-org-emacs/blob/master/org/config.org#org-mode
(setq org-agenda-files
      (append
       (file-expand-wildcards "~/org/*.org")))

(setq org-default-notes-file "~/org/capture.org")

(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "UPCOMING(u)" "PROJECT(p)" "|" "SHIPPED(s)")
        (sequence "TODO(t)" "NEXT(n!/!)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "INACTIVE(i@/!)" "|" "CANCELLED(c@/!)" "MEETING")))

(setq org-todo-state-tags-triggers
      '(("CANCELLED" ("CANCELLED" . t))
        ("WAITING" ("WAITING" . t))
        ("INACTIVE" ("WAITING") ("INACTIVE" . t))
        (done ("WAITING") ("INACTIVE"))
        ("TODO" ("WAITING") ("CANCELLED") ("INACTIVE"))
        ("NEXT" ("WAITING") ("CANCELLED") ("INACTIVE"))
        ("DONE" ("WAITING") ("CANCELLED") ("INACTIVE"))))

(setq org-refile-allow-creating-parent-nodes t)

(setq org-refile-targets
      '((nil :maxlevel . 9)
        (org-agenda-files :maxlevel . 9)))
(setq org-refile-use-outline-path t)


(setq org-capture-templates
      '(("t" "To do"
         entry (file+datetree org-default-notes-file)
         "* TODO %?\n%^{Owner}p\n%U\n%a\n"
         :empty-lines-before 1)
        ("n" "Doing RIGHT NOW"
         entry (file+datetree org-default-notes-file)
         "* NEXT %?\n%^{Owner}p\n%U\n%a\n"
         :clock-in t :clock-resume t
         :empty-lines-before 1)
        ("m" "Meeting"
         entry (file+datetree org-default-notes-file)
         "* MEETING with %? :MEETING:\n%T\n%a"
         :clock-in t :clock-resume t
         :empty-lines-before 1)
        ("k" "Kaylee Checks"
         entry (file+datetree "~/org/kaylee-checks.org")
         "* NEXT Kaylee Checks\n%U\n%a\n%?%[~/org/templates/kaylee-template.org]"
         :clock-in t :clock-resume t
         :empty-lines-before 1)
        ("i" "Idea"
         entry (file org-default-notes-file)
         "* %? :IDEA: \n%t"
         :clock-in t :clock-resume t
         :empty-lines-before 1)))

;; done
(message "acron is loaded. I <3 MC.")
(provide 'acron)

;;; acron.el ends here
