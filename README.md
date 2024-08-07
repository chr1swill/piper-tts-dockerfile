# Piper TTS DockerFile

This version of was created for Mac OS.

[piper-tts-repo](https://github.com/rhasspy/piper?tab=readme-ov-file#readme)

## Usage 

First build the image: 

```bash
docker buildx b -t piper-env .
```

Note:
    Each string of text up to the new line char ('\n') will be outputed to a file named as follows <line_number>.wav

Run image:

```bash
cat /path/to/your/input/text/file.txt | time ./file-per-line.sh
```
