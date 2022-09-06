# Warning

Be aware that there is a shared library in the repo: `portaudio_x64.dll`

It's bad practice to load random DLLs off the web, so only use this repo as an example.

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
