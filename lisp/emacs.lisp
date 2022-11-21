;;Hey if you're reading this it means you want to edit your emacs session
;;there should be a file called .emacs in ~/ so just add any lines of code into
;;that file. If you haven't already guess the ; is a comment

;;Setup Matlab.el file
(autoload 'matlab-mode "~/matlab.el" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "~/matlab.el" "Interactive Matlab mode." t) 

;;Setup R-Mode
(setq auto-mode-alist (cons '("\\.R\\'" . python-mode) auto-mode-alist))

;;Setup Arduino Mode
(autoload 'arduino-mode "~/arduino-mode.el" "Enter Arduino mode." t)
(setq auto-mode-alist (cons '("\\.ino\\'" . arduino-mode) auto-mode-alist))
;;Use the same mode for Processing Files
(setq auto-mode-alist (cons '("\\.pde\\'" . arduino-mode) auto-mode-alist))

;;Setup ncl.el file by just using lisp-mode. It's close enough
(setq auto-mode-alist (cons '("\\.ncl\\'" . lisp-mode) auto-mode-alist))

;;Turn on auto-fill-mode automatically when a latex file is opened
(add-hook 'latex-mode-hook 'turn-on-auto-fill)
(add-hook 'latex-mode-hook 'flyspell-mode)

;;Create C-Return keymap for CTRL-x o - Makes it easier to switch windows
(define-key global-map [(control return)] 'other-window)

;;Create Complie Command
(define-key global-map [(control q)] 'compile)

;;Remove Toolbar from Emacs windows
(tool-bar-mode -1)

;;Disable uppercase and downcase region - I hate accidentally doing this
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;make toggle truncate line a default
(set-default 'truncate-lines t)

;;Make default font size something different
(set-face-attribute 'default nil :height 110)

;;Comment and Uncomment Regions
(define-key global-map [(control /)] 'comment-region)
(define-key global-map [(control o)] 'uncomment-region)

;;;Aspell AspellWindows
;;;http://www.emacswiki.org/emacs/

(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
;;(setq ispell-personal-dictionary ".ispell")
(require 'ispell)

;;Set default coding to unix (ONLY IN YOU'RE ON WINDOWS)
;(setq default-buffer-file-coding-system 'utf-8-unix)

;;Load the Dracula Theme
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(load-file "~/dracula.el")
;;(load-theme 'dracula t)

