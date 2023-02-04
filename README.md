# Pragmasevka Font

Here is comparison with PragmataPro (black, image taken from [Wikipedia](https://en.wikipedia.org/wiki/PragmataPro)):

![Comparison with PragmataPro](https://github.com/shytikov/pragmasevka/blob/main/sample.png?raw=true)

Yes, it's not a carbon copy. But metrics are pretty close. 

## The story

Do you love [PragmataPro](https://fsd.it/shop/fonts/pragmatapro/) as I am? Probabbly you do, if you're reading this.

`PragmataPro` is awesome. It's condensed enough, but not too much. Its ``xHeight`` is spot on. Every character seems to be of the best possible shape for readability. There is no better font if you want to make most out of the screen real estate. But there is a catch: although it worth every penny, `PragmataPro` is not free.

There were many attemps to achieve same goals as `PragmataPro` did: condensed with increased `xHeight`. I can name a few:

- [Input](https://input.djr.com/);
- [Monoid](https://larsenwork.com/monoid/);
- [Victor Mono](https://rubjo.github.io/victor-mono/);
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/);

But [Iosevka](https://github.com/be5invis/Iosevka) stands out of the croud the most. The sole intention from very beginning of this font was to immitate `PragmataPro` as closely as possible. And first public versions proves that. But with time the font matured to a framework that able to provide much more than just a copy of very good font.

Till the day we have `SS08` stylistic set of `Iosevka` that mimics `PragmataPro`. But does it the best possible job?  

## Improving Iosevka SS08

Investigating public images of text written in `PragmataPro` and having quite limited time and resources I was able to spot following differences between The Original and `SS08`:

- xHeight of SS08 seems to be smaller;
- Line height of SS08 seems to be larger;
- SS08 Regular looks a tiny bit thiner;
- SS08 Bold looks noticably thiner;
- `Zero` glyph in SS08 is not reverse slashed oval octagon (it gives me shivers);
- `Z` glyph in SS08 lacks slight curves;

Luckly `Iosevka` allows some very sophisticated tweaking, so I have tried my best to improve on "poor man's Pragmata" by fixing these.

## I want one

Head to [Releases](https://github.com/shytikov/pragmasevka/releases) and pick the archive you like: the bare build or [Nerd Fonts](https://www.nerdfonts.com/) enabled one.

You can also build it locally by running:

```sh
make builder && make font
```

## Improving it

Let's face it – `PragmataPro` is perfect. And we all should buy it. And I will go it too exactly that day I would get bored from playing with `Iosevka`. And meanwhile if you have spotted something that could be improved, please file an [issue](https://github.com/shytikov/pragmasevka/issues).
