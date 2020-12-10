(ns jeremy-website.l-system
  (:require [clojure.core.match :refer [match]]
            [clojure.string :as s]))

(defn parse-probability
  [predecessor]
  (let [prob-str (second (re-find #"\(((\d|\.)+)\)" predecessor))]
    (when prob-str
      (Double/parseDouble prob-str))))

(defn strip-probability
  [predecessor]
  (s/replace predecessor #"\(.*\)" ""))

(defn parse-rule
  [predecessor successor]
  (let [probability (parse-probability predecessor)
        predecessor (strip-probability predecessor)]
    {:probability (or probability 1.0)
     :predecessor predecessor
     :successor (s/split successor #"")}))

(defmacro rules
  "Generates l-system rules.

  Usage:

      (rules
        \"A(0.3)\" -> \"AB\"
        \"A(0.7)\" -> \"BA\"
        \"B\" -> \"A\")

  which expands to:

      [{:probability 0.3
        :predecessor \"A\"
        :successor [\"A\" \"B\"]}
       {:probability 0.7
        :predecessor \"A\"
        :successor [\"B\" \"A\"]}
       {:probability 1
        :predecessor \"B\"
        :successor [\"A\"]}]
  "
  [& rule-forms]
  (let [rule-tuples (partition 3 3 (repeat nil) rule-forms)]
    (vec (map (fn [tuple]
                (match (vec tuple)
                  [(predecessor :guard #(string? %))
                   '->
                   (successor :guard #(string? %))]
                  (parse-rule predecessor successor)))
              rule-tuples))))
