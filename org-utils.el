;;; org-utils.el --- Utilities for working with Org mode

;;; Commentary:

;; This file provides a few utilities for working with Org mode.

;;; Code:

(declare-function org-entry-beginning-position "org")
(declare-function org-entry-end-position "org")
(declare-function org-get-entry "org")

(defun org-count-logbook-entries ()
  "Count the number of entries in the LOGBOOK drawer."
  (interactive)
  (save-excursion
    (save-restriction
      (narrow-to-region (org-entry-beginning-position) (org-entry-end-position))
      (goto-char (point-min))
      (let ((beginning-of-logbook (search-forward ":LOGBOOK:"))
            (end-of-logbook (search-forward ":END:")))
        (message
         (format "%s" (1- (length (split-string
                                   (buffer-substring beginning-of-logbook end-of-logbook)
                                   "^ *- ")))))))))

(defun org-oldest-timestamp-in-entry ()
  "Get the oldest timestamp in an entry."
  (let ((current-entry (org-get-entry))
        (position 0)
        (matches ())
        (ts-regexp "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\) [A-Z][a-z][a-z] \\([0-9]\\{2\\}:[0-9]\\{2\\}\\)"))
    (save-match-data
      (while (string-match ts-regexp current-entry position)
        (push
         (concat
          (match-string 1 current-entry)
          " "
          (match-string 2 current-entry))
         matches)
        (setq position (match-end 0)))
      matches)
    (car (cl-sort matches 'string-lessp))))

;;; org-utils.el ends here
