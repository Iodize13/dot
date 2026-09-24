(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
   (load custom-file))

(defvar my/default-font-size 162)
(defvar my/default-variable-font-size 162)

(setopt inhibit-startup-message t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(tab-bar-mode 1)
(setopt tab-bar-format '(tab-bar-format-tabs-groups tab-bar-separator tab-bar-format-align-right tab-bar-format-global))
;; src: https://def.lakaban.net/2023-03-05-high-quality-scrolling-emacs/
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-scroll-amount-horizontal 1)
;; Make native horizontal scroll (tilt/trackpad-swipe) respect the
;; horizontal amount, not the vertical scroll amount.  By default
;; mwheel-scroll only uses mouse-wheel-scroll-amount-horizontal when
;; shift is held.
(advice-add 'mwheel-scroll :around
	    (lambda (orig-fun event &optional arg)
              (let ((button (event-basic-type event)))
                (if (memq button '(mouse-6 mouse-7 wheel-left wheel-right))
                    (let ((mouse-wheel-scroll-amount
                           (list mouse-wheel-scroll-amount-horizontal))
                          (mouse-wheel-progressive-speed nil))
                      (funcall orig-fun event arg))
                  (funcall orig-fun event arg)))))
(setopt scroll-margin 8)
(setopt scroll-conservatively 101)
(setopt display-line-numbers-type 'relative)
(setopt display-line-numbers-width 3)
(global-display-line-numbers-mode t)
;; src: https://christiantietze.de/posts/2020/10/shorten-yes-or-no-emacs/
(fset 'yes-or-no-p 'y-or-n-p)
;; src: https://www.reddit.com/r/emacs/comments/v2s9wh/folding/
(add-hook 'prog-mode-hook (lambda ()
			    (hs-minor-mode)
			    (hs-hide-all)))

(add-hook 'before-save-hook
	  (lambda ()
	    (let ((dir (file-name-directory buffer-file-name)))
	      (unless (file-exists-p dir)
		(make-directory dir t)))))

;; (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height my/default-font-size)
(set-face-attribute 'default nil :font "JetBrains Mono Thai" :height my/default-font-size)

(set-face-attribute 'variable-pitch nil
		    :font "CMU Serif"
		    :height my/default-variable-font-size
		    :weight 'regular)

;; Thai font setup: Noto Sans Thai scaled to match JetBrainsMono's ascent.
;; JM ascent=1020, NST ascent=1061 → scale 0.96 makes Thai text same visual
;; size. Descent will be slightly deeper (-432 vs -300), but ascent matching
;; is what prevents Thai lines from appearing taller than English.
;; try librefont later
;; no just default font that not noto sans thai
;; /usr/share/emacs/30.2/etc/.emac
;; (set-fontset-font "fontset-default" 'thai "Noto Sans Thai")
;; (add-to-list 'face-font-rescale-alist '("Noto Sans Thai" . 1))

;; Force Thai combining marks to width 1.
;; Emacs classifies Thai vowels/tone marks as width=0 (Unicode Mn category),
;; but modern terminals (wezterm, kitty) render them occupying a full cell.
;; Without this, lazysql and other TUIs misalign Thai rows in vterm.
;; (dolist (range '((#x0E31 . #x0E31)    ; ั  MAI HAN AKAT
;;                  (#x0E34 . #x0E3A)    ; ิ ี ึ ื ุ ู ฺ  SARA I → PHINTHU
;;                  (#x0E47 . #x0E4E)))  ; ่ ้ ๊ ๋ ์ ํ ๎  tone marks + diacritics
;;   (set-char-table-range char-width-table range 1))

;; ;; Increase word spacing in variable-pitch-mode using display table
;; (defun my/variable-pitch-word-spacing ()
;;   "Add extra spacing between words in variable-pitch-mode."
;;   (when variable-pitch-mode
;;     (setq-local buffer-display-table
;;		   (let ((dt (or buffer-display-table (make-display-table))))
;;		     ;; Make regular spaces display with extra pixel width
;;		     (aset dt ?\s (vector (make-glyph-code ?\s 'variable-pitch)))
;;		     dt))
;;     ;; Use justification or word-wrap to add visual spacing
;;     (setq-local word-wrap t)))

;; Load pywal colors and apply to UI faces
;; (defun my/load-pywal-colors ()
;;   "Load accent color from pywal colors file and apply to UI faces."
;;   (interactive)
;;   (let* ((wal-file (expand-file-name "~/.cache/wal/colors"))
;;	    (accent-color (if (file-exists-p wal-file)
;;			      (with-temp-buffer
;;				(insert-file-contents wal-file)
;;				(goto-char (point-min))
;;				(forward-line 15)
;;				(string-trim (thing-at-point 'line t)))
;;			    "#59fe00"))
;;	    (bg (if (file-exists-p wal-file)
;;			      (with-temp-buffer
;;				(insert-file-contents wal-file)
;;				(goto-char (point-min))
;;				(forward-line 0)
;;				(string-trim (thing-at-point 'line t)))
;;			    "#111111"))
;;	    (color1 (if (file-exists-p wal-file)
;;			      (with-temp-buffer
;;				(insert-file-contents wal-file)
;;				(goto-char (point-min))
;;				(forward-line 0)
;;				(string-trim (thing-at-point 'line t)))
;;			    "#222222")))
;;     (custom-set-faces
;;	`(tab-bar-tab ((t (:background ,accent-color :foreground ,bg :box nil))))
;;	`(tab-bar-tab-inactive ((t (:background ,color1 :foreground ,accent-color :box nil))))
;;	`(tab-bar ((t (:background ,bg :foreground ,accent-color :box nil))))
;;	`(mode-line ((t (:background bg :foreground ,accent-color :box nil)))))))

;; src: https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
(setq-default bidi-display-reordering 'left-to-right
	      bidi-paragraph-direction 'left-to-right)
(setopt bidi-inhibit-bpa t)
(setopt redisplay-skip-fontification-on-input t)
(setq-default cursor-in-non-selected-windows nil)
(setopt highlight-nonselected-windows nil)
(setopt save-interprogram-paste-before-kill t)
(setopt help-window-select t)
(setopt default-input-method "thai-kesmanee")

;; (require 'color)
(defun my/load-pywal-colors ()
   "Load accent colors from pywal and apply to UI faces efficiently."
  (interactive)
  (let* ((wal-file (expand-file-name "~/.cache/wal/colors"))
	 (colors (when (file-exists-p wal-file)
		   (with-temp-buffer
		     (insert-file-contents wal-file)
		     (split-string (buffer-string) "\n" t))))
	 ;; Fallback to defaults if wal-file doesn't exist
	 (bg	       (if colors (nth 0 colors) "#111111"))
	 (color1       (if colors (nth 1 colors) "#222222"))
	 (color2       (if colors (nth 2 colors) "#333333"))
	 (accent-color (if colors (nth 15 colors) "#59fe00"))
	 (color-neg1     (color-darken-name bg 75)))

    (custom-set-faces
     `(tab-bar-tab ((t (:background ,bg :foreground ,accent-color :box nil))))
     `(tab-bar-tab-inactive ((t (:background ,color-neg1 :foreground ,color1 :box nil))))
     `(tab-bar ((t (:background ,color-neg1 :foreground ,color1 :box nil))))
     `(default ((t (:background ,bg :foreground ,accent-color :box nil))))
     `(mode-line ((t (:box nil))))
     `(fringe ((t (:background ,bg :foreground ,accent-color :box nil))))
     `(line-number ((t (:background ,bg :foreground ,color1 :box nil))))
     `(line-number-current-line ((t (:background ,color1 :foreground ,accent-color :box nil))))
     `(powerline-active0 ((t (:foreground ,bg :weight bold :background ,accent-color))))
     `(powerline-active0-modified ((t (:foreground "#af3a03" :background ,accent-color))))
     `(powerline-active1 ((t (:foreground ,accent-color :background ,color2))))
     `(powerline-active2 ((t (:foreground ,accent-color :weight bold :background ,bg))))
     `(powerline-inactive0 ((t (:background ,bg :weight bold))))
     )))
;; can this be defer?
(add-hook 'after-init-hook #'my/load-pywal-colors)
;; (add-hook 'variable-pitch-mode-hook #'my/variable-pitch-word-spacing)

					; Alternative: Use variable-pitch with extra line spacing for readability
;; (defun my/variable-pitch-line-spacing ()
;;   "Add extra line spacing when in variable-pitch-mode."
;;   (setq-local line-spacing 0.2))

(add-hook 'variable-pitch-mode-hook #'my/variable-pitch-line-spacing)

					; src: https://github.com/benleis1/emacs-init
(setopt
 backup-by-copying t	  ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves/"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(setopt package-archives
		'(("melpa" . "https://melpa.org/packages/")
		  ("nongnu" . "https://elpa.nongnu.org/nongnu/")
		  ("elpa" . "https://elpa.gnu.org/packages/")))
;; Pin simple-httpd to a version compatible with clomacs 20220415.
;; Version 20260519+ breaks ejc-sql with "bufferp, #<process httpd>".
;; (setq package-pinned-packages '((simple-httpd . "20201102.1452")))
(package-initialize)
(setopt use-package-always-ensure t)

(use-package gnu-elpa-keyring-update)
;; copy kulala key
(use-package org :load-path "~/.emacs.d/elpa/org-mode/lisp/"
   :config
  (define-key org-mode-map (kbd "C-c r") verb-command-map)
  ;; https://www.youtube.com/watch?v=PNE-mgkZ6HM
  (setq org-log-done 'time)
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sql . t)))
  (setq org-confirm-babel-evaluate nil)
  )
;; Pre-load org-capture at startup: the first `org-capture' call in a
;; fresh daemon hits a load-order bug in this org-mode build where
;; `org-capture-templates' is referenced before its defcustom runs,
;; signalling void-variable and aborting `yequake-org-capture' silently.
(require 'org-capture)
(setopt org-capture-templates
	'(("t" "tasks" entry (file "~/note.org")
           "* TODO %?\t  %U")))
(setopt org-tag-alist
		'(("Qualiva" . ?q)
		  ("Blog" . ?b)
		  ("Shopping" . ?s)
		  ("Agentic" . ?v)
		  ("Univerisity". ?u))
	)
(setopt org-agenda-files '("~/note.org"))
(add-hook 'org-capture-mode-hook #'evil-insert-state)

(use-package verb)
;; hs-toggle-hiding uses `posn-set-point' from mouse events, which
;; moves point unpredictably when called from the keyboard.  Drop
;; the event handling so toggle works from anywhere in the block.
(defun my/hs-toggle-hiding ()
   "Toggle hiding/showing of a block.  Works from anywhere in the block."
  (interactive)
  (if (hs-already-hidden-p)
      (hs-show-block)
    (hs-hide-block)))

(use-package general)
(use-package evil
   :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setopt evil-want-keybinding nil)
  (setopt evil-undo-system 'undo-redo)
  (setopt evil-insert-state-cursor nil)
  :config
  (evil-mode 1)
  :general
  (general-def '(normal visual)
    "C-a" )
  ;; (general-def 'motion
  ;;   ";" 'evil-ex
  ;;   ":" 'evil-repeat-find-char)
  (general-def 'normal
    "n" (lambda () (interactive) (evil-search-next) (evil-scroll-line-to-center (line-number-at-pos)))
    "N" (lambda () (interactive) (evil-search-previous) (evil-scroll-line-to-center (line-number-at-pos))))
  ;; src: https://www.reddit.com/r/emacs/comments/9jbgbz/evil_mode_copy_and_paste_question/
  (general-def 'visual :keymaps 'override
    "SPC p" (general-simulate-key "\"_dP" :keymap nil :lookup nil :name me:simulate-paste-without-yank))
  (general-def '(normal visual) :keymaps 'override
    "SPC d" (general-simulate-key "\"_d" :keymap nil :lookup nil :name me:simulate-delete-to-black-hole-reg))
  (general-def 'normal
    "z a" 'my/hs-toggle-hiding)
  )
(add-hook 'after-save-hook
	  #'executable-make-buffer-file-executable-if-script-p)

;; C-a for vim increment
;; src: https://www.reddit.com/r/emacs/comments/uwk9kx/make_q_or_wq_not_killl_emacs_in_evil_mode/
(evil-ex-define-cmd "q" 'kill-this-buffer)
(defun kill-this-buffer()(interactive)(kill-current-buffer))

(use-package move-text
   :config
  (defun my/move-text-and-indent (direction)
    "Moves the region and re-indents."
    (let ((deactivate-mark nil)) ; Keeps the region highlighted after moving
      (if (eq direction 'down)
	  (move-text-down (region-beginning) (region-end) 1)
	(move-text-up (region-beginning) (region-end) 1))
      (indent-region (region-beginning) (region-end))))
  :general
  (general-def 'visual :keymaps 'override
    "J" (lambda () (interactive) (my/move-text-and-indent 'down))
    "K" (lambda () (interactive) (my/move-text-and-indent 'up))
    )
  )

;; (evil-ex-define-cmd "q" 'kill-current-buffer)
(use-package evil-collection
   :after evil
  :config
  (setopt evil-want-integration t)
  ;; (setopt evil-want-minibuffer t)
  ;; check does next line necessary
  ;; (setopt evil-collection-mode-list '(magit process list))
  (evil-collection-init))
(use-package evil-little-word
   :after evil
  :init
  (unless (file-exists-p (expand-file-name "site-lisp/evil-plugins/" user-emacs-directory))
    (shell-command
     (format "git clone https://github.com/tarao/evil-plugins.git %s"
	     (expand-file-name "site-lisp/evil-plugins/" user-emacs-directory))))
  (add-to-list 'load-path (expand-file-name "site-lisp/evil-plugins/" user-emacs-directory))
  :load-path "site-lisp/evil-plugins"
  :bind (:map evil-motion-state-map
	      ("w" . evil-forward-little-word-begin)
	      ("b" . evil-backward-little-word-begin)
	      ("e" . evil-forward-little-word-end)
	      ("ge" . evil-backward-little-word-end)
	      :map evil-visual-state-map
	      ("w" . evil-forward-little-word-begin)
	      ("b" . evil-backward-little-word-begin)
	      :map evil-operator-state-map
	      ("w" . evil-forward-little-word-begin)
	      ("b" . evil-backward-little-word-begin)
	      ))
(use-package evil-commentary
   :init
  (evil-commentary-mode))
(use-package evil-numbers
   :vc (:url "https://github.com/cofi/evil-numbers"
             :rev :newest
             :branch "master")
  :general
  (general-def '(normal visual) :prefix "C-c"
    "=" 'evil-numbers/inc-at-pt
    "-" 'evil-numbers/dec-at-pt))
;; this actually bad for cp. remember that time acidentally C-a and add bug to program?
(use-package vterm
					; :hook
  ;; (vterm-mode . (lambda () (display-line-numbers-mode -1)))
					; (vterm-mode . (lambda () (evil-emacs-state)))
					; :config
  :custom
  ;; Official emacs-libvterm dynamic naming path: vterm listens for the
  ;; terminal title sent by the shell/program (OSC 0/2 escape sequences) and
  ;; substitutes that title for %s.  This means buffer names update for shells
  ;; and TUIs that set the terminal title, without polling process state.
  ;;
  ;; Shell side examples:
  ;;   bash: PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }"'printf "\033]0;%s:%s\007" "$HOSTNAME" "$PWD"'
  ;;   zsh:  autoload -U add-zsh-hook; add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }
  ;; Many TUIs also set the title themselves, which vterm will pick up here.
  (vterm-buffer-name-string "*vterm: %s*")
  ;; Use SOV_monospace for vterm so Latin and Thai share the same advance width
  ;; (both 500/1000 upem), ensuring terminal TUI column alignment.
  ;; JB at height 130 gives 78 char-width units; SOV at 500/1000 needs 156.
  ;;   (defun my/vterm-set-font ()
  ;;     (face-remap-add-relative
  ;;      'default '(:family "SOV_monospace" :height 156)))
  ;;      'default '(:family "Noto Sans Thai" :height 156)))
  ;; (add-hook 'vterm-mode-hook #'my/vterm-set-font)
  ;; :config
  ;; (setopt vterm-ignore-blink-cursor t)
  :general-config
  ;; vterm buffers are in evil `insert' state (not `emacs' state, despite
  ;; the `evil-emacs-state' hook below - evil-collection's vterm setup
  ;; resets it to insert), so a `general-def 'emacs' binding here is never
  ;; active. Bind directly in `vterm-mode-map' so it applies regardless of
  ;; evil state.
  (general-def :keymaps 'vterm-mode-map
    "C-w" (lambda () (interactive) (vterm-send-key (kbd "C-w")))
    "C-S-v" #'vterm-yank))
(add-hook 'vterm-mode-hook #'evil-emacs-state nil)

(use-package olivetti)
(use-package treemacs
   :hook
  (treemacs-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (setopt treemacs-width 30)
  (setopt treemacs-indentation 1))
(with-eval-after-load 'lsp-treemacs
   (setopt lsp-treemacs-errors-position-params
           '((side . bottom)
             (slot . 1)
             (window-height . 0.35)))
  (defun my/lsp-treemacs-errors-list--goto-current-file (orig-fun &rest args)
    "Call ORIG-FUN, move point to the current file's errors."
    (interactive)
    (let ((current-file (buffer-file-name)))
      (apply orig-fun args)
      (when current-file
        (let ((err-win (get-buffer-window lsp-treemacs-errors-buffer-name)))
          (when err-win
            (with-selected-window err-win
              (goto-char (point-min))
              (when (re-search-forward
                     (concat (regexp-quote (file-name-nondirectory current-file)) " [0-9]")
                     nil t)
                (beginning-of-line)
                (ignore-errors
                  (let ((btn (treemacs-node-at-point)))
                    (when (and btn (not (treemacs-is-node-expanded? btn)))
                      (treemacs-expand-extension-node))))
                (recenter))))))))
  (advice-add 'lsp-treemacs-errors-list :around #'my/lsp-treemacs-errors-list--goto-current-file)
  :general-config
  (general-def :states 'normal "SPC i" 'treemacs)
  (general-def :states 'normal :keymaps 'treemacs-mode-map
    "d" 'treemacs-delete-file
    "a" 'treemacs-create-file
    "+" 'treemacs-create-dir
    "r" 'treemacs-rename)
  )
(use-package treemacs-projectile)
(use-package treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")
(use-package treemacs-evil)
(use-package dirvish
   :init
  (dirvish-override-dired-mode)
  :hook
  (dired-mode . (lambda () (display-line-numbers-mode -1)))
  (dirvish-special-preview-mode . (lambda () (display-line-numbers-mode -1)))
  (dirvish-directory-view-mode . (lambda () (display-line-numbers-mode -1)))
  (dirvish-misc-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (require 'dirvish-icons)
  (setopt dirvish-attributes '(all-the-icons file-size))
  :general-config
  (general-def 'normal dirvish-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file
    ;; "r" 'dirvish-history-jump	 ; recent dirs
    "f" 'dirvish-file-info-menu
    "TAB" 'dirvish-subtree-toggle
    ;; "M-f" 'dirvish-history-go-forward ; forward in history
    ;; "M-b" 'dirvish-history-go-backward ; back in history
    "?" 'dirvish-dispatch
    "SPC ." 'find-file
    )
  )

(dirvish-define-preview ls (file)
   "Use `ls' to generate directory preview."
  (when (file-directory-p file)
    `(shell . ("ls" "-a1" "--color=always" "--group-directories-first" ,file))))
(push 'ls dirvish-preview-dispatchers)

(use-package all-the-icons)
(use-package gruvbox-theme
   :init
  (load-theme 'gruvbox)
  ;; :custom-face
  ;; (font-lock-comment-face ((t (:slant italic))))
  )


;; ── Gruvbox colours for mu4e buffers (per-buffer face remapping) ──
;; Palette from gruvbox-dark-hard (does NOT swap the global theme).

;; (defvar-local my/mu4e--gruvboxified nil)

;; (defun my/mu4e--gruvboxify-buffer ()
;;   "Remap faces in the current mu4e buffer to gruvbox-dark-hard colors."
;;   (unless my/mu4e--gruvboxified
;;     (setq my/mu4e--gruvboxified t)
;;     ;; Core
;;     (face-remap-add-relative 'default
;;       '(:background "#1d2021" :foreground "#ebdbb2"))
;;     ;; General UI
;;     (face-remap-add-relative 'hl-line
;;       '(:background "#3c3836"))
;;     (face-remap-add-relative 'region
;;       '(:background "#504945"))
;;     (face-remap-add-relative 'fringe
;;       '(:background "#1d2021"))
;;     (face-remap-add-relative 'vertical-border
;;       '(:foreground "#504945"))
;;     (face-remap-add-relative 'line-number
;;       '(:foreground "#665c54" :background "#1d2021"))
;;     (face-remap-add-relative 'line-number-current-line
;;       '(:foreground "#fabd2f"))
;;     ;; Modeline (applies when this buffer is displayed)
;;     (face-remap-add-relative 'mode-line
;;       '(:background "#3c3836" :foreground "#ebdbb2"))
;;     (face-remap-add-relative 'mode-line-inactive
;;       '(:background "#282828" :foreground "#7c6f64"))
;;     ;; mu4e-specific
;;     (face-remap-add-relative 'mu4e-header-face
;;       '(:foreground "#a89984"))
;;     (face-remap-add-relative 'mu4e-header-key-face
;;       '(:foreground "#83a598"))
;;     (face-remap-add-relative 'mu4e-highlight-face
;;       '(:background "#504945" :foreground "#ebdbb2"))
;;     (face-remap-add-relative 'mu4e-unread-face
;;       '(:foreground "#ebdbb2" :weight bold))
;;     (face-remap-add-relative 'mu4e-flagged-face
;;       '(:foreground "#fabd2f"))
;;     (face-remap-add-relative 'mu4e-replied-face
;;       '(:foreground "#83a598"))
;;     (face-remap-add-relative 'mu4e-link-face
;;       '(:foreground "#b8bb26"))
;;     (face-remap-add-relative 'mu4e-title-face
;;       '(:foreground "#ebdbb2"))
;;     (face-remap-add-relative 'mu4e-contact-face
;;       '(:foreground "#d3869b"))
;;     (face-remap-add-relative 'mu4e-footer-face
;;       '(:foreground "#7c6f64"))
;;     ;; Composing
;;     (face-remap-add-relative 'message-header-name
;;       '(:foreground "#83a598"))
;;     (face-remap-add-relative 'message-header-other
;;       '(:foreground "#a89984"))
;;     (face-remap-add-relative 'message-cited-text-1
;;       '(:foreground "#d3869b"))
;;     (face-remap-add-relative 'message-cited-text-2
;;       '(:foreground "#b8bb26"))
;;     (face-remap-add-relative 'message-cited-text-3
;;       '(:foreground "#fabd2f"))
;;     (face-remap-add-relative 'message-cited-text-4
;;       '(:foreground "#83a598"))))

;; (add-hook 'mu4e-headers-mode-hook #'my/mu4e--gruvboxify-buffer)
;; (add-hook 'mu4e-view-mode-hook    #'my/mu4e--gruvboxify-buffer)
;; (add-hook 'mu4e-main-mode-hook    #'my/mu4e--gruvboxify-buffer)
;; (add-hook 'mu4e-compose-mode-hook #'my/mu4e--gruvboxify-buffer)
;; src: https://kristofferbalintona.me/posts/202206071000/
;; #b8bb26
;; (add-to-list 'default-frame-alist '(alpha-background . 88))
;; (use-package doom-modeline
;;   :config
;;   (progn
;;     (setopt doom-modeline-check nil)
;;     (setopt doom-modeline-enable-buffer-position nil)
;;     )
;;   :init (doom-modeline-mode 1)
;;   )
(use-package powerline
   :config
  (setq powerline-default-separator nil))
(defface powerline-active0-modified
   '((t (:foreground "#ffaf00")))
  "Powerline face for modified buffers."
  :group 'powerline)

(defun powerline-jr0cket-theme ()
   "Customisation of the default powerline theme"
  (interactive)
  (setq-default mode-line-format
		'("%e"
		  (:eval
		   (let* (
			  (active (powerline-selected-window-active))
			  (mode-line (if active 'mode-line 'mode-line-inactive))
			  (face0 (if active (if (buffer-modified-p) 'powerline-active0-modified 'powerline-active0) 'powerline-inactive0))
			  (face1 (if active 'powerline-active1 'powerline-inactive1))
			  (face2 (if active 'powerline-active2 'powerline-inactive2))
			  (separator-left
			   (intern
			    (format "powerline-%s-%s"
				    powerline-default-separator
				    (car powerline-default-separator-dir))))
			  (separator-right
			   (intern (format "powerline-%s-%s"
					   powerline-default-separator
					   (cdr powerline-default-separator-dir))))
			  (lhs (list (powerline-raw "%*" face0 'l)
				     (powerline-buffer-id face0 'l)
				     (when (and (boundp 'which-func-mode) which-func-mode)
				       (powerline-raw which-func-format face0 'l))
				     (powerline-narrow face0 'l)
				     (funcall separator-left face0 face1)
				     (when (boundp 'erc-modified-channels-object)
				       (powerline-raw erc-modified-channels-object face1 'l))
				     (powerline-major-mode face1 'l)
				     (powerline-process face1)
				     (powerline-raw " " face1 'r)
				     (powerline-minor-modes face1 'l)
				     (powerline-narrow face1)
				     (funcall separator-left face1 face2)
				     (powerline-vc face2 'r)))
			  (rhs (list (powerline-raw global-mode-string face2 'r)
				     (funcall separator-right face2 face1)
				     (powerline-raw (if current-input-method
							(concat " " current-input-method-title)
						      "")
						    face1)
				     (powerline-raw "%l" face1)
				     (powerline-raw ":" face1)
				     (powerline-raw "%c" face1)
				     (funcall separator-right face1 face0)
				     (powerline-raw "%p" face0)
				     (powerline-hud face2 face1))))
		     (concat (powerline-render lhs)
			     (powerline-fill face2 (powerline-width rhs))
			     (powerline-render rhs)))))))

(powerline-jr0cket-theme)

					; src: http://xahlee.info/emacs/emacs/emacs_env_var_paths.html
					; (setpath "PATH"
					;         (concat
					;          "/home/ionize13/go/bin" path-separator
					;          (getenv "PATH")))

					; src: https://github.com/daviwil/emacs-from-scratch
(defun my/lsp-mode-setup ()
   ;; (setopt lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (setopt gc-cons-threshold 100000000)
  (setopt read-process-output-max (* 1024 1024)) ;; 1mb
  ;; (lsp-headerline-breadcrumb-mode)
  )
;; eglot is built into Emacs — no custom config needed.
;; Default `eglot-server-programs' entry groups js/ts/tsx modes
;; together with correct :language-id mappings.
;; (use-package eglot
;;   :ensure nil)
(use-package treesit
   :mode (("\\.js\\'"  . typescript-ts-mode)
          ("\\.mjs\\'" . typescript-ts-mode)
          ("\\.mts\\'" . typescript-ts-mode)
          ("\\.cjs\\'" . typescript-ts-mode)
          ("\\.ts\\'"  . typescript-mode)
          ("\\.jsx\\'" . tsx-ts-mode)
          ("\\.json\\'" .  json-ts-mode)
          ("\\.Dockerfile\\'" . dockerfile-ts-mode)
          ("\\.prisma\\'" . prisma-ts-mode)
          ;; More modes defined here...
          )
  :preface
  (defun os/setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (bash "https://github.com/tree-sitter/tree-sitter-bash")
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
               (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
               (markdown "https://github.com/ikatyang/tree-sitter-markdown")
               (make "https://github.com/alemuller/tree-sitter-make")
               (elisp "https://github.com/Wilfred/tree-sitter-elisp")
               (cmake "https://github.com/uyha/tree-sitter-cmake")
               (c "https://github.com/tree-sitter/tree-sitter-c")
               (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
               (toml "https://github.com/tree-sitter/tree-sitter-toml")
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
               (prisma "https://github.com/victorhqc/tree-sitter-prisma")))
      (add-to-list 'treesit-language-source-alist grammar)
      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  (dolist (mapping
           '((python-mode . python-ts-mode)
             (css-mode . css-ts-mode)
             (js-mode . typescript-ts-mode)
             (js2-mode . typescript-ts-mode)
             (c-mode . c-ts-mode)
             (c++-mode . c++-ts-mode)
             (c-or-c++-mode . c-or-c++-ts-mode)
             (bash-mode . bash-ts-mode)
             (css-mode . css-ts-mode)
             (json-mode . json-ts-mode)
             (js-json-mode . json-ts-mode)
             (sh-mode . bash-ts-mode)
             (sh-base-mode . bash-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))
  :config
  (os/setup-install-grammars))

(use-package tsx-mode
   :load-path "site-lisp/tsx-mode"
  :mode ("\\.tsx\\'" . tsx-mode)
  :hook ((tsx-mode . lsp-deferred)
         (tsx-mode . treesit-fold-mode)))

(use-package lsp-mode
   ;; :commands (lsp lsp-deferred)
  :hook ((lsp-mode . my/lsp-mode-setup)
	 ((tsx-ts-mode
	   typescript-ts-mode
	   js-ts-mode) . lsp-deferred))
  :init
  (setopt lsp-keymap-prefix "C-c l"
          lsp-enable-document-color nil) ;; vtsls doesn't support colorProvider)
  :custom
  (lsp-enable-which-key-integration t)
  (lsp-enable-folding nil)
  :config
  ;; vtsls as TS/JS language server (lower RAM than typescript-language-server).
  ;; Wrapped with emacs-lsp-booster for I/O caching.
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       (cons "emacs-lsp-booster"
                             '("--disable-bytecode" "--" "vtsls" "--stdio"))))
    :activation-fn #'lsp-typescript-javascript-tsx-jsx-activate-p
    :priority 1
    :completion-in-comments? t
    :server-id 'vtsls))

  ;; Register custom settings for vtsls (typescript.tsdk etc.)
  ;; These are served via workspace/configuration requests.
  (lsp-register-custom-settings
   '(("typescript.tsdk" "node_modules/typescript/lib")
     ("typescript.tsserver.maxTsServerMemory" 2048)
     ("vtsls.autoUseWorkspaceTsdk" t t)))

  ;; sqls (built into lsp-mode via lsp-sqls.el) gives schema-aware
  ;; completion for table/column names, not just keywords. Auth is
  ;; via the unix socket, matching the CLI's passwordless setup.
  (setq lsp-sqls-connections
        '(((driver . "mysql")
           (dataSourceName . "ionize13@unix(/run/mysqld/mysqld.sock)/insee_6403_sql_part2_db")))))
(add-hook 'sql-mode-hook #'lsp-deferred)

;; Also activate lsp for tree-sitter TSX buffers
(dolist (mode '(tsx-ts-mode typescript-ts-mode js-ts-mode))
   (add-hook (intern (format "%s-hook" mode)) #'lsp-deferred))

(use-package lsp-ui
   :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point))
(use-package lsp-treemacs
   :after lsp
  :general
  (general-def 'normal :keymaps 'lsp-treemacs-mode-map
    ;; "q" 'treemacs-quit
    ;; "g r" 'lsp-treemacs-references
    ;; "g d" 'lsp-treemacs-definitions
    "g i" 'lsp-treemacs-implementations)
  )

(add-to-list 'display-buffer-alist
	     '("\\*xref\\*"
               (display-buffer-in-side-window)
               (side . right)
               (window-width . 0.4)))

;; src: https://s10a.net/posts/2024-12-02-setting-up-emacs-for-golang/
;; src: http://xahlee.info/emacs/emacs/emacs_env_var_paths.html

;; Fix Emacs 30.2 bug: several typescript-ts-mode font-lock queries
;; have syntax errors that crash ALL subsequent highlighting.
;; Workaround 1: wrap per-feature fontification to ignore individual query errors.
;; Workaround 2: prevent Emacs from disabling font-lock after query errors.
(with-eval-after-load 'typescript-ts-mode
   (defun my/treesit-fontify-tolerant (orig-fun &rest args)
     "Call ORIG-FUN but ignore treesit-query-error (broken features)."
     (condition-case nil
         (apply orig-fun args)
       (treesit-query-error nil)))
  (advice-add 'treesit--font-lock-fontify-region-1 :around
              #'my/treesit-fontify-tolerant)
  ;; Re-enable font-lock if Emacs disables it after errors.
  (defvar my/ts-font-lock-rearming nil
    "Guard against recursive font-lock toggling.")
  (defun my/ts-rearm-font-lock ()
    "Re-enable font-lock in TS/TSX buffers if it was disabled."
    (when (and (derived-mode-p 'typescript-ts-mode 'tsx-ts-mode)
               (not font-lock-mode)
               (not my/ts-font-lock-rearming))
      (let ((my/ts-font-lock-rearming t))
        (font-lock-mode 1))))
  (add-hook 'font-lock-mode-hook #'my/ts-rearm-font-lock))

(with-eval-after-load 'lsp-mode
   (defun my/lsp-find-implementation-skip-single ()
     "Find implementations. Jump directly if only one result, else show xref."
     (interactive)
     (let ((loc (lsp-request "textDocument/implementation"
                             (lsp--text-document-position-params))))
       (if (null loc)
           (lsp--error "No implementations found for: %s"
                       (or (thing-at-point 'symbol t) ""))
         (if (null (cdr loc))
             (progn
               (unless (region-active-p) (push-mark nil t))
               (xref-push-marker-stack)
               (lsp-goto-location (car loc))
               (with-selected-window (selected-window)
                 (recenter)))
           (lsp-show-xrefs (lsp--locations-to-xref-items loc) nil t))))))


(use-package go-mode
   :init
  (setenv "GOPATH" (expand-file-name "~/go"))
  (setenv "PATH" (concat (getenv "PATH") path-separator (expand-file-name "~/go/bin")))
  (add-to-list 'exec-path (expand-file-name "~/go/bin"))
  (setopt go-indent-level 2)
  :config
  (defun my/lsp-hover-tooltip ()
    "Show LSP hover info as tooltip at cursor, like mouse hover."
    (interactive)
    (lsp-request-async
     "textDocument/hover"
     (lsp--text-document-position-params)
     (lambda (hover)
       (when-let ((contents (lsp:hover-contents hover)))
	 (tooltip-show (lsp--render-on-hover-content contents t))))
     :mode 'tick))
  :general
  (general-def 'normal :keymaps 'go-mode-map
    "g d" 'lsp-find-definition
    "g i" 'my/lsp-find-implementation-skip-single
    "g r" 'lsp-find-references
    "SPC t p" 'lsp-treemacs-errors-list
    "K" 'my/lsp-hover-doc-at-point)
  (general-def 'normal
    "SPC t p" 'treemacs-quit)
  )
(defun my/go-abbreviate-imenu-label (label)
   "Strip Go receiver notation from an imenu LABEL string.
Handles both LSP format '(*Type).Method' and go-mode format '(recv) Method(...)'.
Both → just 'Method'."
  (if (stringp label)
      (cond
       ;; go-mode regex format: (receiver) Method(args) → Method
       ((string-match "^(.*) +\\([^ \t\n(]+\\)" label)
        (substring label (match-beginning 1) (match-end 1)))
       ;; LSP format: (*Type).Method → Method
       ((string-match "^([^)]+)\\.\\(.+\\)" label)
        (substring label (match-beginning 1) (match-end 1)))
       (t label))
    label))

(defun my/go-abbreviate-imenu-index (index)
   "Recursively abbreviate Go receivers in imenu INDEX tree."
  (cond
   ((null index) nil)
   ((consp index)
    (let ((car-val (car index))
          (cdr-val (cdr index)))
      (cons (if (consp car-val)
                (my/go-abbreviate-imenu-index car-val)
              (my/go-abbreviate-imenu-label car-val))
            (if (listp cdr-val)
                (my/go-abbreviate-imenu-index cdr-val)
              cdr-val))))
   (t index)))

(defun my/go-lsp-imenu-create-index (symbols)
   "Create imenu from Go SYMBOLS, stripping pointer receivers.
Wraps `lsp-imenu-create-uncategorized-index' and post-processes the labels."
  (my/go-abbreviate-imenu-index
   (lsp-imenu-create-uncategorized-index symbols)))

(defun my/go-imenu-create-index-fallback ()
   "Fallback imenu index for Go (non-LSP), using go-mode regex + receiver stripping."
  (my/go-abbreviate-imenu-index
   (imenu--generic-function
    '(("type" "^type +\\([^ \t\n\r\f]+\\)" 1)
      ("func" "^func +\\(.*\\) {" 1)))))

(add-hook 'go-mode-hook #'lsp)
;; Override LSP's imenu index function for Go to abbreviate pointer receivers.
;; `lsp-after-open-hook' fires after the LSP server initializes (and after
;; `lsp-enable-imenu' sets up `imenu-create-index-function').
(add-hook 'lsp-after-open-hook
	  (lambda ()
            (when (derived-mode-p 'go-mode)
              (setq-local lsp-imenu-detailed-outline nil)
              (setq-local lsp-imenu-index-function #'my/go-lsp-imenu-create-index))))
;; Fallback for non-LSP Go buffers — set imenu-create-index-function.
;; Uses advice (not hook) to survive treemacs' hook suppression.
(advice-add 'go-mode :after
	    (lambda ()
              (setq-local imenu-create-index-function #'my/go-imenu-create-index-fallback)))

(use-package typescript-mode
   :mode "\\.ts\\'"
  ;; :hook (typescript-mode . lsp-deferred)
  :hook (typescript-mode . lsp-deferred)
  :config
  (setopt typescript-indent-level 2))
(use-package ansi-color
   :ensure nil)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; (use-package copilot
;;   :vc (:url "https://github.com/copilot-emacs/copilot.el"
;;             :rev :newest
;;             :branch "main")
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;; 	      ("C-j" . 'copilot-accept-completion)
;; 	      ("C-S-j" . 'copilot-accept-completion-by-word))
;;   :config
;;   (setopt copilot-indent-offset-warning-disable t)
;;   )
(use-package magit
   ;; :hook
  ;; (magit-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (defun my/enable-insert-and-copilot ()
    (evil-insert-state 1)
    (copilot-mode 1))
  (add-hook 'git-commit-setup-hook #'my/enable-insert-and-copilot)
  )
(use-package smerge
   :ensure nil
  :general
  (general-def 'normal
    "g RET" 'smerge-keep-current))
(use-package forge
   :after magit
  )
(setq auth-sources '("~/.authinfo.gpg"))

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
  (setopt completion-ignore-case t)
  :general-config
  (general-def
    "C-n" 'vertico-next
    "C-p" 'vertico-previous)
  )

(use-package consult)
(use-package affe
   :config
  (defun my/affe-grep-at-point ()
    "Search with affe using word under cursor."
    (interactive)
    (let ((word (thing-at-point 'symbol t)))
      (affe-grep nil word)))
  (setopt affe-count 10000000)
  :general
  (general-def 'normal
    "SPC ." 'affe-find
    "SPC *" 'my/affe-grep-at-point)
  )

;; (general-define-key
;;  :keymaps 'override
;;  "C-b" '(:keymap projectile-command-map :package projectile))
;; (use-package projectile
;;   :diminish projectile-mode
;;   :config (projectile-mode)
;;   ;; :general
;;   ;; ;; (:keymaps 'override
;;   ;; ;;   "C-b" '(:keymap projectile-command-map :package projectile))
;;   ;; (:keymaps 'override
;;   ;;   "C-c p" '(:keymap projectile-command-map))
;;   ;; :init
;;   (when (file-directory-p "~/github.com/")
;;     (setq projectile-project-search-path '("~/github.com")))
;;   (setq projectile-switch-project-action #'projectile-dired))
(use-package project
   :ensure nil
  :config
  (when (file-directory-p "~/github.com/")
    (setopt project-vc-extra-root-markers '(".git" ".dir-locals.el"))
    ;; Note: project.el doesn't "scan" in the background like Projectile.
    ;; It finds projects as you visit them or via `project-remember-projects-under`.
    (project-remember-projects-under "~/github.com/"))
  (setopt project-switch-commands #'project-dired)
  :general
  (general-def :keymaps 'override
    "C-c p" '(:keymap project-prefix-map)
    )
  (general-def 'normal :keymaps 'override
    :prefix "SPC"
    "f" 'project-find-file
    "," 'project-switch-to-buffer)
  )

(use-package multiple-cursors)
					; (global-unset-key (kbd "M-<down-mouse-1>"))
					; (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(use-package orderless
   :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package colorful-mode
   :custom
  (colorful-use-prefix t)
  (colorful-prefix-alignment 'right)
  (colorful-prefix-string " ")
  :config
  ;; Fix: Emacs 30 rejects negative :line-width in :box; override with valid value
  ;; (set-face-attribute 'colorful-base nil :box '(:line-width 1))
  )
(use-package web-mode)

(use-package blamer
   :ensure t
  :general
  (general-def 'normal
    "C-c i" 'blamer-show-commit-info
    )
  :defer 20
  )

(add-to-list 'display-buffer-alist
	     '("magit: .*" (display-buffer-same-window)))
;; Matches everything EXCEPT buffers starting with a space (internal emacs buffers)
;; (setq evil--jumps-buffer-targets "^[^ ].*")

(defvar my/tunnel-buffer "*qualiva-tunnel*"
   "Buffer for the SSH tunnel.")
(defvar my/tunnel-dir "~/github.com/qualiva/core/"
   "Project directory for the tunnel.")

(defun my/tunnel-start ()
   "Start the SSH tunnel in a named buffer."
  (interactive)
  (when (get-buffer-process my/tunnel-buffer)
    (error "Tunnel already running"))
  (let ((default-directory my/tunnel-dir))
    (start-process "tunnel" my/tunnel-buffer "make" "init-db"))
  (message "Tunnel started in %s" my/tunnel-buffer))

(defun my/tunnel-stop ()
   "Stop the SSH tunnel (SIGINT)."
  (interactive)
  (if-let ((proc (get-buffer-process my/tunnel-buffer)))
      (progn (interrupt-process proc) (message "Tunnel stopped"))
    (message "No tunnel running")))

(defun my/start-Go ()
   "Start the Go backend dev server."
  (interactive)
  (let ((compilation-buffer-name-function
         (lambda (_mode) "*Go-backend*")))
    (compile "make dev")))

(defun my/start-Bun ()
   "Start the Bun dev server with RAM monitoring, project-aware."
  (interactive)
  (if-let ((proj (project-current)))
      (let* ((proj-name (project-name proj))
             (proj-root (expand-file-name (project-root proj)))
             (buf-name (format "*Bun-dev<%s>*" proj-name))
             (compilation-buffer-name-function
              (lambda (_mode) buf-name))
             (default-directory proj-root))
        (compile (format "~/.local/bin/monitor-ram %s"
                         (shell-quote-argument proj-root))))
    (message "Can't detect project")))

(use-package exec-path-from-shell
   :config
  (exec-path-from-shell-initialize))
(setopt exec-path-from-shell-arguments '("-l" "-c" "echo $PATH"))

;; GUI/daemon sessions may inherit TERM=dumb (especially under EXWM/SXWM),
;; which breaks terminal-backed packages that probe terminfo.
(when (and (daemonp)
	   (or (not (getenv "TERM"))
               (string= (getenv "TERM") "dumb")))
  (setenv "TERM" "xterm-256color"))

(use-package which-key
   :config
  (which-key-mode))
(use-package git-timemachine)
;; src: https://systemcrafters.net/emacs-mail/
(use-package mu4e
   :ensure nil
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :defer 20
  :hook
  (mu4e-headers-mode . (lambda () (display-line-numbers-mode -1)))
  (mu4e-view-mode . (lambda () (display-line-numbers-mode -1)))
  (mu4e-main-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (setopt mu4e-change-filenames-when-moving t)
  (setopt mu4e-update-interval (* 10 60))
  (setopt mu4e-index-lazy-check t)
  (setopt mu4e-get-mail-command "mbsync -a")
  (setopt mu4e-maildir "~/Mail")

  (setopt mu4e-contexts
          (list
           (make-mu4e-context
            :name "Personal"
            :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
            :vars '((user-mail-address . "insee134@gmail.com")
                    (user-full-name    . "iodize13")
		    (mu4e-drafts-folder  . "/Gmail/[Gmail]/Drafts")
		    (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
		    (mu4e-refile-folder  . "/Gmail/[Gmail]/All Mail")
		    (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")))

	   (make-mu4e-context
	    :name "Cock.li"
	    :match-func
	    (lambda (msg)
	      (when msg
		(string-prefix-p "/Cock.li" (mu4e-message-field msg :maildir))))
	    :vars '((user-mail-address . "ionize@cock.li")
		    (user-full-name    . "ionize")
		    (mu4e-drafts-folder  . "/Cock.li/Drafts")
		    (mu4e-sent-folder  . "/Cock.li/Sent")
		    (mu4e-refile-folder  . "/Cock.li/Archive")
		    (mu4e-trash-folder  . "/Cock.li/Trash")))

           (make-mu4e-context
            :name "Uni"
            :match-func
            (lambda (msg)
              (when msg
		(string-prefix-p "/Uni" (mu4e-message-field msg :maildir))))
            :vars '((user-mail-address . "insee.t@kkumail.com")
                    (user-full-name    . "อินทรี ท้าวเพชร")
                    (mu4e-drafts-folder  . "/Uni/[Gmail]/Drafts")
                    (mu4e-sent-folder  . "/Uni/[Gmail]/Sent Mail")
                    (mu4e-refile-folder  . "/Uni/[Gmail]/All Mail")
                    (mu4e-trash-folder  . "/Uni/[Gmail]/Trash")
                    (message-send-mail-function . message-send-mail-with-sendmail)
                    (sendmail-program . "/usr/sbin/msmtp")
                    (message-sendmail-extra-arguments . ("-a" "uni")))))
	  )

  (setopt mu4e-maildir-shortcuts
	  '((:maildir "/Uni/Inbox"               :key ?u)
	    (:maildir "/Uni/[Gmail]/Sent Mail"   :key ?U)
	    (:maildir "/Uni/[Gmail]/Drafts"      :key ?w)
	    (:maildir "/Uni/[Gmail]/Trash"       :key ?e)
	    (:maildir "/Gmail/Inbox"             :key ?i)
	    (:maildir "/Gmail/[Gmail]/Sent Mail" :key ?s)
	    (:maildir "/Gmail/[Gmail]/Trash"     :key ?t)
	    (:maildir "/Gmail/[Gmail]/Drafts"    :key ?d)
	    (:maildir "/Gmail/[Gmail]/All Mail"  :key ?a)))

  ;; mu4e 1.14 thread prefixes: (ascii-fallback . unicode)
  ;; Force unicode on both sides so char-displayable-p can't trigger ASCII fallback
  (setopt mu4e-headers-thread-root-prefix           '("□ " . "□ "))
  (setopt mu4e-headers-thread-child-prefix          '("│ " . "│ "))
  (setopt mu4e-headers-thread-first-child-prefix    '("⚬ " . "⚬ "))
  (setopt mu4e-headers-thread-last-child-prefix     '("└ " . "└ "))
  (setopt mu4e-headers-thread-connection-prefix     '("│ " . "│ "))
  ;; (setopt mu4e-headers-thread-blank-prefix          '("  " . "  "))
  (setopt mu4e-headers-thread-orphan-prefix         '("♢ " . "♢ "))
  (setopt mu4e-headers-thread-single-orphan-prefix  '("♢ " . "♢ "))
  (setopt mu4e-headers-thread-duplicate-prefix      '("≡ " . "≡ "))
  )
;; (use-package wildcharm-theme
;;   :init
;;   (load-theme 'wildcharm t)
;;   :custom-face
;;   (font-lock-comment-face ((t (:slant italic)))))
(use-package smtpmail
   :ensure nil
  :config
  (setopt message-send-mail-function 'smtpmail-send-it
          smtpmail-stream-type 'starttls
	  smtpmail-default-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-service 587
          smtpmail-servers-requiring-authorization "smtp\\.gmail\\.com"
          smtpmail-smtp-user "insee134@gmail.com")
  (setopt message-kill-buffer-on-exit t)
  )
(setopt mml-secure-openpgp-signers '("62F680CE36721F1865508AB6392207ABF1937EAB"))
(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
(use-package mu4e-alert)
;; this should be inside use-package block
(mu4e-alert-set-default-style 'libnotify)
;; this can't?
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;; (after! wildcharm-theme
;;   (set-face-attribute 'header-line nil :extend nil))
(use-package shell-pop
   :config
  (defvar my/shell-pop-project-index-map (make-hash-table :test 'equal)
    "Map from project root to shell-pop instance index.")

  (defun my/shell-pop ()
    "Toggle a per-project shell-pop instance."
    (interactive)
    (if shell-pop--is-shell-buffer
        (shell-pop-out)
      (let* ((root (if-let ((proj (project-current)))
                       (project-root proj)
                     (file-name-as-directory (expand-file-name default-directory))))
             (index (or (gethash root my/shell-pop-project-index-map)
                        (puthash root (1+ (hash-table-count
                                           my/shell-pop-project-index-map))
                                 my/shell-pop-project-index-map)))
             (default-directory root)
             (shell-pop-autocd-to-working-dir t))
        (shell-pop index))))
  :bind (("C-c o" . my/shell-pop))
  :custom
  (shell-pop-universal-key "C-c o")
  (shell-pop-window-position "right")
  (shell-pop-full-span nil)
  (shell-pop-term-shell shell-file-name)
  (shell-pop-window-size 50)
  (shell-pop-shell-type '("vterm" "*vterm*"
                          (lambda ()
                            ;; Keep shell-pop's per-project vterm behavior, but
                            ;; create an actual vterm buffer so vterm's documented
                            ;; title-based renaming can run.
                            (when (fboundp 'vterm)
                              (let ((vterm-shell shell-pop-term-shell))
                                (vterm))))))
  (shell-pop-autocd-to-working-dir nil))
(use-package agent-shell
   :hook
  (agent-shell-mode . (lambda () (display-line-numbers-mode -1))))
(use-package ement)
;; (setopt ement-room-avatars t)
;; (use-package outline-indent)
;; (use-package yamal-mode)
(use-package tramp-rpc
   :after tramp
  :vc (:url "https://github.com/ArthurHeymans/emacs-tramp-rpc"
	    :rev :newest
	    :lisp-dir "lisp"))
(use-package eredis)
(use-package org-sidebar)
(use-package apheleia
   :config
  (add-to-list 'apheleia-formatters
               '(prettierd . ("prettierd" "--stdin-filepath" filepath
                              (apheleia-formatters-js-indent
                               "--use-tabs" "--tab-width"))))
  (setf (alist-get 'css-mode             apheleia-mode-alist) 'prettierd
        (alist-get 'css-ts-mode          apheleia-mode-alist) 'prettierd
        (alist-get 'html-mode            apheleia-mode-alist) 'prettierd
        (alist-get 'html-ts-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'js-mode              apheleia-mode-alist) 'prettierd
        (alist-get 'js-ts-mode           apheleia-mode-alist) 'prettierd
        (alist-get 'json-mode            apheleia-mode-alist) 'prettierd
        (alist-get 'json-ts-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'js3-mode             apheleia-mode-alist) 'prettierd
        (alist-get 'js-json-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'ruby-mode            apheleia-mode-alist) 'prettierd
        (alist-get 'ruby-ts-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'scss-mode            apheleia-mode-alist) 'prettierd
        (alist-get 'svelte-mode          apheleia-mode-alist) 'prettierd
        (alist-get 'tsx-ts-mode          apheleia-mode-alist) 'prettierd
        (alist-get 'typescript-mode      apheleia-mode-alist) 'prettierd
        (alist-get 'typescript-ts-mode   apheleia-mode-alist) 'prettierd
        (alist-get 'web-mode             apheleia-mode-alist) 'prettierd
        (alist-get 'yaml-mode            apheleia-mode-alist) 'prettierd
        (alist-get 'yaml-ts-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'graphql-mode         apheleia-mode-alist) 'prettierd
        (alist-get 'markdown-mode        apheleia-mode-alist) 'prettierd)
  (setopt apheleia-formatters-respect-indent-level nil)
  (apheleia-global-mode +1))
;; src: https://www.jamescherti.com/emacs-the-definitive-guide-to-code-folding/
(use-package kirigami
   :commands (kirigami-open-fold
              kirigami-open-fold-rec
              kirigami-close-fold
              kirigami-toggle-fold
              kirigami-open-folds
              kirigami-close-folds-except-current
              kirigami-close-folds)

  :bind
  (("C-c z o" . kirigami-open-fold)
   ("C-c z O" . kirigami-open-fold-rec)
   ("C-c z r" . kirigami-open-folds)
   ("C-c z c" . kirigami-close-fold)
   ("C-c z m" . kirigami-close-folds)
   ("C-c z a" . kirigami-toggle-fold)))
(with-eval-after-load 'evil
   (define-key evil-normal-state-map "zo" #'kirigami-open-fold)
  (define-key evil-normal-state-map "zO" #'kirigami-open-fold-rec)
  (define-key evil-normal-state-map "zc" #'kirigami-close-fold)
  (define-key evil-normal-state-map "za" #'kirigami-toggle-fold)
  (define-key evil-normal-state-map "zr" #'kirigami-open-folds)
  (define-key evil-normal-state-map "zm" #'kirigami-close-folds))
(use-package yequake)
(setq yequake-frames
           '(("vterm" .
              ;; integers (pixels), not floats: yequake computes float
              ;; width/height as a fraction of `frame-monitor-attributes' on
              ;; the *currently selected frame*, which at toggle time is the
              ;; daemon's non-graphical tty frame (~80x25), not the real
              ;; 1920x1080 display - that produced a tiny 96x132 frame.
              ((width . 1920)
               (height . 648)
               (alpha . 0.95)
               (buffer-fns . ((lambda ()
				;; `vterm-buffer-name-string' (set globally to
				;; "*vterm: %s*") renames this buffer away from
				;; "*yequake-vterm*" as soon as the shell sends its
				;; OSC title, so the next toggle's `get-buffer-create
				;; "*yequake-vterm*"' never finds it and spawns a
				;; fresh shell. Disable the rename for this buffer
				;; only, so it keeps its name and gets reused.
				(let* ((vterm-buffer-name "*yequake-vterm*")
                                       (buf (vterm)))
				  (with-current-buffer buf
				    (setq-local vterm-buffer-name-string nil))
				  buf))))
               (frame-parameters . ((undecorated . t)
				    (window-system . x)
				    (visibility . nil)))))
             ("org-capture" .
              ((width . 1440)
               (height . 540)
               (alpha . 0.95)
               ;; Pass the "n" key directly: `org-capture-select-template's
               ;; menu prompt loses X focus immediately under sxwm, which
               ;; blocks the daemon's command loop forever (wedging every
               ;; other emacsclient call) since keystrokes never arrive.
               (buffer-fns . ((lambda () (yequake-org-capture nil "t"))))
               (frame-parameters . ((undecorated . t)
				    (skip-taskbar . t)
				    (sticky . t)
				    (window-system . x)
				    (visibility . nil)))))))

;; `yequake-toggle's "hide if focused" check relies on `yequake-focused',
;; which is set by `focus-in-hook'/`focus-out-hook'. Under sxwm, floating
;; frames lose X focus almost immediately after being mapped, so
;; `yequake-focused' is usually nil by the time the next toggle runs - the
;; existing frame is then just re-focused (often landing on it iconified)
;; instead of hidden, and never closes. Toggle on visibility instead:
;; if any frame named NAME is visible (or iconified), close it; otherwise
;; show/create it via the normal `yequake-toggle'.
;; NOTE: only bound for "vterm". For "org-capture", `delete-frame' on a
;; frame with an unfinalized capture buffer can trigger a blocking
;; "abort capture?" confirmation that the unfocused frame can't answer,
;; wedging the daemon - so org-capture keeps the plain `yequake-toggle'.
(defun my/yequake-toggle (name)
   (if-let* ((frames (seq-filter (lambda (f)
                                   (and (equal (frame-parameter f 'name) name)
					(frame-visible-p f)))
                                 (frame-list))))
       (mapc #'delete-frame frames)
     (yequake-toggle name)))

;; sxwm floats a window immediately (without ever tiling it) if
;; _NET_WM_WINDOW_TYPE is UTILITY/DIALOG/etc. at map time, and centers it
;; at its requested size. The frame is created invisible (visibility . nil
;; above) so this property can be set before it's ever mapped, avoiding a
;; tile-then-float flash and the wrong (tiled) size that came with it.
;; Match on yequake's own frame names (the keys in yequake-frames) - don't
;; override `name` in frame-parameters, since yequake uses it via
;; make-frame-names-alist to find/toggle the frame.
;; Both frames stay centered: sxwm re-centers floating windows on every
;; map (not just first creation), so any post-hoc reposition to the top
;; would cause a visible centered->top jump on each toggle.
(add-hook 'after-make-frame-functions
	  (lambda (frame)
            (when (member (frame-parameter frame 'name) '("vterm" "org-capture"))
              (x-change-window-property "_NET_WM_WINDOW_TYPE"
                                        (list "_NET_WM_WINDOW_TYPE_UTILITY")
                                        frame "ATOM" 32 t)
              (make-frame-visible frame))))

;; s g T inste
(general-def
   'normal
  :prefix "C-b"
  :keymaps 'magit-mode-map
  "n" 'tab-next
  "p" 'tab-previous
  "c" 'tab-new)
(general-def
   :keymaps 'org-mode-map
  "C-c r e" 'verb-send-request-on-point-other-window)
;; (general-unbind :keymaps 'minibuffer-mode-map "C-n")
;; (general-unbind :keymaps 'go-mode-map "g d")
;; read windowmove autounbind
(general-def :keymaps 'override
   "C-/" 'help-command
  "C-l" 'windmove-right
  "C-k" 'windmove-up
  "C-j" 'windmove-down
  "C-w" 'backward-kill-word)
(general-def 'normal :keymaps 'override
   ;; src: https://stackoverflow.com/questions/7826844/how-do-i-rebind-the-emacs-help-key-normally-bound-to-c-h-and-f1
  "C-u" 'evil-scroll-up
  "C-h" 'windmove-left
  "g t" 'tab-line-switch-to-next-tab
  "g T" 'tab-line-switch-to-prev-tab)
(general-def 'normal
   "SPC ." 'find-file
  "SPC D" 'dirvish
  "SPC <" 'switch-to-buffer)

(general-def "C-S-w" 'tab-close)
(general-def 'normal
   :prefix "C-b"
  "n" 'tab-next
  "p" 'tab-previous
  "c" 'tab-new)
(general-def 'normal
   :prefix "SPC t"
  "s" 'my/tunnel-start
  "x" 'my/tunnel-stop
  "b" 'my/ejc-table-browser)
(general-def 'normal
   :prefix "SPC s"
  "g" 'my/start-Go
  "b" 'my/start-Bun)
(general-def :keymaps 'flymake-mode-map
   :prefix "M-g"
  "n" 'flymake-goto-next-error
  "p" 'flymake-goto-prev-error)
;; auto close lsp window?
(with-eval-after-load 'magit
   (general-def
     :states '(normal motion)
     :keymaps 'override
     :prefix "C-b"
     "n" 'tab-next
     "p" 'tab-previous
     "c" 'tab-new)
  (general-def
    :states '(normal motion)
    :keymaps 'override
    "SPC i" 'treemacs
    "SPC D" 'dirvish
    "SPC ." 'find-file
    )

  ;; Force C-b to be NULL in magit specifically to stop it from scrolling
  (general-def 'motion magit-mode-map
    "C-b" nil))
(with-eval-after-load 'go-mode
   (general-def :states 'normal :keymaps 'go-mode-map
     "g d" 'lsp-find-definition
     "g i" 'my/lsp-find-implementation-skip-single
     "g r" 'lsp-find-references
     "SPC t p" 'lsp-treemacs-errors-list
     "K" 'my/lsp-hover-doc-at-point)
  (general-def :states 'normal
    "SPC t p" 'treemacs-quit))
;; (general-create-definer my-leader-def
;;   ;; :prefix my-leader
;;   :prefix "SPC"
;;   )
;;


;; (my-leader-def
;;     :states '(normal visual motion)
;; ;;   ;; "f" '(:ignore t)
;;    ;; (general-auto-unbind-keys t)
;;    "ff" 'affe-find)
;;  "fr" 'recentf-open-files
;;  "b" '(:ignore t)
;;  "bb" 'switch-to-buffer
;;  "bd" 'kill-this-buffer
;;  "w" '(:ignore t)
;;  "ws" 'split-window-below
;;  "wv" 'split-window-right
;;  "wd" 'delete-window
;;  "wh" 'windmove-left
;;  "wl" 'windmove-right
;;  "wk" 'windmove-up
;;  "wj" 'windmove-down)


;; misc
(add-hook 'c++-mode-hook (lambda () (copilot-mode -1)))

;; (add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))

;; https://github.com/kyagi/shell-pop-el
;; I think I can do C-S-v in vterm mode
;; add bun to env or exec path
;; what is exec path

;; src: https://www.djcbsoftware.nl/code/mu/mu4e/Gmail-configuration.html

;; src: https://www.djcbsoftware.nl/code/mu/mu4e/Gmail-configuration.html
;; src: https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/

(with-eval-after-load 'lsp-ui-doc
   (defun lsp-ui-doc--extract (contents)
     "Extract documentation, using lsp-mode's render path for markdown."
     (if (and (lsp-markup-content? contents)
              (string= (lsp:markup-content-kind contents) lsp/markup-kind-markdown))
         ;; Use the same render path as lsp-describe-thing-at-point
         (lsp--render-on-hover-content contents t)
       ;; Original logic for other content types
       (cond
	((vectorp contents)
         (mapconcat 'lsp-ui-doc--extract-marked-string
                    (lsp-ui-doc--filter-marked-string (seq-filter #'identity contents))
                    "\n\n"))
	((and (lsp-marked-string? contents)
              (lsp:marked-string-language contents))
         (lsp-ui-doc--extract-marked-string (lsp:marked-string-value contents)
                                            (lsp:marked-string-language contents)))
	((stringp contents)
         (lsp-ui-doc--extract-marked-string contents lsp/markup-kind-markdown))
	((lsp-marked-string? contents) (lsp-ui-doc--extract-marked-string contents))
	((and (lsp-markup-content? contents)
              (string= (lsp:markup-content-kind contents) lsp/markup-kind-plain-text))
         (lsp:markup-content-value contents))))))
;; evil state display are kinda important
;; default agent shell to deepseek high
;; keybinding for agent shell C-c a ...
