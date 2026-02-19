;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((org-mode :url "https://code.tecosaur.net/tec/org-mode" :branch
	       "dev")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8363207a952efb78e917230f5a4d3326b2916c63237c1f61d7e5fe07def8d378"
     default))
 '(package-selected-packages
   '(affe company company-box copilot doom-modeline eat eca
	  evil-collection gruvbox-theme lsp-mode lsp-treemacs lsp-ui
	  multi-cursor multiple-cursors orderless org-mode projectile
	  quelpa typescript-mode verb vertico vterm))
 '(package-vc-selected-packages
   '((copilot :url "https://github.com/copilot-emacs/copilot.el" :branch
	      "main"))))






;; You will most likely need to adjust this font size for your system!
(defvar runemacs/default-font-size 130)

(setopt inhibit-startup-message t)

(menu-bar-mode 0)              ;; Hide the menu bar
(tool-bar-mode 0)              ;; Hide the tool bar
(scroll-bar-mode 0)
(tab-bar-mode 1)

(set-face-attribute 'default nil :font "JetBrains Mono" :height runemacs/default-font-size)


(require 'package)
(setopt package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(setopt use-package-always-ensure t)

(use-package gnu-elpa-keyring-update)


(use-package vterm)
;; copy kulala key
(use-package org :load-path "~/.emacs.d/elpa/org-mode/lisp/"
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package verb)

(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setopt evil-want-keybinding nil)
  (setopt evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

;; (evil-ex-define-cmd "q" 'kill-current-buffer)

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setopt evil-want-integration t)
  ;; (setopt evil-want-minibuffer t)
  (evil-collection-init))
;; evil-delete-backward-word

(use-package general)
(use-package eca)

(general-define-key "C-w" 'backward-kill-word)
;; comment with gc and gcc
(general-define-key
 :states 'motion
 ;; swap ; and :
 ";" 'evil-ex
 ":" 'evil-repeat-find-char)

;; (general-create-definer my-leader-def
;;   ;; :prefix my-leader
;;   :prefix "SPC"
;;   )
;; 

;; I doesn't know how to unbind specific mode.
;; (general-unbind 'minibuffer-mode-map
;;   "C-n")
(general-unbind 
  "C-u"
  "C-n")
;; this work because I unbind it before lsp?
(general-def "C-u" 'evil-scroll-up)

(general-define-key
 :states 'normal
 :keymaps 'override
 :prefix "SPC"
 "f" 'affe-find
 ;; some more projectile like?
 ;; "," 'switch-to-buffer
 )

;; (my-leader-def
;;     :states '(normal visual motion)
;; ;;   ;; "f" '(:ignore t :which-key "files")
;;    ;; (general-auto-unbind-keys t)
;;    "ff" 'affe-find)
;;  "fr" 'recentf-open-files
;;  "b" '(:ignore t :which-key "buffers")
;;  "bb" 'switch-to-buffer
;;  "bd" 'kill-this-buffer
;;  "w" '(:ignore t :which-key "windows")
;;  "ws" 'split-window-below
;;  "wv" 'split-window-right
;;  "wd" 'delete-window
;;  "wh" 'windmove-left
;;  "wl" 'windmove-right
;;  "wk" 'windmove-up
;;  "wj" 'windmove-down)
  

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-hard))

;; src: https://kristofferbalintona.me/posts/202206071000/
(add-to-list 'default-frame-alist '(alpha-background . 95))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; src: http://xahlee.info/emacs/emacs/emacs_env_var_paths.html
;; (setpath "PATH"
;;         (concat
;;          "/home/ionize13/go/bin" path-separator
;;          (getenv "PATH")))

(defun efs/lsp-mode-setup ()
  (setopt lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (setopt gc-cons-threshold 100000000)
  (setopt read-process-output-max (* 1024 1024)) ;; 1mb
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setopt lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

;; src: https://s10a.net/posts/2024-12-02-setting-up-emacs-for-golang/
;; src: http://xahlee.info/emacs/emacs/emacs_env_var_paths.html
(use-package go-mode
   :init
  (setenv "GOPATH" (expand-file-name "~/go"))
  (setenv "PATH" (concat (getenv "PATH") path-separator (expand-file-name "~/go/bin")))
  (add-to-list 'exec-path (expand-file-name "~/go/bin"))
  :config
  (setopt go-indent-level 2))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setopt typescript-indent-level 2))

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main")
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
	      ("C-j" . 'copilot-accept-completion)
	      ("C-S-j" . 'copilot-accept-completion-by-word)))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("C-i" . company-complete-selection))
;;  :config
;;  (setopt company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
;;  company-echo-metadata-frontend))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))
(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package vertico
  :config (vertico-mode)
  :general-config
  ("C-n" 'vertico-next
   "C-p" 'vertico-previous)
  )

(use-package consult)

(use-package affe
  :config
  (setopt affe-count 10000000))

;; (general-define-key
;;  :keymaps 'override
;;  "C-b" '(:keymap projectile-command-map :package projectile))
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :general
  ;; (:keymaps 'override
  ;;   "C-b" '(:keymap projectile-command-map :package projectile))
  (:keymaps 'override
    "C-c p" '(:keymap projectile-command-map))
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/github.com/")
    (setq projectile-project-search-path '("~/github.com")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package multiple-cursors)
; (global-unset-key (kbd "M-<down-mouse-1>"))
; (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring


(general-def
  :prefix "C-b"
  :keymaps 'override
  "n" 'tab-next
  "p" 'tab-previous)


(add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))

(add-hook 'go-mode-hook #'lsp)

;; src: https://christiantietze.de/posts/2020/10/shorten-yes-or-no-emacs/
(fset 'yes-or-no-p 'y-or-n-p)

;; https://github.com/kyagi/shell-pop-el
;; I think I can do C-S-v in vterm mode
;; add bun to env or exec path
;; what is exec path
