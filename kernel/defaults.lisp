(in-package :raylisp)

;;;# Global Defaults
;;;
;;; We store global defaults for various keyword arguments in a plist
;;; and provide an accessor for them.
;;;
;;; The reason we do this is the ability to store and change default
;;; values all in one go.

(defparameter *default-values*
  (list :adaptive-limit 0.05
	:ambient 0.025
	:ambient-light +white+
	:background +black+
        :diffuse 0.9
	:depth-limit 5
	:ior 1.0
	:radius 1.0
	:shader nil
	:size 40.0
	:specular 0.05
	:transform nil
	:transmit 0.0
	:type nil))

(defun find-default (name &optional (type t))
  (let ((default (getf *default-values* name)))
    (if (typep default type)
	default
	(error "No valid default for ~S: ~S not of type ~S."
	       name default type))))

(defun (setf find-default) (value name)
  (setf (getf *default-values* name) value))

(defmacro with-defaults (bindings &body body)
  `(let ((*default-values* (list* ,@bindings *default-values*)))
     ,@body))
