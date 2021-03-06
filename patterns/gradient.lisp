(in-package :raylisp)

(defclass gradient-pattern (interpolated-pattern axis-mixin)
  ((smooth
    :initform nil
    :initarg :smooth
    :reader smoothp)))

(defmethod compute-interpolated-pattern-function ((pattern gradient-pattern) transform)
  (let ((inverse (inverse-matrix
                  (matrix* transform (reorient (axis-of pattern) +z+)))))
    (if (smoothp pattern)
        (interpolated-pattern-lambda smooth-gradient-pattern (point)
          (declare (optimize speed))
          (let ((p (transform-point point inverse)))
            (declare (dynamic-extent p))
            (let ((r (nth-value 1 (truncate (aref p 2) 2.0))))
              (abs (cond ((> r 1.0)
                          (- r 2.0))
                         ((< r -1.0)
                          (+ r 2.0))
                         (t
                          r))))))
        (interpolated-pattern-lambda gradient-pattern (point)
          (declare (optimize speed))
          (let ((p (transform-point point inverse)))
            (declare (dynamic-extent p))
            (imod (aref p 2) 1.0))))))
