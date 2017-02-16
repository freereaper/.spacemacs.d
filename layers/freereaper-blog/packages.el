(defconst freereaper-blog-packages '(
                                     prodigy
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
