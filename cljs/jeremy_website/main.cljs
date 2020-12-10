(ns jeremy-website.main
  (:require [jeremy-website.sketches.tree :as tree]))

(enable-console-print!)

(defn fullscreen
  []
  [js/document.body.clientWidth
   (- js/window.innerHeight 120)])

(defn render-sketch
  []
  (tree/sketch {:host "quil-sketch"
                :size (fullscreen)}))

(render-sketch)

(.addEventListener
 js/window
 "resize"
 (fn [_e]
   (render-sketch)))
