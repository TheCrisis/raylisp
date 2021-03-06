;;;; Small McCLIM patches.

;;;; Image drawing
;;;; Thanks to Andy Hefner!

(in-package :clim-clx)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (export 'clim::medium-draw-pixels* :clim)
  (export 'clim::medium-get-pixels*  :clim))

(defgeneric clim::medium-draw-pixels*
    (medium array x y &key &allow-other-keys))
(defgeneric clim::medium-get-pixels*
    (medium array x y &key width height &allow-other-keys))

;;; TODO: Extract indexed pattern drawing and convert to one of these
;;; functions.

(defmethod clim::medium-draw-pixels* ((sheet sheet) array x y &rest args)
  (with-sheet-medium (medium sheet)
    (apply #'clim::medium-draw-pixels* medium array x y args)))

(defmethod clim::medium-draw-pixels*
    ((medium clx-medium) array x y &key width height (src-x 0) (src-y 0) &allow-other-keys)
  (let* ((image-width (array-dimension array 1))
         (image-height (array-dimension array 0))
         (image (xlib:create-image :width image-width :height image-height :data array
                                   :bits-per-pixel 32
                                   :depth 24
                                   :format :z-pixmap)))
    (with-clx-graphics (medium)
      (xlib:put-image mirror gc image
                      :x x :y y
                      :src-x src-x :src-y src-y
                      :width (or width image-width) :height (or height image-height)))))

(defmethod clim::medium-get-pixels*
    ((medium clx-medium) array x y &key width height &allow-other-keys)
  (let* ((width  (or width (array-dimension array 1)))
         (height (or height (array-dimension array 0))))
    (with-clx-graphics (medium)
      (xlib:image-z-pixarray (xlib:get-image mirror
                                             :x x :y y :data array
                                             :width width :height height
                                             :format :z-pixmap)))))

;;;; FINISH-OUTPUT on panes, etc.

(in-package :climi)

(defmethod stream-finish-output :after ((stream standard-extended-output-stream))
  (with-sheet-medium (medium stream)
    (medium-finish-output medium)))
