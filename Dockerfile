FROM arm64v8/ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    espeak-ng \
    cmake \
    git \
    build-essential \
    bash \ 
    curl

# Clone and build piper
RUN git clone https://github.com/rhasspy/piper.git /piper
WORKDIR /piper
RUN mkdir build && cd build && cmake .. && make

# Set the ESPEAK_DATA_PATH environment variable
ENV ESPEAK_DATA_PATH=/usr/share/espeak-ng-data
RUN mkdir -p /usr/share/espeak-ng-data
RUN cp -r /piper/build/pi/share/espeak-ng-data /usr/share/espeak-ng-data

RUN mkdir -p /piper/model_files
RUN curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/ryan/high/en_US-ryan-high.onnx?download=true -o /piper/model_files/en_US-ryan-high.onnx
RUN curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/ryan/high/en_US-ryan-high.onnx.json?download=true -o /piper/model_files/en_US-ryan-high.onnx.json

RUN chmod +x /piper/build/piper

RUN mkdir -p /piper/output

###
# Run using this command (assuming the container name is 'piper-env'):
# echo $(cat /path/to/input.txt) | docker run -i -v /path/to/ouput/dir/:/piper/output piper-env
###
CMD ["/piper/build/piper", "--model", "/piper/model_files/en_US-ryan-high.onnx", "--output_file","/piper/output/piper_output.wav"]
