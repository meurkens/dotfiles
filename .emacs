;; TODO
;; - Window size
;; - Clojure/Cider
;; - JS/TS
;; - Ivy
;; - Rg
;; - Show whitespace
;; - Org
;; - Magit dotfiles
;; - Ruby
;; - Modularize


;; Initialize melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


;; INTERFACE
;; =========

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t))

;; Remove clutter
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)

;; Font
(set-face-attribute 'default nil
                    :font "Overpass Mono"
                    :height 140)

(global-display-line-numbers-mode)

;; Turn off audio
(setq ring-bell-function 'ignore)


;; SYSTEM
;; ======

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))


;; GENERAL
;; =======

;; Store all backup and autosave files in the tmp dir
(make-directory "~/.emacs.d/tmp/" t)
(setq backup-directory-alist
      `((".*" . "~/.emacs.d/tmp/")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/tmp/" t)))
(setq backup-by-copying t)
(setq create-lockfiles nil)

;; Customs in another file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)


;; BINDINGS
;; ========

(keymap-global-set "M-F" 'toggle-frame-fullscreen)

;; EDITING
;; =======

;; Spaces for tabs
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'untabify)

;; Trailling whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; Type and copy over region
(delete-selection-mode t)


;; PACKAGES
;; ========

(use-package diminish
  :ensure t
  :config (diminish 'eldoc-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :init (projectile-mode t)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (which-key-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :custom (flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package magit
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-headerline-breadcrumb-enable nil)
  :commands lsp)

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-s l" . consult-line)
         ("M-s r" . consult-ripgrep)))

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :ensure t
  :init (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


;; LANGUAGES
;; =========

(defun install-format-before-save ()
  (add-hook 'before-save-hook 'lsp-format-buffer nil 'local))

(use-package haskell-mode
  :ensure t
  :hook ((haskell-mode . lsp)
         (haskell-mode . install-format-before-save)
         (haskell-mode . interactive-haskell-mode)))

(use-package lsp-haskell
  :ensure t
  :custom
  (lsp-haskell-formatting-provider "fourmolu")
  :after (lsp-mode))
