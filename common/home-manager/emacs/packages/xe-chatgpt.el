;;; xe-tools --- Xe's chatgpt bindings

;;; Commentary:

;;; I guess we're gonna have to deal with this shit,
;;; so I might as well try and learn how to use it.

;;; Code:

(setf lexical-binding t)
(eval-when-compile '(require 'cl))

(require 'request)

(defcustom xe/chatgpt-base-prompt
  "You are an assistant that helps Xe Iaso with programming. You will return answers and code that helps Xe program things."
  "The default system message for ChatGPT."
  :type 'string)

(defun xe/chatgpt--create-answer-buffer (suffix)
  "Create a new scratch buffer with name SUFFIX and switch to it.
The buffer is set to markdown-mode. Return the buffer."
  (let ((bufname (generate-new-buffer-name (format "*xe-chatgpt-%s*" suffix))))
    (switch-to-buffer (get-buffer-create bufname))
    (markdown-mode)
    (get-buffer bufname)))

(defun xe/chatgpt--chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                       str)
    (setq str (replace-match "" t t str)))
    str)

(defun xe/chatgpt--read-file (fname)
  "Reads FNAME and returns its contents as a string."
  (with-temp-buffer
    (insert-file-contents fname)
    (xe/chatgpt--chomp (buffer-string))))

(defun xe/chatgpt--make-request (question mode)
  "Internal function to ask ChatGPT a QUESTION in MODE mode.
Inserts the result text of the first response to the a scratch buffer."
  (xe/chatgpt--create-answer-buffer mode)
  (insert question)
  (let* ((req `(("model" . "gpt-3.5-turbo")
                ("messages" . ((("role" . "system") ("content" . ,xe/chatgpt-base-prompt))
                               (("role" . "user") ("content" . ,question))))))
         (auth-key (xe/chatgpt--read-file
                    (format "%s/.openai-token" (getenv "HOME"))))
         (headers `(("Content-Type" . "application/json")
                    ("Authorization" . ,(format "Bearer %s" auth-key)))))
    (request
      "https://api.openai.com/v1/chat/completions"
      :type "POST"
      :data (json-encode req)
      :headers headers
      :parser 'json-read
      :encoding 'utf-8
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (let* ((choice (aref (alist-get 'choices data) 0))
                         (message (alist-get 'message choice))
                         (content (alist-get 'content message)))
                    (insert (xe/chatgpt--chomp content))))))))

(defun xe/ask-chatgpt (question)
  "Ask ChatGPT a QUESTION and get the response put into your current buffer."
  (interactive "squestion> ")
  (xe/chatgpt--make-request question "detail"))

(defun xe/ask-chatgpt-with-mode (question)
  "Ask ChatGPT a QUESTION and get the response put into your current buffer. This will add the context of what editor major mode you are in."
  (interactive "squestion> ")
  (let* ((editor-mode (string-join (split-string (symbol-name major-mode) "-") " "))
         (prompt (format "%s\nUser is in %s. Only include the code." question editor-mode)))
    (xe/chatgpt--make-request prompt "quick")))

(defun xe/chatgpt-explain (beginning end)
  "Ask ChatGPT to explain this region of code from BEGINNING to END."
  (interactive "r")
  (let* ((code (buffer-substring-no-properties (region-beginning) (region-end)))
         (mode-sp (split-string (symbol-name major-mode) "-"))
         (editor-mode (string-join (split-string (symbol-name major-mode) "-") " "))
         (prompt
          (format "Explain this code. User is in %s.\n\n```%s\n%s```\n\n" editor-mode (car mode-sp) code)))
    (xe/chatgpt--make-request prompt "explain")))

(provide 'xe-chatgpt)
;;; xe-chatgpt.el ends here
