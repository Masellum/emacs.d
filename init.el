(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
 			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(helm-completion-style 'emacs)
 '(package-selected-packages
   '(powerline evil-nerd-commenter switch-window helm-projectile projectile flycheck nord-theme smooth-scrolling flyspell-correct-helm flyspell-lazy evil evil-leader helm js2-mode org)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq use-package-always-ensure t)

;; Install packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(let ((my-package-list '(evil evil-leader evil-nerd-commenter flycheck flyspell-correct-helm helm helm-projectile keyfreq nord-theme org projectile smooth-scrolling switch-window undo-tree)))
  (dolist (pack my-package-list)
          (unless (package-installed-p pack)
            (package-install pack))))

;; Theme settings
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))

(defun load-nord-theme (frame)
  (with-selected-frame frame
     (load-theme 'nord t)))

(if (daemonp)
  (add-hook 'after-make-frame-functions #'load-nord-theme)
  (load-theme 'nord t))

(require 'powerline)
(powerline-default-theme)

;; global minor mode
(global-display-line-numbers-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)


(require 'evil)
(evil-mode 1)

(require 'evil-leader)
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(require 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

(require 'flyspell-correct-helm)

(require 'switch-window)

;; Smooth scroll
(setq scroll-margin 5
      scroll-conservatively 9999
      scroll-step 1)


;; <leader> settings
(evil-leader/set-key
  ";"  #'flyspell-correct-wrapper
  "bn" 'next-buffer
  "bp" 'previous-buffer
  "wh" 'evil-window-left
  "wj" 'evil-window-down
  "wk" 'evil-window-up
  "wl" 'evil-window-right
  "X2" 'split-window-vertically
  "X3" 'split-window-horizontally
  "Xd" 'delete-window
  "xo" 'switch-window
  "x1" 'switch-window-then-maximize
  "x2" 'switch-window-then-split-below
  "x3" 'switch-window-then-split-right
  "x0" 'switch-window-then-delete
  "xd" 'switch-window-then-dired
  "xb" 'switch-window-then-display-buffer
  "bx" 'kill-buffer-and-window
  "P"  'projectile-command-map)

;; evil-nerd-commenter
;; Emacs key bindings
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "C-c l") 'evilnc-quick-comment-or-uncomment-to-the-line)
(global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

;; Vim key bindings
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
;;  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
;;  "cc" 'evilnc-copy-and-comment-lines
;;  "cp" 'evilnc-comment-or-uncomment-paragraphs
;;  "cr" 'comment-or-uncomment-region
;;  "cv" 'evilnc-toggle-invert-comment-line-by-line
;;  "."  'evilnc-copy-and-comment-operator
;;  "\\" 'evilnc-comment-operator ; if you prefer backslash key
  )

;; Flyspell mode
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; <ESC> quits
(defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)


;; Key frequent settings
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
(setq keyfreq-excluded-commands
      '(self-insert-command
	forward-char
	backward-char
	previous-line
	next-line
	evil-next-line
	evil-previous-line
	evil-ex-delete-backward-char
	helm-next-line
	helm-confirm-and-exit-minibuffer))

;; Indent with spaces instead of tabs
(setq-default tab-width 4 indent-tabs-mode nil)

;; Disable backup files
(setq make-backup-files nil)

(projectile-mode +1)
(define-key projectile-command-map (kbd "h") #'helm-projectile)
