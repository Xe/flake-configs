;;; xe-tools --- Xe's tools

;;; Commentary:

;;; Code:
(defun xe/count-buffers (&optional display-anyway)
  "Display or return the number of buffers."
  (interactive)
  (let ((buf-count (length (buffer-list))))
    (if (or (interactive-p) display-anyway)
        (message "%d buffers in this Emacs" buf-count)) buf-count))

(defun xe/look-of-disapproval ()
  "Just in case we need this."
  (interactive)
  (insert "ಠ_ಠ"))

(defun xe/enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp. MY-PAIR is a cons
cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
          (funcall (cdr my-pair)))))

(defun xe/tabnew-shell ()
  "Opens a shell in a new tab (tmux Control-b c)."
  (tab-bar-new-tab 1)
  (vterm)
  (evil-set-initial-state 'vterm-mode 'emacs)
  (rename-uniquely))

(provide 'xe-tools)
;;; xe-tools.el ends here
