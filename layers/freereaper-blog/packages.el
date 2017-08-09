(defconst freereaper-blog-packages '(
                                     prodigy
                                     ;; org-octopress
                                     (blog-admin :location (recipe
                                                            :fetcher github
                                                            :repo "codefalling/blog-admin"))
                                     )
  )

(defun freereaper-blog/post-init-prodigy ()
  (progn
    (prodigy-define-tag
      :name 'hexo
      :env '(("LANG" "en_US.UTF-8")
             ("LC_ALL" "en_US.UTF-8")))

    (prodigy-define-service
      :name "Hexo Clean"
      :command "hexo"
      :args '("clean")
      :cwd blog-admin-dir
      :tags '(hexo clean)
      :kill-signal 'sigkill
      :ready-message "Deleted public folder."
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Generate"
      :command "hexo"
      :args '("generate")
      :cwd blog-admin-dir
      :tags '(hexo generate)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Server"
      :command "hexo"
      :args '("server")
      :cwd blog-admin-dir
      :port 4000
      :tags '(hexo server)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    ))

(defun freereaper-blog/init-blog-admin ()
  (use-package blog-admin
    :defer t
    :commands blog-admin-start
    :init
    (progn
      (setq blog-admin-backend-type 'hexo
            blog-admin-backend-path blog-admin-dir
            blog-admin-backend-new-post-with-same-name-dir nil
            blog-admin-backend-hexo-config-file "_config.yml"
            )
      (add-hook 'blog-admin-backend-after-new-post-hook 'find-file)
      (setq blog-admin-backend-hexo-template-org-post ;; post\u6a21\u677f
            "#+TITLE: %s
#+DATE: %s
#+SETUPFILE: ../../org/setupfile.org
#+LAYOUT: post
#+TAGS:
#+CATEGORIES:
             ")))
  )

(defun freereaper-blog/init-org-octopress ()
  (use-package org-octopress
    :commands (org-octopress org-octopress-setup-publish-project)
    :init
    (progn
      (evilified-state-evilify org-octopress-summary-mode org-octopress-summary-mode-map)
      (add-hook 'org-octopress-summary-mode-hook
                #'(lambda () (local-set-key (kbd "q") 'bury-buffer)))
      (setq org-blog-dir blog-admin-dir)
      (setq org-octopress-directory-top org-blog-dir)
      (setq org-octopress-directory-posts (concat org-blog-dir "source/_posts/"))
      (setq org-octopress-directory-org-top org-blog-dir)
      (setq org-octopress-directory-org-posts (concat org-blog-dir "org/source/"))
      (setq org-octopress-setup-file (concat org-blog-dir "org/setupfile.org"))
      )
    :config
    (org-octopress-setup-publish-project)))
