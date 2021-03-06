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
   auto-dim-other-buffers
   flycheck-joker
   flycheck-pos-tip
   lsp-mode
   ;;flycheck-clojure ;; way too slow to be usable
   ))

;; set up linters

(require 'flycheck-joker)
(require 'flycheck-clj-kondo)

(dolist (checker '(clj-kondo-clj clj-kondo-cljs clj-kondo-cljc clj-kondo-edn))
  (setq flycheck-checkers (cons checker (delq checker flycheck-checkers))))

(dolist (checkers '((clj-kondo-clj . clojure-joker)
                    (clj-kondo-cljs . clojurescript-joker)
                    (clj-kondo-cljc . clojure-joker)
                    (clj-kondo-edn . edn-joker)))
  (flycheck-add-next-checker (car checkers) (cons 'error (cdr checkers))))

;; set up themes

(load-theme 'doom-vibrant t)
(load-theme 'smart-mode-line-respectful t)

(disable-theme 'zenburn)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (message "Microsoft Windows")))
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (message "Mac OS X")
    (set-default-font "Inconsolata-14")))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (message "Linux")
    (set-default-font "Inconsolata-12"))))
;;(set-background-color "black")

;; set up modes

(global-git-gutter+-mode t)
(aggressive-indent-global-mode t)
(add-to-list 'aggressive-indent-excluded-modes 'sass-mode)
(scroll-bar-mode 0)
(nyan-mode 1)
(auto-dim-other-buffers-mode 1)

;; WH special
(setq tab-width 2)
(setq clojure-indent-style :align-arguments)

;;
(setq cider-repl-history-file (concat user-emacs-directory "cider-history")
      cider-repl-history-size 1000)

(defun clojure-mode-config ()
  (prettify-symbols-mode t)
  (projectile-mode t)
  (rainbow-mode t)
  (idle-highlight-mode t)
  (hs-minor-mode t)
  (fold-dwim-org/minor-mode t)
  (clj-refactor-mode t)
  (flycheck-pos-tip-mode t)
  (whitespace-mode t)
  (lsp t)

  ;; lambda symbol
  (push '("#" . ?λ) prettify-symbols-alist)
  (setq-local prettify-symbols-compose-predicate
              (lambda (begin end match)
                (and (prettify-symbols-default-compose-p begin end match)
                     (or (not (equal match "#")) (eq (char-after end) ?\()))))

  ;;(linum-mode t)
  ;; wh style (0 = clj align)
  (put-clojure-indent '-> 0)
  (put-clojure-indent '->> 0)
  (put-clojure-indent ':import 0)
  (put-clojure-indent ':require 0)
  (put-clojure-indent ':require-macros 0)
  (put-clojure-indent 'and 0)
  (put-clojure-indent 'as-> 0)
  (put-clojure-indent 'as->> 0)
  (put-clojure-indent 'assoc 0)
  (put-clojure-indent 'asynchronously 0)
  (put-clojure-indent 'cond-> 0)
  (put-clojure-indent 'cond->> 0)
  (put-clojure-indent 'def-query-from-template 0)
  (put-clojure-indent 'def-spec-test 0)
  (put-clojure-indent 'defroutes 0)
  (put-clojure-indent 'fail 0)
  (put-clojure-indent 'hash-map 0)
  (put-clojure-indent 'html/deftemplate 0)
  (put-clojure-indent 'i-util/run-async 1)
  (put-clojure-indent 'i-util/run-async 1)
  (put-clojure-indent 'if-mlet 1)
  (put-clojure-indent 'mapv 0)
  (put-clojure-indent 'mdo 0)
  (put-clojure-indent 'merge 0)
  (put-clojure-indent 'merge 0)
  (put-clojure-indent 'prom/mlet 1)
  (put-clojure-indent 'prom/if-mlet 1)
  (put-clojure-indent 'prom/when-mlet 1)
  (put-clojure-indent 'reg-event-db 0)
  (put-clojure-indent 'reg-event-fx 0)
  (put-clojure-indent 'reg-fx 0)
  (put-clojure-indent 'reg-sub 0)
  (put-clojure-indent 'reg-sub-raw 0)
  (put-clojure-indent 's/fdef 1)
  (put-clojure-indent 'letsub 1))

;; modes
(add-hook 'clojure-mode-hook
          'clojure-mode-config)

(add-hook 'clojurescript-mode-hook
          'clojure-mode-config)

(add-hook 'clojurec-mode-hook
          'clojure-mode-config)

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

(add-hook 'before-save-hook
          (lambda ()
            (when (eq major-mode 'clojurec-mode)
              (clojure-sort-ns))))

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (when 1 ;(string-equal system-type "darwin") ; Mac OS X
              (call-process-shell-command "say \"It's time to kick ass and chew bubble gum\" &" nil 0))))

(add-hook 'inf-mongo-mode-hook
          'smartparens-strict-mode)

;; set up lsp
(add-hook 'lsp-mode-hook
          (lambda ()
            (dolist (m '(clojure-mode
                         clojurec-mode
                         clojurescript-mode))
              (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
            (setq lsp-enable-indentation nil
                  lsp-clojure-server-command '("bash" "-c" "clojure-lsp"))))

;; we usually do keybindings with `eval-after-load' but eshell is weird
;; https://github.com/noctuid/general.el/issues/80
(add-hook 'eshell-mode
          (lambda ()
            (smartparens-mode t)
            (define-key eshell-mode-map (kbd "C-c #") 'eshell/clear)))

;; (eval-after-load 'flycheck '(flycheck-clojure-setup))
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; bindings
(eval-after-load 'cider
  '(progn
     (define-key cider-mode-map (kbd "C-c ,")   'cider-test-run-test)
     (define-key cider-mode-map (kbd "C-c C-,") 'cider-test-run-project-tests)
     (define-key cider-mode-map (kbd "C-c C-q") 'cider-quit)
     (push '"def-spec-test" cider-test-defining-forms)))

(eval-after-load 'cider-repl
  '(progn
     (define-key cider-repl-mode-map (kbd "C-c #")   'cider-repl-clear-buffer)
     (define-key cider-repl-mode-map (kbd "C-c M-p") 'cider-repl-reset)))

;; allow remembering risky variables
(defun risky-local-variable-p (sym &optional _ignored) nil)
(advice-add 'risky-local-variable-p :override #'ignore)

(global-set-key (kbd "C-x /") 'helm-swoop)
(global-set-key (kbd "C-x C-/") 'helm-multi-swoop-all)
(global-set-key (kbd "C-x C-p") 'crux-swap-windows)
(global-set-key (kbd "C-c c o") 'org-capture)
(global-set-key (kbd "C-x <end>") 'golden-ratio)
(global-set-key (kbd "C-x .") 'lsp-find-references)

;; unbindings
;;(global-unset-key (kbd "<f11>"))

;; cljs
(setq cider-cljs-lein-repl
      "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; org
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)
   (sh . t)
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
        ("i" "Idea"
         entry (file org-default-notes-file)
         "* %? :IDEA: \n%t"
         :clock-in t :clock-resume t
         :empty-lines-before 1)))

;; https://emacs.stackexchange.com/questions/2189/how-can-i-prevent-a-command-from-using-specific-windows
(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s: Can't touch this!"
     "%s is up for grabs.")
   (current-buffer)))

;; eshell helpers
(defun eshell-maybe-bol ()
  (interactive)
  (message "eshell-maybe-bol")
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))

;; TODO doesn't work?!?!?
;; (add-hook 'eshell-mode-hook
;;           (lambda ()
;;             (define-key eshell-mode-map (kbd "C-a") 'eshell-maybe-bol)))

;; transparency?!
(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
(add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; done
(message "acron is loaded.")
(provide 'acron)

;;; acron.el ends here
