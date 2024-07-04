{ pkgs, config, ... }:
{
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-nox;
    # defaultEditor = true;
    socketActivation.enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    inherit (config.services.emacs) package;
    extraConfig = ''
      (setq standard-indent 2)
      (setq visible-bell t)

      ;; Initialize package sources
      (require 'package)
      (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                              ("org" . "https://orgmode.org/elpa/")
                              ("elpa" . "https://elpa.gnu.org/packages/")))
      (package-initialize)
      (unless package-archive-contents
      (package-refresh-contents))

      ;; Initialize use-package on non-Linux platforms
      (unless (package-installed-p 'use-package)
        (package-install 'use-package))

      (require 'use-package)
      (setq use-package-always-ensure t)

      (column-number-mode)
      (global-display-line-numbers-mode t)

      (load-theme 'modus-vivendi t)

      (setq modus-themes-mode-line '(borderless accented))
      (setq modus-themes-region '(accented))

      ;;(setq modus-themes-italic-constructs t
      ;;      modus-themes-bold-constructs nil
      ;;      modus-themes-mixed-fonts t
      ;;      modus-themes-variable-pitch-ui nil
      ;;      modus-themes-custom-auto-reload t
      ;;      modus-themes-disable-other-themes t

      ;;      ;; Options for `modus-themes-prompts' are either nil (the
      ;;      ;; default), or a list of properties that may include any of those
      ;;      ;; symbols: `italic', `WEIGHT'
      ;;      modus-themes-prompts '(italic bold)

      ;;      ;; The `modus-themes-completions' is an alist that reads two
      ;;      ;; keys: `matches', `selection'.  Each accepts a nil value (or
      ;;      ;; empty list) or a list of properties that can include any of
      ;;      ;; the following (for WEIGHT read further below):
      ;;      ;;
      ;;      ;; `matches'   :: `underline', `italic', `WEIGHT'
      ;;      ;; `selection' :: `underline', `italic', `WEIGHT'
      ;;      modus-themes-completions
      ;;      '((matches . (extrabold))
      ;;        (selection . (semibold italic text-also)))

      ;;      modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}

      ;;      ;; The `modus-themes-headings' is an alist: read the manual's
      ;;      ;; node about it or its doc string.  Basically, it supports
      ;;      ;; per-level configurations for the optional use of
      ;;      ;; `variable-pitch' typography, a height value as a multiple of
      ;;      ;; the base font size (e.g. 1.5), and a `WEIGHT'.
      ;;      modus-themes-headings
      ;;      '((1 . (variable-pitch 1.5))
      ;;        (2 . (1.3))
      ;;        (agenda-date . (1.3))
      ;;        (agenda-structure . (variable-pitch light 1.8))
      ;;        (t . (1.1))))

      (use-package doom-modeline
        :init (doom-modeline-mode 1)
        :custom ((doom-modeline-height 15)))

      (use-package rainbow-delimiters
        :hook (prog-mode . rainbow-delimiters-mode))

      (use-package which-key
        :init (which-key-mode)
        :diminish which-key-mode
        :config
        (setq which-key-idle-delay 1))

      (use-package all-the-icons)

      (use-package nerd-icons)

      (use-package nix-mode
        :mode "\\.nix\\'")

      (use-package org
        :hook (org-mode . efs/org-mode-setup)
        :config
        (setq org-ellipsis " ▾")
        (efs/org-font-setup))

      (use-package lsp-mode
        :init
        (setq lsp-keymap-prefix "C-c l")
        :hook (
              (python-mode . lsp)
              (python-mode . dap-mode)
              (python-mode . dap-ui-mode)
              (lsp-mode . lsp-enable-which-key-integration))
        :commands lsp)

      (use-package helm-lsp :commands helm-lsp-workspace-symbol)
      (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
      (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

      (use-package python-black
        :demand t
        :after python
        :hook (python-mode . python-black-on-save-mode-enable-dwim))

      (add-hook 'python-mode-hook 'python-isort-on-save-mode)

      (use-package python-pytest)

      (use-package dap-mode
        :config
        (dap-ui-mode 1)
        (require 'dap-node))

      (use-package docker)

      (use-package helm :config (require 'helm-autoloads))

      (use-package treemacs
        :ensure t
        :defer t
        :init
        ;;(with-eval-after-load 'winum
        ;;  (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
        ;;:config
        ;;(progn
        ;;  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        ;;        treemacs-deferred-git-apply-delay        0.5
        ;;        treemacs-directory-name-transformer      #'identity
        ;;        treemacs-display-in-side-window          t
        ;;        treemacs-eldoc-display                   'simple
        ;;        treemacs-file-event-delay                2000
        ;;        treemacs-file-extension-regex            treemacs-last-period-regex-value
        ;;        treemacs-file-follow-delay               0.2
        ;;        treemacs-file-name-transformer           #'identity
        ;;        treemacs-follow-after-init               t
        ;;        treemacs-expand-after-init               t
        ;;        treemacs-find-workspace-method           'find-for-file-or-pick-first
        ;;        treemacs-git-command-pipe                ""
        ;;        treemacs-goto-tag-strategy               'refetch-index
        ;;        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        ;;        treemacs-hide-dot-git-directory          t
        ;;        treemacs-indentation                     2
        ;;        treemacs-indentation-string              " "
        ;;        treemacs-is-never-other-window           nil
        ;;        treemacs-max-git-entries                 5000
        ;;        treemacs-missing-project-action          'ask
        ;;        treemacs-move-forward-on-expand          nil
        ;;        treemacs-no-png-images                   nil
        ;;        treemacs-no-delete-other-windows         t
        ;;        treemacs-project-follow-cleanup          nil
        ;;        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        ;;        treemacs-position                        'left
        ;;        treemacs-read-string-input               'from-child-frame
        ;;        treemacs-recenter-distance               0.1
        ;;        treemacs-recenter-after-file-follow      nil
        ;;        treemacs-recenter-after-tag-follow       nil
        ;;        treemacs-recenter-after-project-jump     'always
        ;;        treemacs-recenter-after-project-expand   'on-distance
        ;;        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        ;;        treemacs-project-follow-into-home        nil
        ;;        treemacs-show-cursor                     nil
        ;;        treemacs-show-hidden-files               t
        ;;        treemacs-silent-filewatch                nil
        ;;        treemacs-silent-refresh                  nil
        ;;        treemacs-sorting                         'alphabetic-asc
        ;;        treemacs-select-when-already-in-treemacs 'move-back
        ;;        treemacs-space-between-root-nodes        t
        ;;        treemacs-tag-follow-cleanup              t
        ;;        treemacs-tag-follow-delay                1.5
        ;;        treemacs-text-scale                      nil
        ;;        treemacs-user-mode-line-format           nil
        ;;        treemacs-user-header-line-format         nil
        ;;        treemacs-wide-toggle-width               70
        ;;        treemacs-width                           35
        ;;        treemacs-width-increment                 1
        ;;        treemacs-width-is-initially-locked       t
        ;;        treemacs-workspace-switch-cleanup        nil)

        ;;  ;;(treemacs-resize-icons 44)
        ;;  (treemacs-follow-mode t)
        ;;  (treemacs-filewatch-mode t)
        ;;  (treemacs-fringe-indicator-mode 'always)
        ;;  (when treemacs-python-executable
        ;;    (treemacs-git-commit-diff-mode t))
        ;;  (pcase (cons (not (null (executable-find "git")))
        ;;              (not (null treemacs-python-executable)))
        ;;    (`(t . t)
        ;;    (treemacs-git-mode 'deferred))
        ;;    (`(t . _)
        ;;    (treemacs-git-mode 'simple)))
        ;;  (treemacs-hide-gitignored-files-mode nil))
        ;;:bind
        ;;(:map global-map
        ;;      ("M-0"       . treemacs-select-window)
        ;;      ("C-x t 1"   . treemacs-delete-other-windows)
        ;;      ("C-x t t"   . treemacs)
        ;;      ("C-x t d"   . treemacs-select-directory)
        ;;      ("C-x t B"   . treemacs-bookmark)
        ;;      ("C-x t C-t" . treemacs-find-file)
        ;;      ("C-x t M-t" . treemacs-find-tag)))
      )

      (use-package treemacs-evil
        :after (treemacs evil)
        :ensure t)

      (use-package treemacs-icons-dired
        :hook (dired-mode . treemacs-icons-dired-enable-once)
        :ensure t)

      (use-package treemacs-magit
        :after (treemacs magit)
        :ensure t)

      (use-package treemacs-persp
        :after (treemacs persp-mode)
        :ensure t
        :config (treemacs-set-scope-type 'Perspectives))

      (use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
        :after (treemacs)
        :ensure t
        :config (treemacs-set-scope-type 'Tabs))

      (use-package ivy
        :diminish
        :config
        (ivy-mode 1))

      (setq ivy-use-virtual-buffers t)
      (setq enable-recursive-minibuffers t)

      (global-set-key "\C-s" 'swiper)
      (global-set-key (kbd "C-c C-r") 'ivy-resume)
      (global-set-key (kbd "<f6>") 'ivy-resume)
      (global-set-key (kbd "M-x") 'counsel-M-x)
      (global-set-key (kbd "C-x C-f") 'counsel-find-file)
      (global-set-key (kbd "<f1> f") 'counsel-describe-function)
      (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
      (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
      (global-set-key (kbd "<f1> l") 'counsel-find-library)
      (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
      (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
      (global-set-key (kbd "C-c g") 'counsel-git)
      (global-set-key (kbd "C-c j") 'counsel-git-grep)
      (global-set-key (kbd "C-c k") 'counsel-ag)
      (global-set-key (kbd "C-x l") 'counsel-locate)
      (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
      (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

      ;;(use-package ivy-rich
      ;;  :init
      ;;  (ivy-rich-mode 1))

      (use-package evil
        :init
        (setq evil-want-integration t)
        (setq evil-want-keybinding nil)
        (setq evil-want-C-u-scroll t)
        (setq evil-want-C-i-jump nil)
        :config
        (evil-mode 1)
        (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
        (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

        ;; Use visual line motions even outside of visual-line-mode buffers
        (evil-global-set-key 'motion "j" 'evil-next-visual-line)
        (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

        (evil-set-initial-state 'messages-buffer-mode 'normal)
        (evil-set-initial-state 'dashboard-mode 'normal))

      (add-hook 'c-mode-hook 'helm-cscope-mode)
      (add-hook 'c++-mode-hook 'helm-cscope-mode)
      (eval-after-load "helm-cscope"
        '(progn
          (define-key helm-cscope-mode-map (kbd "M-t") 'helm-cscope-find-symbol)
          (define-key helm-cscope-mode-map (kbd "M-r") 'helm-cscope-find-global-definition)
          (define-key helm-cscope-mode-map (kbd "M-g M-c") 'helm-cscope-find-called-function)
          (define-key helm-cscope-mode-map (kbd "M-g M-p") 'helm-cscope-find-calling-this-funtcion)
          (define-key helm-cscope-mode-map (kbd "M-s") 'helm-cscope-select)))

      ;;(add-hook 'prog-mode-hook 'display-line-numbers-mode)

      (menu-bar-mode -1)
      (lsp-treemacs-sync-mode 1)

      (global-tree-sitter-mode)
      (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
    '';
    extraPackages =
      epkgs: with epkgs; [
        all-the-icons
        dap-mode
        docker
        docker-api
        docker-cli
        docker-compose-mode
        doom-modeline
        evil
        helm
        helm-codesearch
        helm-dictionary
        helm-directory
        # helm-dired-history
        helm-dired-recent-dirs
        helm-firefox
        helm-git
        helm-git-grep
        helm-gitignore
        helm-google
        helm-ispell
        helm-ls-git
        helm-lsp
        helm-make
        helm-nixos-options
        helm-org
        helm-pass
        helm-proc
        helm-pydoc
        helm-shell-history
        helm-systemd
        helm-tree-sitter
        helm-wikipedia
        helm-xref
        ivy
        ivy-clipmenu
        ivy-emoji
        ivy-explorer
        ivy-file-preview
        ivy-fuz
        ivy-historian
        ivy-hydra
        ivy-pass
        ivy-rich
        ivy-searcher
        ivy-todo
        ivy-xref
        ivy-youtube
        lsp-docker
        lsp-ivy
        lsp-mode
        swiper
        lsp-pyright
        lsp-treemacs
        nerd-icons
        nix-mode
        org
        org-modern
        python-black
        python-isort
        python-mode
        python-pytest
        rainbow-delimiters
        treemacs
        treemacs-all-the-icons
        treemacs-evil
        treemacs-icons-dired
        treemacs-magit
        treemacs-nerd-icons
        treemacs-persp
        treemacs-tab-bar
        which-key
      ];
  };
  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    pyright
  ];
}
