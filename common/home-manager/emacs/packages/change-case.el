(defun camelcase-region (start end)
  "Changes region from snake_case to camel_case"
  (interactive "r")
  (save-restriction (narrow-to-region start end)
                    (goto-char (point-min))
                    (while (re-search-forward "_\\(.\\)" nil t)
                      (replace-match (upcase (match-string 1))))))

(defun camelcase-word-or-region ()
  "Changes word or region from snake_case to camel_case"
  (interactive)
  (let (pos1 pos2 bds)
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning) pos2 (region-end))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (setq pos1 (car bds) pos2 (cdr bds))))
    (camelcase-region pos1 pos2)))

(defun split-name (s)
  (split-string
   (let ((case-fold-search nil))
     (downcase
      (replace-regexp-in-string "\\([a-z]\\)\\([A-Z]\\)" "\\1 \\2" s)))
   "[^A-Za-z0-9]+"))

(defun underscore-string (s)
  (mapconcat
   'downcase
   (split-name s) "_"))

(defun snakecase-region (begin end)
  "Convert the given region from camel_case to snake_case"
  (interactive "r")
  (let* ((word (buffer-substring begin end))
         (underscored (underscore-string word)))
    (save-excursion
      (widen) ; break out of the subregion so we can fix every usage of the function
      (replace-string word underscored nil (point-min) (point-max)))))

(defun snakecase-word-or-region ()
  "Changes word or region from camel_case to snake_case"
  (interactive)
  (let (pos1 pos2 bds)
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning) pos2 (region-end))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (setq pos1 (car bds) pos2 (cdr bds))))
    (snakecase-region pos1 pos2)))

(global-set-key (kbd "C-c C--") 'camelcase-word-or-region)
(global-set-key (kbd "C-c C-_") 'snakecase-word-or-region)

(provide 'change-case)
