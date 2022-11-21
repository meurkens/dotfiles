;;; .emacs --- Person config
;;; Commentary:

;;; Code:

;; remove visual clutter
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)

;; font
(set-face-attribute 'default nil
		    :font "Overpass Mono"
		    :height 140)

;; line numbers
(global-display-line-numbers-mode)

;; store all backup and autosave files in the tmp dir
(make-directory "~/.emacs.d/tmp/" t)
(setq backup-directory-alist
      `((".*" . "~/.emacs.d/tmp/")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/tmp/" t)))
(setq backup-by-copying t)
(setq create-lockfiles nil)

;; tabs
(setq c-basic-offset 2
      js-indent-level 2
      css-indent-offset 2
      tab-width 2
      indent-tabs-mode nil)

;; trailing whitespace

(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

(setq-default show-trailing-whitespace t)
(add-hook 'cider-repl-mode-hook
	  (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'shell-mode-hook
	  (lambda () (setq show-trailing-whitespace nil)))

;; turn of audio
(setq ring-bell-function 'ignore)

;; find executables
(setq exec-path (append exec-path '("/home/meurkens/.asdf/shims" "/home/meurkens/.dotfiles/bin")))

;; customizations to a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;; MISC
;; ====

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      lsp-lens-enable t
      lsp-signature-auto-activate nil
      lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ;; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

(windmove-default-keybindings)

(setq mac-option-modifier 'super)
(setq mac-pass-command-to-system nil)
(setq split-width-threshold 0)

(global-set-key (kbd "C-c e c")
		(lambda () (interactive)
		  (find-file "~/.emacs")))

(global-set-key (kbd "C-c e s")
		(lambda () (interactive)
		  (find-file "~/Dropbox/Current/emacs cheatsheet.md")))

;; PACKAGES
;; ========

;; initialize melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; initialize use-package
;; needs to be installed by `M-x package-install` first time
(eval-when-compile
  (require 'use-package))

;; Searching
;; =========

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (setq ivy-re-builders-alist
	'((swiper . ivy--regex-plus)
	  (t . ivy--regex-fuzzy))))

(use-package flx
  :ensure t)

(use-package ivy-hydra
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t))

(use-package command-log-mode
  :ensure t)

(use-package cider
  :ensure t)

(use-package paredit
  :ensure t
  :config
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'cider-mode-hook #'paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'cider-mode-hook #'rainbow-delimiters-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-l")
  :hook
  (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
   ;;         (XXX-mode . lsp)
   ;; (rustic-mode . lsp)
   (web-mode . lsp)

   ;; if you want which-key integration
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-cargo-watch-enable t)
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-inlay-hints-mode t)
  (lsp-rust-analyzer-proc-macro-enable t)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-headerline-breadcrumb-enable nil)
  ;; (lsp-disabled-clients '(ts-ls))
  :config
  ;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook #'yas-minor-mode-on)
  ;; (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)
  (add-hook 'hack-local-variables-hook
            (lambda () (when (derived-mode-p 'web-mode) (lsp)))))

;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode)

;; (use-package lsp-ivy
;;   :ensure t
;;   :commands lsp-ivy-workspace-symbol)

;; (use-package lsp-treemacs
;;   :ensure t
;;   :commands lsp-treemacs-errors-list)

;;(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

;; company: autocompletion
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; (use-package rustic
;;   :ensure t
;;   :custom
;;   (rustic-lsp-client 'lsp-mode))

(use-package magit
  :ensure t)

(use-package rg
  :ensure t)

;; Javascript

(use-package prettier-js
  :ensure t
  :config
  (add-hook 'js-mode-hook #'prettier-js-mode))

(use-package add-node-modules-path
  :ensure t
  :config
  (add-hook 'js-mode-hook #'add-node-modules-path))

(use-package web-mode
  :ensure t
  :mode ("\\.tsx?\\'" "\\.jsx?\\'")
  ;;  :hook (add-node-modules-path prettier-js-mode)
  :init
  (add-hook 'web-mode-hook #'add-node-modules-path)
  (add-hook 'web-mode-hook #'prettier-js-mode)
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (setq web-mode-code-indent-offset 2
	web-mode-markup-indent-offset 2
	web-mode-css-indent-offset 2))

;; python

(use-package poetry
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
			 (message "hihihi")
      			 (flycheck-disable-checker 'lsp)
                         (lsp))))  ; or lsp-deferred

(use-package python-black
  :ensure t)

;; Start server if not already runningo
(require 'server)
(unless (server-running-p)
  (server-start))

;; Enable MacOS fullscreen in title bar
(toggle-frame-fullscreen)
(toggle-frame-fullscreen)

(provide '.emacs)
;;; .emacs ends here
