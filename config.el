(require 'package)

(add-to-list 'package-archives
'("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Bootstrap
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))
(eval-when-compile
(require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)
      (menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(setq visible-bell t)

(use-package gcmh
						:diminish gcmh-mode
						:config
						(setq gcmh-idle-delay 5
						gcmh-high-cons-threshold (* 16 1024 1024)) ;; this represets 16mb
						(gcmh-mode 1))
						(add-hook 'emacs-startup-hook
						(lambda ()
						(setq gc-cons-percentage 0.1)))

						(add-hook 'emacs-startup-hook
						(lambda ()
						(message "Emacs ready in %s with %d garbage collections."
						(format "%.2f seconds"
						(float-time
						(time-subtract after-init-time before-init-time)))
						gcs-done)))
						(fset 'yes-or-no-p 'y-or-n-p)
						(setq confirm-kill-emacs 'yes-or-no-p)
						(setq frame-resize-pixelwise t)
						(setq window-resize-pixelwise nil)
						(setq-default truncate-lines t)
						(setq-default tab-width 2)
						(setq-default fill-column 80)

								;; stop emacs from creating annoying backup files..
								(setq make-backup-files nil)
								;; stop emacs from creating autosave files (eg: #main.go#)
								(setq auto-save-default nil)

						;; configure path for linux
				(when (memq window-system '(mac ns x))
		(exec-path-from-shell-initialize))
				(setq org-src-tab-acts-natively t)

		;; format org mode babel src blocks
		(defun udf/my-org-tab-dwim (&optional arg)
  (interactive)
  (or (org-babel-do-key-sequence-in-edit-buffer (kbd "TAB"))
      (org-cycle arg)))

(define-key org-mode-map
  (kbd "<tab>") #'udf/my-org-tab-dwim)

(set-face-attribute 'default nil :font "JetBrains Mono" :weight 'Bold :height 130)
(set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight
'Bold :height 130)

(use-package swiper
:ensure t)

(use-package magit
:ensure t)

(use-package paren
:ensure t
:config
(setq show-paren-delay 0.1
show-paren-highlight-openparen t
show-paren-when-point-inside-paren t
show-paren-when-point-in-periphery t)
(show-paren-mode 1))

(use-package smartparens
:diminish smartparens-mode
:defer 1
:config
(require 'smartparens-config)
(setq sp-max-prefix-length 25)
(setq sp-max-pair-length 4)
(setq sp-highlight-pair-overlay nil
sp-highlight-wrap-overlay nil
sp-highlight-wrap-tag-overlay nil)
(with-eval-after-load 'evil
(setq sp-show-pair-from-inside t)
(setq sp-cancel-autoskip-on-backward-movement nil)
(setq sp-pair-overlay-keymap (make-sparse-keymap)))

(let ((unless-list '(sp-point-before-word-p
sp-point-after-word-p
sp-point-before-same-p)))
(sp-pair "'" nil :unless unless-list))

(sp-local-pair sp-lisp-modes "(" ")" :unless '(:rem sp-point-before-same-p))
(sp-local-pair '(emacs-lisp-mode org-mode markdown-mode gfm-mode)
"[" nil :post-handlers '(:rem ("| " "SPC")))

(dolist (brace '("(" "{" "["))
(sp-pair brace nil
:post-handlers '(("||\n[i]" "RET")("| " "SPC"))
:unless '(sp-point-before-word-p sp-point-before-same-p)))
(smartparens-global-mode t))

(use-package evil
	:init
	(setq evil-want-keybinding t)
	(setq evil-want-fine-undo t)
	(setq evil-want-keybinding nil)
	:config
	(define-key evil-motion-state-map "/" 'swiper)
	(define-key evil-window-map "\C-w" 'evil-delete-buffer)
	(define-key evil-motion-state-map "\C-b" 'evil-scroll-up)

	;; Setting cursor colors
	(setq evil-emacs-state-cursor '("#649bce" box))
	(setq evil-normal-state-cursor '("#ebcb8b" box))
	(setq evil-operator-state-cursor '("#ebcb8b" hollow))
	(setq evil-visual-state-cursor '("#677691" box))
	(setq evil-insert-state-cursor '("#eb998b" (bar . 2)))
	(setq evil-replace-state-cursor '("#eb998b" hbar))
	(setq evil-motion-state-cursor '("#ad8beb" box))

	(evil-define-key nil 'custom-mode-map
	;;motion
	(kbd "C-j") 'widget-forward
	(kbd "C-k") 'widget-backwards
	"q" 'Custom-buffer-done)

	;; define lsp doc stuff
	(evil-define-key 'normal 'lsp-ui-doc-mode
	[?K] #'lsp-ui-doc-glance)

	(dolist (mode '(help-mode-map
	calendar-mode-map
	(evil-define-key 'motion  mode "q" 'kill-this-buffer))))
	(evil-mode 1))

;; Evil escape mode
(use-package evil-escape
	:config
	(setq-default evil-escape-key-sequence "jk")
	(setq-default evil-escape-delay 0.2)
	(evil-escape-mode +1))

(use-package evil-surround
	:defer 2
	:config
	(global-evil-surround-mode 1))

(use-package evil-snipe
	:diminish evil-snipe-mode
	:diminish evil-snipe-local-mode
	:after evil
	:config
	(evil-snipe-mode +1))

(use-package projectile)
(projectile-mode 1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(setq projectile-project-search-path '("~/.dev/" "~/.personal/"))

(use-package helm
:ensure
:config
(require 'helm-config))

;; re-map some global bindings to be helm
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(helm-mode 1)

(load-theme 'dracula t)

(use-package company
:diminish company-mode
:hook ((emacs-lisp-mode . (lambda ()
(setq-local company-backends '(company-elisp))))
(emacs-list-mode . company-mode))
:init
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 2
company-tooltip-limit 14
company-tooltip-align-annotations t
company-require-match 'never
company-frontends
'(company-pseudo-tooltip-frontend
company-echo-metadata-frontend)
company-backends '(company-capf company-files company-keywords)
company-auto-complete nil
company-auto-complete-chars nil
company-debbrev-other-buffers nil
company-debbrev-ignore-case nil
company-debbrev-downcase nil)
:config
(general-define-key :keymaps 'company-active-map
"TAB" 'company-select-next
"S-TAB" 'company-select-previous
"<return>" 'company-complete-selection
"RET" 'company-complete-selection)
(setq company-idle-delay 0.35)
(company-tng-mode))
(with-eval-after-load 'company
(define-key company-active-map (kbd "RET") #'company-complete-selection))

(use-package general
:config
(general-define-key
:states '(normal motion visual)
:keymaps 'override
:prefix ","
"f" '(helm-find-files :which-key "find files")
"p" '(projectile--find-file :whick-key "Find files in the current project")
"s" '(projectile-switch-project :which-key "Switch project")
"b" '(helm-buffers-list :which-key "Show active buffers")))

(use-package which-key
:diminish which-key-mode
:init
(which-key-mode)
(which-key-setup-minibuffer)
:config
(setq which-key-idle-delay 0.3))

(use-package lsp-mode
	:commands (lsp lsp-deferred))
(use-package lsp-ui)

;; prettier
(use-package prettier-js
:ensure t)

(use-package go-mode
:ensure t
:hook ((go-mode . lsp))
:bind (:map go-mode-map
("<f6>" . gofmt)
("C-c 6" . gofmt))
:config
    (setq lsp-go-analysis
    '((fieldalignment . t)
    (nilness . t)
    (unusedwrite . t)
    (unusedparams .t)))
(setq gofmt-command "goimports")
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4))

(use-package typescript-mode
	:hook (
				 (typescript-mode . lsp)
				 (typescript-mode . highlight-indent-guides-mode)
				 )
	:config
	(setq-default typescript-indent-level 2))

(setq indent-tabs-mode nil)
(defun harun/webmode-hook ()
	"My personal webmode hook"
	(setq web-mode-markup-indent-offset 2)
	(setq web-mode-enable-comment-annotations t)
	(setq web-mode-code-indent-offset 2)
	(setq web-mode-css-indent-offset 2)
	(setq web-mode-attr-indent-offset 0)
	(setq web-mode-enable-auto-indentation t)
	(setq web-mode-enable-auto-pairing t)
	(setq web-mode-enable-auto-closing t)
	(setq web-mode-enable-css-colorization t)
	(highlight-indent-guides-mode))

;; TODO -- Add other web mode hook configs
;; TODO -- Add other language support like react, eslint etc


(use-package web-mode
	:hook (
				 (web-mode . harun/webmode-hook)
				 (web-mode . lsp)
				 (css-mode . lsp)
				 (scss-mode . lsp)
				 )
	:commands (web-mode)
	:mode (("\\.tsx\\'" . web-mode)
				 ("\\.html\\'" . web-mode)))

(use-package flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable tslint because it is deprecated and no one uses it anyway..
(setq-default flycheck-disabled-checkers
							(append flycheck-disabled-checkers
											'(typescript-tslint)))
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'typescript-mode)
(setq-default flycheck-temp-prefix ".flycheck")

(use-package org-bullets
	:after org
	:hook (org-mode . org-bullets-mode))

(use-package org-superstar
	:after org
	;;:hook (org-mode . org-superstar-mode)
	:config
	(set-face-attribute 'org-superstar-header-bullet nil :inherit 'fixed-pitched :height 180)
	:custom
	;; set the leading bullet to be a space. For alignment purposes I use an em-quad space (U+2001)
	(org-superstar-headline-bullets-list '("???"))
	(org-superstar-todo-bullet-alist '(("DONE" . ????)
																		       ("TODO" . ????)
																		       ("ISSUE" . ????)
																		       ("BRANCH" . ????)
																		       ("FORK" . ????)
																		       ("MR" . ????)
																		       ("MERGED" . ????)
																		       ("GITHUB" . ?A)
																		       ("WRITING" . ????)
																		       ("WRITE" . ????)
																		       ))
	(org-superstar-special-todo-items t)
	(org-superstar-leading-bullet "")
	)

(use-package spaceline
				:ensure t
				:config
				(require 'spaceline-config)
		(spaceline-spacemacs-theme)
		(setq powerline-default-separator 'arrow)
(spaceline-compile))
