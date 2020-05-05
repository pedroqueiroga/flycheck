;;; test-mode-line.el --- Flycheck Specs: Mode Line  -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2016 Sebastian Wiesner and Flycheck contributors

;; Author: Sebastian Wiesner <swiesner@lunaryorn.com>

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Specs for mode line reporting.

;;; Code:

(require 'flycheck-buttercup)

(describe "Mode Line (interactive-only)"
  (when noninteractive
    ;; `format-mode-line' doesn't work in batch mode
    (signal 'buttercup-pending "SKIPPED"))

  (it "shows the number of errors and warnings"
    (let ((flycheck-current-errors
           (list (flycheck-error-new-at 1 1 'warning "warning 1")
                 (flycheck-error-new-at 1 1 'info "info")
                 (flycheck-error-new-at 2 2 'warning "warning 2")
                 (flycheck-error-new-at 1 1 'error "error"))))
      (expect (flycheck-mode-line-status-text 'finished)
              :to-equal " FlyC[1 2 1]")))

  (it "omits unnecessary levels"
    (let ((flycheck-current-errors
           (list (flycheck-error-new-at 1 1 'error "error"))))
      (expect (flycheck-mode-line-status-text 'finished)
              :to-equal " FlyC[1]"))
    (let ((flycheck-current-errors
           (list (flycheck-error-new-at 1 1 'warning "warning")
                 (flycheck-error-new-at 1 1 'error "error"))))
      (expect (flycheck-mode-line-status-text 'finished)
              :to-equal " FlyC[1 1]")))

  (it "includes higher-priority levels when lower-priority ones are present"
    (let ((flycheck-current-errors
           (list (flycheck-error-new-at 1 1 'warning "warning"))))
      (expect (flycheck-mode-line-status-text 'finished)
              :to-equal " FlyC[0 1]"))
    (let ((flycheck-current-errors
           (list (flycheck-error-new-at 1 1 'info "info"))))
      (expect (flycheck-mode-line-status-text 'finished)
              :to-equal " FlyC[0 0 1]")))

  (it "includes the prefix"
    (let ((flycheck-mode-line-prefix "foobar")
          flycheck-current-errors)
      (expect (flycheck-mode-line-status-text 'finished) :to-equal " foobar"))))

;;; test-mode-line.el ends here
