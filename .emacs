;; remove visual clutter
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)

;; font
(set-face-attribute 'default nil
		    :font "Overpass Mono"
		    :height 160)

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
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

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
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

(windmove-default-keybindings)

(setq mac-option-modifier 'super)
(setq mac-pass-command-to-system nil)

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
  (setq ivy-re-builders-alist
	'((t . ivy--regex-fuzzy)))
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file))

(use-package flx
  :ensure t)

(use-package ivy-hydra
  :ensure t)

;; evil mode
;; (use-package evil
;;   :ensure t
;;   :init
;;   (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
;;   (setq evil-want-keybinding nil)
;;   :config
;;   (evil-mode 1))
;;
;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   :config (evil-collection-init))

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
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 ;;         (XXX-mode . lsp)
	 ;;(rustic-mode . lsp)
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
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook #'yas-minor-mode-on))

(use-package lsp-ui
   :ensure t
   :commands lsp-ui-mode)

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

(add-hook 'clojure-mode-hook 'lsp)
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

;; (use-package rustic
;;   :ensure t
;;   :custom
;;   (rustic-lsp-client 'lsp-mode))

(require 'server)
(unless (server-running-p)
  (server-start))

