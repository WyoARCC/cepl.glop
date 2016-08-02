(asdf:defsystem #:cepl.glop
  :description "GLOP host for cepl"
  :author "Graham Marousek <graham.marousek@gmail.com"
  :license "BSD 2 clause"
  :depends-on(#:cepl #:glop)
  :serial t
  :components ((:file "package")
	       (:file "cepl.glop")))
