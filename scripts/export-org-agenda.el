;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defmacro org-batch-agenda-csv-file (cmd-key filename &rest parameters)
  "see `org-batch-agenda`"
  (let ((agenda-name (concat "*Org Agenda(" cmd-key ")*")))
    (if (get-buffer agenda-name)
	(kill-buffer agenda-name))
    (org-eval-in-environment (append '((org-agenda-remove-tags t))
				     (org-make-parameter-alist parameters))
      (if (> (length cmd-key) 2)
	  (org-tags-view nil cmd-key)
	(org-agenda nil cmd-key)))
    ;; (set-buffer org-agenda-buffer-name)
    (set-buffer agenda-name)
    (let* ((lines (org-split-string (buffer-string) "\n"))
	   line)
      (with-temp-file filename
	(while (setq line (pop lines))
	  (catch 'next
	    (if (not (get-text-property 0 'org-category line)) (throw 'next nil))
	    (setq org-agenda-info
		  (org-fix-agenda-info (text-properties-at 0 line)))
	    (insert
	     (mapconcat 'org-agenda-export-csv-mapper
			'(org-category txt type todo tags date time extra
				       priority-letter priority agenda-day)
			","))
	    (insert "\n")))))))

(org-batch-agenda-csv-file "z" "./blah.csv")
(org-batch-agenda-csv-file "U" "./unscheduled.csv")

org-agenda-buffer-name
