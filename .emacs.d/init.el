(menu-bar-mode -1)
(tool-bar-mode -1)
(setq make-backup-files nil)

(add-hook 'text-mode-hook 'flyspell-mode)


(let ((minver "25.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "26.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;(add-to-list 'load-path "~/.emacs.d/lisp/")

; (require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

; Adjust garbage collection thresholds during startup, and thereafter

;(let ((normal-gc-cons-threshold (* 20 1024 1024))
;      (init-gc-cons-threshold (* 128 1024 1024)))
;  (setq gc-cons-threshold init-gc-cons-threshold)
;  (add-hook 'emacs-startup-hook
;            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))
;

; graphic opts
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
(add-to-list 'default-frame-alist '(width . 90))  ; （可选）设定启动图形界面时的初始 Frame 宽度（字符数）
(add-to-list 'default-frame-alist '(height . 55)) ; （可选）设定启动图形界面时的初始 Frame 高度（字符数）


;(setq confirm-kill-emacs #'yes-or-no-p)      ; 在关闭 Emacs 前询问是否确认关闭，防止误触
(setq confirm-kill-emacs nil)
(electric-pair-mode t)                       ; 自动补全括号
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式下，光标在括号上时高亮另一个括号
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 当另一程序修改了文件时，让 Emacs 及时刷新 Buffer
;(delete-selection-mode t)                    ; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）
(setq inhibit-startup-message t)             ; 关闭启动 Emacs 时的欢迎界面
(setq make-backup-files nil)                 ; 关闭文件自动备份
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 编程模式下，可以折叠代码块

(global-display-line-numbers-mode 1)         ; 在 Window 显示行号
;(savehist-mode 1)                            ; （可选）打开 Buffer 历史记录保存
(setq display-line-numbers-type 'relative)   ; （可选）显示相对行号

(require 'hello)

; key binding

(global-set-key (kbd "RET") 'newline-and-indent)
;(global-set-key (kbd "M-w") 'kill-region)              ; 交换 M-w 和 C-w，M-w 为剪切
;(global-set-key (kbd "C-w") 'kill-ring-save)           ; 交换 M-w 和 C-w，C-w 为复制
;(global-set-key (kbd "C-a") 'back-to-indentation)      ; 交换 C-a 和 M-m，C-a 为到缩进后的行首
;(global-set-key (kbd "M-m") 'move-beginning-of-line)   ; 交换 C-a 和 M-m，M-m 为到真正的行首
;(global-set-key (kbd "C-c '") 'comment-or-uncomment-region) ; 为选中的代码加注释/去注释


;; Faster move cursor
(defun next-ten-lines()
  "Move cursor to next 10 lines."
  (interactive)
  (next-line 10))

(defun previous-ten-lines()
  "Move cursor to previous 10 lines."
  (interactive)
  (previous-line 10))
;; 绑定到快捷键
(global-set-key (kbd "M-n") 'next-ten-lines)            ; 光标向下移动 10 行
(global-set-key (kbd "M-p") 'previous-ten-lines)        ; 光标向上移动 10 行



(global-set-key (kbd "C-j") nil)
;; 删去光标所在行（在图形界面时可以用 "C-S-<DEL>"，终端常会拦截这个按法)
(global-set-key (kbd "C-j C-k") 'kill-whole-line)
;; 自定义两个函数

(require 'package)


(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

; UNKNOW: procedure
;(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
;                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))
;
(package-initialize)

; package builtin proxy
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ; 不加这一句可能有问题，建议读者尝试一下
;(setq url-proxy-services '(("no_proxy" . "^\\(192\\.168\\..*\\)")
;                           ("http" . "<代理 IP>:<代理端口号>")
;        ("https" . "<代理 IP>:<代理端口号>")))

(use-package magit
  :ensure t)
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-monokai-octagon t)
  (doom-themes-treemacs-config))
(use-package treemacs
  :ensure t
  :defer t
  :config
  (treemacs-tag-follow-mode)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ;; ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  (:map treemacs-mode-map
	("/" . treemacs-advanced-helpful-hydra)))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

(use-package lsp-treemacs
  :ensure t
  :after (treemacs lsp))

(eval-when-compile
  (require 'use-package))

;https://zhuanlan.zhihu.com/p/441612281
(use-package counsel
             :ensure t)

(use-package ivy
  :ensure t                          ; 确认安装，如果没有安装过 ivy 就自动安装
  :init                              ; 在加载插件前执行命令
  (ivy-mode 1)                       ; 启动 ivy-mode
  :custom                            ; 自定义一些变量，相当于赋值语句 (setq xxx yyy)
  (ivy-use-virtual-buffers t)        ; 一些官网提供的固定配置
  (ivy-count-format "(%d/%d) ")
  :bind                              ; 以下为绑定快捷键
  ("C-s" . 'swiper-isearch)          ; 绑定快捷键 C-s 为 swiper-search，替换原本的搜索功能
  ("M-x" . 'counsel-M-x)             ; 使用 counsel 替换命令输入，给予更多提示
  ("C-x C-f" . 'counsel-find-file)   ; 使用 counsel 做文件打开操作，给予更多提示
  ("M-y" . 'counsel-yank-pop)        ; 使用 counsel 做历史剪贴板粘贴，可以展示历史
  ("C-x b" . 'ivy-switch-buffer)     ; 使用 ivy 做 buffer 切换，给予更多提示
  ("C-c v" . 'ivy-push-view)         ; 记录当前 buffer 的信息
  ("C-c s" . 'ivy-switch-view)       ; 切换到记录过的 buffer 位置
  ("C-c V" . 'ivy-pop-view)          ; 移除 buffer 记录
  ("C-x C-SPC" . 'counsel-mark-ring) ; 使用 counsel 记录 mark 的位置
  ("<f1> f" . 'counsel-describe-function)
  ("<f1> v" . 'counsel-describe-variable)
  ("<f1> i" . 'counsel-info-lookup-symbol))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil))

;(use-package smart-mode-line
;  :ensure t
;  :init (sml/setup))

(use-package which-key
  :ensure t
  :init (which-key-mode))

;; minibuffer 添加注解
(use-package marginalia
  :ensure t
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map
        ("M-A" . marginalia-cycle)))

;(use-package highlight-symbol
;  :ensure t
;  :init (highlight-symbol-mode)
;  :bind ("<f3>" . highlight-symbol)) ;; 按下 F3 键就可高亮当前符号

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

; FIXME: it eay some useful emacs key bindings again
; use meow??
(use-package evil
  :ensure t
  :init (evil-mode))

(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1) ; 只需敲 1 个字母就开始进行自动补全
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0)
  (setq company-show-numbers t) ;; 给选项编号 (按快捷键 M-1、M-2 等等来进行选择).
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序，读者如果不喜欢可以去掉


(use-package company-box
  :ensure t
  :if window-system
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  ;; add company-yasnippet to company-backends
  (defun company-mode/backend-with-yas (backend)
    (if (and (listp backend) (member 'company-yasnippet backend))
	backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  ;; unbind <TAB> completion
  (define-key yas-minor-mode-map [(tab)]        nil)
  (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil)
  :bind
  (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)


(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  :hook
  (prog-mode . flycheck-mode))

; eglot
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 500)
  :hook
  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :none) ;; 阻止 lsp 重新设置 company-backend 而覆盖我们 yasnippet 的设置
  (setq lsp-headerline-breadcrumb-enable t)
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol)) ;; 可快速搜索工作区内的符号（类名、函数名、变量名等）

;; hover doc
(use-package lsp-ui
  :ensure t
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-position 'top))

(use-package lsp-ivy
  :ensure t
  :after (lsp-mode))


;(use-package visual-fill-column
;  :ensure t)

;(use-package telega
;  :ensure t)

(use-package telega
  ;:load-path  "~/b/telega.el"
  :commands (telega)
  :init
  (define-key global-map (kbd "C-c t") telega-prefix-map)
  :config
  (setq telega-proxies (list '(:server "127.0.0.1"
    :port 7890
    :enable t
    :type (:@type "proxyTypeHttp"
    :username "" :password ""))))
  :defer t)


;https://idiocy.org/emacs-fonts-and-fontsets.html
(set-face-attribute 'default nil :font "Cascadia Mono 20")

;(setq telega-server-libs-prefix "/usr/")
; (require 'xah-fly-keys)
; (xah-fly-keys-set-layout "qwerty")
; (xah-fly-keys 1)

; (add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
; (require 'eaf)
; (require 'eaf-browser)
; (require 'eaf-pdf-viewer)
; (require 'eaf-music-player)
; (require 'eaf-video-player)
; (require 'eaf-image-viewer)
; (require 'eaf-rss-reader)
; (require 'eaf-terminal)
; (require 'eaf-markdown-previewer)
; (require 'eaf-org-previewer)
; (require 'eaf-camera)
; (require 'eaf-git)
; (require 'eaf-file-manager)
; (require 'eaf-mindmap)
; (require 'eaf-netease-cloud-music)
; (require 'eaf-system-monitor)
; (require 'eaf-file-browser)
; (require 'eaf-file-sender)
; (require 'eaf-airshare)
; (require 'eaf-jupyter)
; (require 'eaf-2048)
; (require 'eaf-markmap)
; (require 'eaf-map)
; (require 'eaf-demo)
; (require 'eaf-vue-demo)
; (require 'eaf-vue-tailwindcss)
; (setq eaf-enable-debug t)
; (setq eaf-proxy-type "http")
; (setq eaf-proxy-host "127.0.0.1")
; (setq eaf-proxy-port "7890")

;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(package-selected-packages '(ivy)))

;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(package-selected-packages '(undo-tree flycheck counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;https://www.reddit.com/r/emacs/comments/124d6q6/whats_the_purpose_of_provide_init_and_provide/
; Fake the footer to avoid warnings
 (provide 'init)
; init.el ends here
