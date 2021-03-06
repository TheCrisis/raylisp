;;;; by Nikodemus Siivola <nikodemus@random-state.net>, 2009.
;;;;
;;;; Permission is hereby granted, free of charge, to any person
;;;; obtaining a copy of this software and associated documentation files
;;;; (the "Software"), to deal in the Software without restriction,
;;;; including without limitation the rights to use, copy, modify, merge,
;;;; publish, distribute, sublicense, and/or sell copies of the Software,
;;;; and to permit persons to whom the Software is furnished to do so,
;;;; subject to the following conditions:
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;;;; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;;;; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;;;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(in-package :raylisp)

;;;; SURFACE NORMAL PERTURBATION

(defclass normal (transformable)
  ((height
    :initarg :height
    :initform 1.0
    :reader normal-height)))

(defmethod normal-height :around ((normal normal))
  (coerce (call-next-method) 'single-float))

(declaim (ftype (function (t matrix) perturbation-function)
                compute-perturbation-function))
(defgeneric compute-perturbation-function (normal matrix))

(defmethod compute-perturbation-function :around (normal matrix)
  (check-function-type (call-next-method) 'perturbation-function))

(defmethod compute-perturbation-function :around ((normal transformable) matrix)
  (call-next-method normal (matrix* matrix (transform-of normal))))

(define-named-lambda perturbation-lambda vec ((result vec) (normal vec) (point vec))
                     :safe nil)

(defmethod compute-perturbation-function ((normal null) matrix)
  (perturbation-lambda smooth-normal (result normal point)
    (declare (ignore result point))
    normal))


