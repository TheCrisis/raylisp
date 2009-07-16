(in-package :asdf)

(defsystem :raylisp
  :depends-on (:alexandria :sb-cga)
  :components
  ((:file "package")
   (:file "base" :depends-on ("package"))
   (:file "math" :depends-on ("base"))
   (:file "defaults" :depends-on ("math"))
   (:file "perlin" :depends-on ("math"))
   (:file "statistics" :depends-on ("base"))
   (:file "kernel" :depends-on ("defaults" "math" "statistics"))
   (:file "kd-tree" :depends-on ("kernel"))
   (:file "mixins" :depends-on ("defaults"))
   (:file "scene" :depends-on ("kernel" "kd-tree" "mixins"))
   (:file "protocol" :depends-on ("scene"))
   (:file "pattern" :depends-on ("mixins" "protocol"))
   (:module "cameras"
            :depends-on ("package" "base" "math" "protocol" "mixins")
            :components ((:file "orthogonal")
                         (:file "panoramic")
                         (:file "pinhole")))
   (:module "lights"
            :depends-on ("package" "base" "math" "protocol" "mixins" "scene")
            :components ((:file "line-light")
                         (:file "point-light")
                         (:file "solar-light")
                         (:file "spotlight")))
   (:module "objects"
            :depends-on ("package" "base" "math" "protocol" "mixins")
            :components ((:file "csg")
                         (:file "box" :depends-on ("csg"))
                         (:file "cylinder")
                         (:file "mesh")
                         (:file "plane" :depends-on ("csg"))
                         (:file "sphere" :depends-on ("csg"))
                         (:file "triangle")))
   (:module "patterns"
            :depends-on ("package" "base" "math" "protocol" "mixins" "pattern")
            :components ((:file "checker")
                         (:file "gradient")
                         (:file "marble")
                         (:file "wood")))
   (:module "shaders"
            :depends-on ("package" "base" "math" "protocol" "mixins")
            :components ((:file "bump")
                         (:file "composite")
                         (:file "flat")
                         (:file "noise")
                         (:file "phong")
                         (:file "raytrace")
                         (:file "solid")))
   (:file "output" :depends-on ("base"))
   (:file "render" :depends-on ("protocol"))
   (:file "tests" :depends-on ("output" "render" "objects" "shaders" "lights" "cameras"
                                        "patterns"))))
