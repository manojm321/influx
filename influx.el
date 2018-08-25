;;; influx.el --- Run inferior influx process        -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Manoj Kumar Manikchand

;; Author: Manoj Kumar Manikchand <manojm.321@gmail.com>
;; Keywords: tools

;;; Commentary:
;;

;;; Code:
;;;; Dependencies

(require 'comint)

;;;; Customizations

(defvar influx-cli-file-path "influx"
  "Path to influx-cli binary.")

(defvar influx-cli-arguments '("-host" "localhost" "-precision" "rfc3339")
  "Commandline arguments to pass to influx-cli.")

;;;;; Keymap

;;;###autoload
(defvar influx-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    (define-key map "\t" 'completion-at-point)
    map)
  "Basic mode map for `run-influx'.")

;;;;; Keywords

(defconst influx-keywords-upcase
  '("ALL"       "ALTER"     "ANY"          "AS"           "ASC"           "BEGIN"
    "BY"        "CREATE"    "CONTINUOUS"   "DATABASE"     "DATABASES"     "DEFAULT"
    "DELETE"    "DESC"      "DESTINATIONS" "DIAGNOSTICS"  "DISTINCT"      "DROP"
    "DURATION"  "END"       "EVERY"        "EXPLAIN"      "FIELD"         "FOR"
    "FROM"      "GRANT"     "GRANTS"       "GROUP"        "GROUPS"        "IN"
    "INF"       "INSERT"    "INTO"         "KEY"          "KEYS"          "KILL"
    "LIMIT"     "SHOW"      "MEASUREMENT"  "MEASUREMENTS" "NAME"          "OFFSET"
    "ON"        "ORDER"     "PASSWORD"     "POLICY"       "POLICIES"      "PRIVILEGES"
    "QUERIES"   "QUERY"     "READ"         "REPLICATION"  "RESAMPLE"      "RETENTION"
    "REVOKE"    "SELECT"    "SERIES"       "SET"          "SHARD"         "SHARDS"
    "SLIMIT"    "SOFFSET"   "STATS"        "SUBSCRIPTION" "SUBSCRIPTIONS" "TAG"
    "TO"        "USER"      "USERS"        "VALUES"       "WHERE"         "WITH"
    "WRITE"))

(defconst influx-keywords-downcase (mapcar #'downcase influx-keywords-upcase))

(defvar influx-font-lock-keywords
  (list
   ;; highlight all the reserved commands.
   `(,(concat "\\_<"
              (regexp-opt (nconc influx-keywords-upcase influx-keywords-downcase))
              "\\_>") . font-lock-keyword-face))
  "Keywords to highlight in `influx-mode'.")

;;;;; Commands

;;;###autoload
(defun run-influx ()
  "Run an inferior instance of influx-cli inside Emacs."
  (interactive)
  (apply #'make-comint-in-buffer "Influx" nil influx-cli-file-path
         nil influx-cli-arguments)
  (pop-to-buffer "*Influx*")
  (influx-mode))

;;;###autoload
(define-derived-mode influx-mode comint-mode "Influx"
  "Major mode for `run-influx'.

\\<influx-mode-map>"
  (setq comint-prompt-read-only t)
  (set (make-local-variable 'font-lock-defaults) '(influx-font-lock-keywords t)))

(provide 'influx)

;;; influx.el ends here
