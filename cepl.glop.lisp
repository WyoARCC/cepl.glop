(in-package :cepl.glop)

(defvar *initd* nil)
(defparameter *context* nil)
(defparameter *window* nil)

(defmethod cepl.host:init ()
t)

(defmethod cepl.host:request-context
    (width height title fullscreen
     no-frame alpha-size depth-size stencil-size
     red-size green-size blue-size buffer-size
     double-buffer hidden resizable)
  "Initializes the backend and returns a list containing: (context window)"
  (let ((win (make-instance 'glop:window)))
    (glop:open-window win
		      title
		      width
		      height
		      :x 0
		      :y 1
		      :double-buffer double-buffer
		      :red-size red-size
		      :green-size green-size
		      :blue-size blue-size
		      :alpha-size alpha-size
		      :depth-size depth-size
		      :stencil-size stencil-size)
    (glop:show-window win)
    #+(or :darwin :linux)
    (progn
      (setf cl-opengl-bindings::*gl-get-proc-address* #'glop::gl-get-proc-address)
      (let ((context (glop:create-gl-context win
					     :major 4
					     :minor 1
					     :make-current t
					     :profile :core)))
	(setf *context* context)
	(setf *window* win)
	(list context win)))))

(defmethod cepl.host:shutdown ()
  (glop:detach-gl-context *context*)
  (glop:close-window *window*))

(defun glop-swap (handle)
  (glop::swap-buffers handle))

(defmethod glop:on-event (window (event glop:key-event))
  ;; exit on ESC key
  (when (glop:pressed event)
    (case (glop:keysym event)
      (:escape
       (cepl::quit)
       (glop:push-close-event window)))))

(defmethod glop:on-event (window event)
  ;; ignore any other events
  (declare (ignore window event)))
;;----------------------------------------------------------------------
;; tell cepl what to use

(set-step-func #'glop:dispatch-events)
(set-swap-func #'glop-swap)
