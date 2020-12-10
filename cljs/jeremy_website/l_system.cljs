(ns jeremy-website.l-system)

;; TODO support context-sensitive grammers? This is where a production
;; rule can apply only if the symbol in question occurs between
;; specific other symbols

(defn rules-for-symbol
  [symbol rules]
  (filter #(= (:predecessor %) symbol) rules))

(defn choose-rule [random-fn rules]
  (let [random (random-fn)
        iter-fn (fn [[rule & rules] current-prob]
                  (cond
                    (nil? rule) nil
                    (< random (+ current-prob
                                 (:probability rule))) rule
                    :else (recur rules (+ current-prob
                                          (:probability rule)))))
        selected (iter-fn rules 0)]
    (or selected (first rules))))

(defn apply-rules
  [rules random-fn symbol]
  (let [rules-for-symbol (rules-for-symbol symbol rules)
        selected-rule (choose-rule random-fn rules-for-symbol)]
    (if selected-rule
      (:successor selected-rule)
      [symbol])))

(defn step
  "Applies the l-system rules once"
  [{:keys [rules state random-fn] :as l-system}]
  (let [new-state (mapcat (partial apply-rules rules random-fn) state)]
    (assoc l-system :state (vec new-state))))

(defn instantiate
  "Instantiates a new L-system"
  [{:keys [rules axiom random-fn] :or {random-fn rand}}]
  {:rules rules
   :axiom (vec axiom)
   :state (vec axiom)
   :random-fn random-fn})
