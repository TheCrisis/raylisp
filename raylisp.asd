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
   (:file "scene" :depends-on ("kernel" "kd-tree"))
   (:file "protocol" :depends-on ("scene"))
   (:file "component" :depends-on ("protocol"))
   (:module "objects"
            :depends-on ("package" "base" "math" "protocol" "component")
            :components ((:file "box")
                         (:file "plane")
                         (:file "sphere")))
   (:module "shaders"
            :depends-on ("package" "base" "math" "protocol" "component")
            :components ((:file "marble")
                         (:file "wood")))
   (:file "camera" :depends-on ("protocol"))
   (:file "output" :depends-on ("base"))
   (:file "render" :depends-on ("camera"))
   (:file "tests" :depends-on ("output" "render" "component" "objects" "shaders"))))
