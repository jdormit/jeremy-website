---
title: A DSL for music
author: Jeremy Dormitzer
published: 2018-08-05
---
## Haskell School of Music

I recently discovered Haskell School of Music. It’s a book about algorithmic music, which is awesome because: a) I’ve been obsessed with procedural generation for years and b) I like music as much as I like programming. So you can imagine my excitement when I discovered that someone had written a textbook combining my favorite areas of study.

Haskell School of Music is aimed at intermediate-level CS students, so it covers a lot of the basics of functional programming. It aims to be an introduction to the Haskell programming language while also thoroughly examining computer music. It starts simply by defining the data structures that represent music, and progresses to functional programming concepts, procedurally generating music, and doing signal processing and MIDI interfacing to actually play the songs.

I like Haskell, but I want to write music in Clojure. Why? First of all, because it’s the One True Language (it’s fine if you disagree with me – your opinion is valid even if it’s objectively incorrect). But more importantly, Clojure excels as an environment for writing [domain-specific languages](https://en.wikipedia.org/wiki/Domain-specific_language) (DSLs). And as it turns out, writing algorithmic music using a DSL is a major win. Not only are DSLs expressive enough to portray creative expression, but DSLs written in Lisps are inherently extensible – whereas Haskell’s static typing adds barriers to extensibility. There’s also an excellent music synthesis library for Clojure, [Overtone](https://overtone.github.io/), that I want to be able to take advantage of.

Before we can explore what a DSL for music would look like, we need to understand how HSoM represents music as data.

## Music as data

HSoM breaks music down into its component pieces. It represents music using Haskell data structures:

```haskell
type Octave = Int
data PitchClass = Cff | Cf | C | Dff -- ...etc, all the way to Bss
type Pitch = (PitchClass, Octave)
type Duration = Rational
data Primitive a = Note Duration a
                 | Rest Duration
data Control =
  Tempo Rational
  Transpose Int
  -- ...a bunch more
data Music a =
  Prim (Primitive a)
  | Music a :+: Music a
  | Music a :=: Music a
  | Modify Control (Music a)
```

Many of these type declarations are straightfoward, but a couple bear further discussion. A `PitchClass` is an [algebraic data type](https://wiki.haskell.org/Algebraic_data_type) representing all of the pitches: C#, Ab, F, and so on. By pairing a pitch class with an octave, we get a `Pitch`, which represents a specific note (for instance, middle C would be `(C, 4)`. A `Primitive` is a basic music building block, either a note or a rest. Note that it is [polymorphic](https://wiki.haskell.org/Polymorphism): this is so that we can define types like `Note Duration Pitch` but also types like `Note Duration (Pitch, Loudness)` so that we can attach additional data to a primitive if we need to. A control represents the concept of making a modification to some music by changing the tempo, transposing it, or otherwise changing the output while keeping the underlying notes the same.

The `Music` type is where things get really interesting. It’s an algebraic data type representing the concept of music in general. In fact, it’s powerful enough to fully represent any piece of music, from Hozier to Bach. A `Music` value is one of four possible types: a `Prim`, which is either a note or a rest; a `Modify`, which takes another `Music` as an argument and modifies it in some way; the `:+:` [infix constructor](https://downloads.haskell.org/~ghc/7.2.1/docs/html/users_guide/data-type-extensions.html), which represents two separate `Music` values played sequentially; and the `:=:` infix constructor, which represents two separate `Music` values played simultaneously.

The `Music` type has some important properties. First, it’s polymorphic for the same reason that the `Primitive` type is. This allows us to attach any type of data we want to music primitives, letting us express any musical concept (volume, gain, you name it).

Second, three out of its four constructors are recursive – they take other `Music` values as arguments. This is the key that makes the data model so powerful. It allows you to model arbitrary configurations of notes, e.g. `Note 1/4 (C 4) :=: Note 1/4 (E 4) :=: Note 1/4 (G 4)` is a C major triad, and that expression evaulates to a `Music` value that can itself be passed to `Modify`, `:+:`, or `:=:` to weave it into a larger piece of music.

The result is an extraordinarily concise definition that still manages to encompass all possible pieces of music. Using these data structures, we can describe any song we can imagine.

But as powerful as this data type is, I wouldn’t call it a domain-specific language. The static type system makes it inflexible: how would you combine a `Note 1/8 ((C 4) 8)`, representing a note with pitch and loudness, with a `Note 1/8 (E 4)`, representing a note with just a pitch? Sure, you could write a function to convert from one to the other, but at that point you’ve lost elegance and flexibility.

Here’s where Clojure comes in.

## A DSL for music with Clojure

What would a domain-specific language for music look like in Clojure? I found inspiration in the HTML templating library [Hiccup](https://github.com/weavejester/hiccup). Hiccup represents HTML documents (a graph of complex nested nodes, just like music values) using Clojure vectors, like so:

```clojure
[:div {:class "foo"} [:p "foo"]]
```

The Hiccup vectors are actually a DSL that can describe arbitrary HTML markup. Anything that can be expressed in HTML can be expressed using Hiccup. It straddles the line between data and code – the vector is flexible and expressive enough to represent any web page, but can be manipulated using standard Clojure library functions.

If we apply this idea to the data structure from HSoM, we end up with something like this:

```clojure
;; notes and rests are maps
(def eighth-note-c
  {:duration 1/8
   :pitch [:C 4]})

(def eighth-note-e
  {:duration 1/8
   :pitch [:E 4]})

(def eighth-note-rest
  {:duration 1/8})

;; simultaneous music values
[:= eighth-note-c eighth-note-e]

;; sequential music values
[:+ eighth-note-c eighth-note-rest eighth-note-e]

;; modifying music values
[:modify
 {:tempo 120      ;; the control
  :transpose 3}
 {:duration 1/8   ;; the note
  :pitch [C 4]}]

;; :=, :+, and :modify can operate on any music value,
;; including arbitrary nesting
[:modify {:tempo 120}
  [:+
    [:= {:duration 1/4
         :pitch [D 4]}
      {:duration 1/4
       :pitch [F 4]}]
    [:= {:duration 1/4
         :pitch [C 4]}
      {:duration 1/4
       :pitch [E 4]}]]]
```

At first glance, this looks the same as the Haskell data types from HSoM. Both representations represent notes with pitch and duration; both use the `:modify`, `:=` and `:+` operators to compose music; both support recursive composition of any depth.

But the Clojure version is actually more expressive and flexible than the Haskell equivalent. A note can have any metadata we want attached:

```clojure
{:duration 1/4
 :pitch [:C 4]
 :loudness 6}
```

Our DSL has no problem composing notes with differing metadata:

```clojure
[:+
 {:duration 1/4
  :pitch [:C 4]
  :loudness 6}
  :pitch [:Eb 4]
  :staccato true}]
```

Furthermore, because Clojure is dynamically typed and supports [duck typing](https://en.wikipedia.org/wiki/Duck_typing) via map keywords, we can write functions that operate on all notes and music values, even those with unexpected metadata.

Like the Hiccup vectors, our music vectors blur the boundary between a DSL and a data structure. The vectors are expressive enough to represent any musical concept, but can still be passed around and operated on by normal Clojure functions. As an added advantage, the vectors look similar enough to the HSoM data structures that I can easily follow along with the textbook using Clojure and Overtone.

## What's next

So I have a way to represent music in Clojure now. What’s next? Haskell School of Music ships with a library called Euterpea that knows how to turn the Music data structure into actual sound. So the next step for me is probably porting something like that to Clojure. I’m hoping to offload most of that work to Overtone. After that, I’ll explore algorithmic composition using the techniques outlined in HSoM. Stay tuned!

