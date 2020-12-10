(ns jeremy-website.sketches.tree
  (:require [jeremy-website.l-system :as l-system :include-macros true]
            [quil.core :as q]
            [quil.middleware :as m]))

(defn degrees->radians [deg]
  (* deg (/ js/Math.PI 180)))

(defn l-system-lines
  [{:keys [segment-length initial-angle initial-x initial-y l-system]}]
  (vec
   (:lines
    (reduce
     (fn [{:keys [x y angle angle-stack position-stack depth lines] :as state}
          symbol]
       (condp = symbol
         "F" (let [new-x (+ x (* segment-length
                                 (js/Math.cos (degrees->radians angle))))
                   new-y (+ y (* (- segment-length)
                                 (js/Math.sin (degrees->radians angle))))
                   line {:x1 x :y1 y :x2 new-x :y2 new-y}]
               (assoc state
                      :x new-x
                      :y new-y
                      :lines (conj lines (assoc line :depth depth))))
         "+" (assoc state :angle (+ angle 25))
         "-" (assoc state :angle (- angle 25))
         "*" (assoc state :angle (+ angle 20))
         "/" (assoc state :angle (- angle 20))
         ">" (assoc state :angle (+ angle 15))
         "<" (assoc state :angle (- angle 15))
         "[" (assoc state
                    :angle-stack (conj angle-stack angle)
                    :position-stack (conj position-stack [x y])
                    :depth (inc depth))
         "]" (assoc state
                    :angle (peek angle-stack)
                    :angle-stack (pop angle-stack)
                    :x (first (peek position-stack))
                    :y (second (peek position-stack))
                    :position-stack (pop position-stack)
                    :depth (dec depth))
         state))
     {:angle initial-angle
      :angle-stack [initial-angle]
      :x initial-x
      :y initial-y
      :position-stack [[initial-x initial-y]]
      :depth 0
      :lines []}
     (:state l-system)))))

(defn setup []
  ;; Hue goes from 0-360, saturation/brightness from 0-100
  (q/color-mode :hsb 360 100 100)
  (q/frame-rate 60)
  (q/random-seed (or (-> (js/URLSearchParams. js/window.location.search)
                         (.get "seed"))
                     (.now js/Date)))
  (let [l-system (-> (l-system/instantiate {:axiom "X"
                                            :rules (l-system/rules
                                                    "X(0.4)" -> "F+[[X]-X]-F[-FX]+X"
                                                    "X(0.4)" -> "F*[[X]/X]/F[/FX]*X"
                                                    "X(0.2)" -> "F>[[X]<X]<F[<FX]>X"
                                                    "F" -> "FF")
                                            :random-fn (partial q/random 1)})
                     ((apply comp (repeat 6 l-system/step))))
        lines (l-system-lines {:initial-angle (- 90 25)
                               :segment-length 6
                               :initial-x (* (q/width) 0.1)
                               :initial-y (* (q/height) 0.95)
                               :l-system l-system})]
    {:to-draw lines
     :drawing []}))

(defn update-state [{:keys [to-draw drawing] :as state}]
  (let [batch-size 10]
    (if (> (count to-draw) 0)
      (assoc state
             :to-draw (vec (drop batch-size to-draw))
             :drawing (vec (concat drawing (take batch-size to-draw))))
      state)))

(defn dedupe-lines [lines]
  (:lines
   (reduce (fn [{:keys [lines already-seen] :as state} line]
             (if-not (contains? already-seen ((juxt :x1 :y1 :x2 :y2) line))
               (assoc state
                      :already-seen (conj already-seen ((juxt :x1 :y1 :x2 :y2) line))
                      :lines (conj lines line))
               state))
           {:lines []
            :already-seen #{}}
           lines)))

(defn draw [{:keys [to-draw drawing]}]
  (q/background 0 0 100)
  (q/fill 0 0 0)
  (let [lines (dedupe-lines drawing)]
    (doseq [line lines]
      (q/stroke-weight (- 1.75 (* 0.1 (:depth line))))
      (q/stroke 240 0 (+ 65 (* 2 (:depth line))))
      (apply q/line ((juxt :x1 :y1 :x2 :y2) line))))
  (when (= (count to-draw) 0)
    (q/no-loop)))

(defn sketch
  [{:keys [host size]}]
  (q/sketch
   :host host
   :middleware [m/fun-mode]
   :size size
   :setup setup
   :update update-state
   :draw draw))
