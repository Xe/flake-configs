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
  (interactive)
  (tab-bar-new-tab 1)
  (let ((proj-type (projectile-project-type)))
    (if (eq proj-type 'nil)
        (vterm)
        (projectile-run-vterm)))
  (rename-uniquely))

(defun xe/kill-whitespace ()
  "Kill the whitespace between two non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (re-search-backward "[^ \t\r\n]" nil t)
          (re-search-forward "[ \t\r\n]+" nil t)
          (replace-match "" nil nil))))))

(defun xe/how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.
Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun xe/linum-format-func (line)
  "Properly format the line number"
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
        (propertize (format (format " %%%dd " w) line) 'face 'linum)))

(provide 'xe-tools)
;;; xe-tools.el ends here
