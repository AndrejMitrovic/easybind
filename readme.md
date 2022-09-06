# Running

Just run `dub run`!

# Reproducing the steps

Preprocess the header file:

```
# Example using WSL (btw don't do this when mixing platforms)
gcc -m64 -E -P portaudio/portaudio.h -o portaudio/portaudio.c
```

And then:

```
dub run
```
