;;; hello -- Echo "Hello, world!"
;;; Commentary:
;;; Code:

(defun hello-world ()
  (interactive)
  (message "Hello, world!"))

(provide 'hello) ; 意为“导出本模块，名为 hello”。这样就可以在其它地方进行 require 

;;; hello.el ends here
