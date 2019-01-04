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
   fold-dwim
   fold-dwim-org
   all-the-icons
   all-the-icons-dired
   plantuml-mode
   ;;flycheck-clojure ;; way too slow to be usable
   ;;flycheck-pos-tip
   ))

;;
;; (load-theme 'spolsky t)
;; (custom-theme-set-variables
;;  'spolsky
;;  '(linum-format " %i "))

(load-theme 'doom-vibrant t)
(load-theme 'smart-mode-line-respectful t)

(disable-theme 'zenburn)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

(set-default-font "Inconsolata-12")
;;(set-background-color "black")

;;
(global-git-gutter+-mode t)
(aggressive-indent-global-mode t)
(add-to-list 'aggressive-indent-excluded-modes 'sass-mode)
(scroll-bar-mode 0)
(nyan-mode 1)

;; WH special
(setq tab-width 2)
;;(setq clojure-indent-style ":always-indent")

;;
(setq cider-repl-history-file (concat user-emacs-directory "cider-history")
      cider-repl-history-size 1000)

;; modes
(add-hook 'clojure-mode-hook
          (lambda ()
            (projectile-mode t)
            (rainbow-mode t)
            (idle-highlight-mode t)
            (hs-minor-mode t)
            (fold-dwim-org/minor-mode t)
            (clj-refactor-mode t)
            ;;(linum-mode t)
            ;; wh style (0 = clj align)
            (put-clojure-indent ':require 0)
            (put-clojure-indent ':require-macros 0)
            (put-clojure-indent ':import 0)
            (put-clojure-indent 's/fdef 1)
            (put-clojure-indent 'reg-event-fx 0)
            (put-clojure-indent 'reg-event-db 0)
            (put-clojure-indent 'reg-sub 0)
            (put-clojure-indent 'and 0)
            (put-clojure-indent 'or 0)
            (put-clojure-indent 'some->> 0)
            (put-clojure-indent 'some-> 0)
            (put-clojure-indent 'as->> 0)
            (put-clojure-indent 'as-> 0)
            (put-clojure-indent 'mapv 0)
            (put-clojure-indent 'mlet 1)
            (put-clojure-indent 'merge 0)
            (put-clojure-indent 'i-util/run-async 1)

            (message "Hello, Clojure!")))

(add-hook 'magit-mode-hook
          'turn-on-magit-gh-pulls)

(add-hook 'dired-mode-hook
          'all-the-icons-dired-mode)

(add-hook 'before-save-hook
          (lambda ()
            (when (eq major-mode 'clojure-mode)
              (clojure-sort-ns))))

(add-hook 'before-save-hook
          (lambda ()
            (when (eq major-mode 'clojurescript-mode)
              (clojure-sort-ns))))

;; (eval-after-load 'flycheck '(flycheck-clojure-setup))
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; bindings
(eval-after-load 'cider
  '(progn
     (define-key cider-mode-map (kbd "C-c ,")   'cider-test-run-test)
     (define-key cider-mode-map (kbd "C-c C-,") 'cider-test-run-project-tests)
     (push '"def-spec-test" cider-test-defining-forms)))

(eval-after-load 'cider-repl
  '(progn
     (define-key cider-repl-mode-map (kbd "C-c #")   'cider-repl-clear-buffer)
     (define-key cider-repl-mode-map (kbd "C-c M-p") 'cider-repl-reset)))

;; allow remembering risky variables
;;(defun risky-local-variable-p (sym &optional _ignored) nil)
(advice-add 'risky-local-variable-p :override #'ignore)

(global-set-key (kbd "C-x /") 'helm-swoop)
(global-set-key (kbd "C-x C-/") 'helm-multi-swoop-all)
(global-set-key (kbd "C-x C-p") 'crux-swap-windows)
(global-set-key (kbd "C-c c o") 'org-capture)
(global-set-key (kbd "C-x <end>") 'golden-ratio)

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
   (clojure . t)
   (plantuml . t)))

(setq org-src-fontify-natively t)
(setq org-plantuml-jar-path "~/bin/plantuml.jar")

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
