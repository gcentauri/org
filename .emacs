
(require 'cl-lib) ;; common lisp primitives added to emacs-lisp
(setq initial-buffer-choice "~/org/home.org")

(global-set-key (kbd "C-c h")
                (lambda () (interactive) (find-file "~/org/home.org")))

;; my own custom elisp directory
(add-to-list 'load-path "~/.emacs.d/elisp")
;; PACKAGES ---------------------------
(require 'package)
;; package repositories ---------------
;;---- setup MELPA repository ------------------------------
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(setq required-packages
      (list
       'ac-geiser          ;; Auto-complete backend for geiser
       'afternoon-theme    ;; Dark color theme with a deep blue background
       'ample-theme        ;; Calm Dark Theme for Emacs
       'ample-zen-theme    ;; AmpleZen Theme for Emacs 24
       'arjen-grey-theme   ;; A soothing dark grey theme
       'auto-complete      ;; Auto Completion for GNU Emacs
       'autopair           ;; automagically pair braces and quotes.
       'autumn-light-theme ;; A light color theme with muted, autumnal colors.
       'badger-theme       ;; A dark theme for Emacs 24.
       'badwolf-theme      ;; Bad Wolf color theme
       'birds-of-paradise-plus-theme ;; A brown/orange light-on-dark theme for Emacs 24 (deftheme).
       'bliss-theme        ;; an Emacs 24 theme based on Bliss (tmTheme)
       'charmap            ;; Unicode table for Emacs
       'company            ;; complete anything, auto complete system
       'deft               ;; mode for quickly browsing, filtering, and editing directories of plain text notes.
       'elscreen           ;; screen like functionality for emasc
       'faceup             ;; Regression test system for font-lock
       'fsm                ;; state machine library
       'geiser             ;; GNU Emacs and Scheme talk to each other
       'haxe-mode          ;; An Emacs major mode for Haxe
       'hc-zenburn-theme   ;; An higher contrast version of the Zenburn theme.
       'jabber             ;; A Jabber client for Emacs.
       'jinja2-mode        ;; A major mode for jinja2
       'labburn-theme      ;; A lab color space zenburn theme.
       'list-unicode-display ;; Search for and list unicode characters by name
       'lua-mode           ;; lua editing mode for emacs
       'markdown-mode      ;; Major mode for Markdown-formatted text
       'melancholy-theme   ;; A dark theme for dark minds
       'paredit            ;; minor mode for editing parentheses.
       'popup              ;; Visual Popup User Interface
       'racket-mode        ;; Major mode for Racket language.
       'rainbow-blocks     ;; Block syntax highlighting for lisp code
       'rainbow-mode       ;; Colorize color names in buffers.
       'rainbow-delimiters ;; Highlight brackets according to their depth
       's                  ;; The long lost Emacs string manipulation library.
       'slime              ;; Emacs mode for Common Lisp development.
       'w3m                ;; an Emacs interface to w3m
       'zenburn-theme      ;; A low contrast color theme for Emacs.
       'zerodark-theme     ;; A dark, medium contrast theme for Emacs
       ))

(defun packages-installed-p ()
  (cl-loop for p in required-packages
        when (not (package-installed-p p)) do (cl-return nil)
        finally (return t)))

;; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(fringe-mode '(6 . 0))
(toggle-frame-fullscreen)
(require 'rand-theme)
(setq rand-theme-wanted
      '(base16-nord base16-eighties base16-3024
        base16-rebecca base16-flat base16-apathy))
(rand-theme)
(set-face-attribute 'default t :font "Roboto Mono-10")
(set-frame-font "Roboto Mono-10" nil t)

(setq org-return-follows-link t) ;; return key will follow links in org mode
(define-key global-map "\C-cl" 'org-store-link) ;; use C-c C-l to paste stored links
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t) ;; timestamps when a task is marked DONE
(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/org/organizer.org")))
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-default-notes-file "~/org/notes.org")
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (plantuml . t)
   (python . t)))
(global-set-key (kbd "C-x g") 'magit-status)
;;;; override osx default opening directories in finder
;;(add-to-list 'org-file-apps '(directory . emacs))
;;;; sample file-type specific override
;;(add-to-list 'org-file-apps '("\\.md\\'" . emacs))
;;(setq w3m-command "/usr/local/bin/w3m")
;;(exec-path-from-shell-initialize)
(require 'w3m)

(setq w3m-use-cookies t) ;; enable cookies
(setq w3m-use-tab t) ;; allow tabs

(setq browse-url-browser-function 'w3m-browse-url
      browse-url-new-window-flag t)

(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

(global-set-key "\C-xm" 'browse-url-at-point) ;; optional keyboard short-cut

(w3m)
(define-key w3m-mode-map (kbd "i") 'w3m-previous-buffer)
(define-key w3m-mode-map (kbd "o") 'w3m-next-buffer)
(cd "~")
(eshell)

(elscreen-start)
(require 'lakota-input)
(add-hook 'after-init-hook 'global-company-mode)
(ido-mode 1)

(add-hook 'emacs-lisp-mode-hook (lambda () (paredit-mode 0) (rainbow-delimiters-mode +1)))
(add-hook 'lisp-mode-hook (lambda () (paredit-mode 0) (rainbow-delimiters-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode 0) (rainbow-delimiters-mode +1)))
(add-hook 'scheme-mode-hook (lambda () (paredit-mode 0) (rainbow-delimiters-mode +1)))
;;(add-hook 'ruby-mode-hook 'robe-mode)
;;(add-hook 'ruby-mode-hook 'smartparens-mode)
;;(eval-after-load 'company
;;  '(push 'company-robe company-backends))
;;(rvm-use-default)
;;(setq rspec-use-rvm t)
(setq auto-mode-alist (append '(("\\.p8?$" . lua-mode))
                              auto-mode-alist))
;;(require 'funda-haxe-mode "~/.emacs.d/funda-haxe-mode/funda-haxe-mode.el")
;;(setq funda-haxe-indent-offset 2)

(setq org-plantuml-jar-path (expand-file-name "~/bin/plantuml.jar"))

(setq xah-fly-use-control-key nil)
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty") ; required if you use qwerty
(xah-fly-keys 1)
