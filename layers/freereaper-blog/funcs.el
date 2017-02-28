(defun freereaper/org-save-and-export ()
  (interactive)
  (org-octopress-setup-publish-project)
  (org-publish-project "octopress" t))
