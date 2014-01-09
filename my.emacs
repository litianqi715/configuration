;;individual
(setq user-full-name "Li Tianqi")
(setq user-mail-address "litianqi123@gmail.com")

;;display line number
(global-linum-mode 1)
;;jump to specific line
(global-set-key "\C-x\C-x" 'goto-line)
;;no-startup-message
(setq inhibit-startup-message t)
;;scroll-margin
(setq scroll-margin 3
      scroll-conservatively 10000)
;;indent-tab
(setq indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)
(setq tab-stop-list())
;;not-jump-to-another-paren-when-match
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;;mouse-avoidance
(mouse-avoidance-mode 'animate)
;;paste-from-clipboart
(setq x-select-enable-clipboard t)
;;auto-indent
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [return] 'newline-and-indent)
;;filename-ido
(ido-mode 1)
;(require 'template-simple)

;;;;yasnippet cedet company-mode auto-complete
;1yasnippet
(add-to-list 'load-path
	      "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
;2cedet
;;2.1make compile
;;2.2semantic
(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
;;(semantic-load-enable-code-helpers)
;(global-set-key [(control tab)] 'semantic-ia-complete-menu)
(setq semanticdb-project-roots
 (list (expand-file-name "/")))
;;(setq semantic-default-save-directory "~/.emacs.d/")
;3company-mode
(add-to-list 'load-path
	     "~/.emacs.d/plugins/company-mode")
(require 'company)
(dolist (hook (list
		'emacs-lisp-mode-hook
		'lisp-mode-hook
		'lisp-interaction-mode-hook
		'scheme-mode-hook
		'c-mode-common-hook
		'python-mode-hook
		'haskell-mode-hook
		'asm-mode-hook
		'emms-tag-editor-mode-hook
		'sh-mode-hook))
	 (add-hook hook 'company-mode))
(setq company-idle-delay nil)
;4auto-complete
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
:(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(ac-config-default)

;quick compile
(defun quick-c-compile ()
"A quick compile function for C"
(interactive)
(compile (concat "gcc " (buffer-name (current-buffer))))
)
(global-set-key [(f9)] 'quick-c-compile)

;;copy region or whole line
(global-set-key "\M-w"
    (lambda ()
      (interactive)
      (if mark-active
          (kill-ring-save (region-beginning)
                          (region-end))
          (progn
              (kill-ring-save (line-beginning-position)
                              (line-end-position))
              (message "copied line")))))
;;kill region or whole line
(global-set-key "\C-w"
                (lambda ()
                  (interactive)
                  (if mark-active
                      (kill-region (region-beginning)
                                   (region-end))
                    (progn
                      (kill-region (line-beginning-position)
                                   (line-end-position))
                      (message "killed line")))))

;;auto-complete-right-paren
(defun auto-pair ()
   (interactive)
   (make-local-variable 'skeleton-pair-alist)
   (setq skeleton-pair-alist '(
        (?` ?` _ "''")
        (?\( _ ")")
        (?\[ _ "]")
        (?{ \n > _ \n ?} >)
        (?\" _ "\"")))
   (setq skeleton-pair t)
   (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
   (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
   (local-set-key (kbd "'") 'skeleton-pair-insert-maybe)
   (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
   (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe))

;;abbrev
;; M-SPC not available, window manager take it away
(global-set-key (kbd "M-'") 'just-one-space)
(global-set-key (kbd "C-M-=") 'pde-indent-dwim)
;; nearest key to dabbrev-expand
(global-set-key (kbd "M-;") 'hippie-expand)
(global-set-key (kbd "C-;") 'comment-dwim)
(global-set-key (kbd "C-c f") 'comint-dynamic-complete)

(setq hippie-expand-try-functions-list
	            '(try-expand-line
				  try-expand-dabbrev
	              try-expand-line-all-buffers
	              try-expand-list
	              try-expand-list-all-buffers
	              try-expand-dabbrev-visible
	              try-expand-dabbrev-all-buffers
	              try-expand-dabbrev-from-kill
				  try-complete-file-name
	              try-complete-file-name-partially
	              try-complete-lisp-symbol
				  try-complete-lisp-symbol-partially
				  try-expand-whole-kill))
(autoload 'comint-dynamic-complete "comint" "Complete for file name" t)
(setq comint-completion-addsuffix '("/" . ""))
(setq-default indent-tabs-mode nil)

;;--------- Perl mode ------;;
;; specific-for-cperl
(defun pde-perl-mode-hook ()
    (abbrev-mode t)
	(add-to-list 'cperl-style-alist
	'("PDE"
	 (cperl-auto-newline                         . t)
	 (cperl-brace-offset                         . 0)
	 (cperl-close-paren-offset                   . -4)
	 (cperl-continued-brace-offset               . 0)
	 (cperl-continued-statement-offset           . 4)
	 (cperl-extra-newline-before-brace           . nil)
	 (cperl-extra-newline-before-brace-multiline . nil)
	 (cperl-indent-level                         . 4)
	 (cperl-indent-parens-as-block               . t)
	 (cperl-label-offset                         . -4)
	 (cperl-merge-trailing-else                  . t)
	 (cperl-tab-always-indent                    . t)))
	(cperl-set-style "PDE"))
;;default-cperl-mode
(defalias 'perl-mode 'cperl-mode)
;grammer-highlight
(global-font-lock-mode 1)
;auto-pair
(add-hook 'cperl-mode-hook 'auto-pair)
(add-hook 'perl-mode-hook 'auto-pair)

;(set-face-foreground 'region "cyan")
;(set-face-background 'region "blue")
;(set-face-foreground 'secondary-selection "skyblue")
;(set-face-background 'secondary-selection "darkblue")
