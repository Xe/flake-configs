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

(defun xe/chatgpt--make-request (question)
  "Internal function to ask ChatGPT a QUESTION and insert the result text of the first response to the current buffer."
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
                  (message "%S" data)
                  (let* ((choice (aref (alist-get 'choices data) 0))
                         (message (alist-get 'message choice))
                         (content (alist-get 'content message)))
                    (message "ChatGPT reply: %s" content)
                    (insert content)))))))

(defun xe/chatgpt-ask (question)
  "Ask ChatGPT a QUESTION and get the response put into your current buffer."
  (interactive "squestion> ")
  (message "ChatGPT ask: %s" question)
  (xe/chatgpt--make-request prompt))

(defun xe/chatgpt-ask-with-mode (question)
  "Ask ChatGPT a QUESTION and get the response put into your current buffer. This will add the context of what editor major mode you are in."
  (interactive "squestion> ")
  (message "ChatGPT ask: %s" question)
  (let* ((editor-mode (string-join (split-string (symbol-name major-mode) "-") " "))
         (prompt (format "%s\nUser is in %s. Only include the code." question editor-mode)))
    (xe/chatgpt--make-request prompt)))

(provide 'xe-chatgpt)
;;; xe-chatgpt.el ends here
