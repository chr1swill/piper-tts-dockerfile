import { exec } from 'node:child_process';

// cd .. && echo $(cat /path/to/input.txt) | docker run -i -v /path/to/ouput/dir/:/piper/output piper-env
// "/piper/output/piper_output.wav"

const stdin = process.stdin;

stdin.on('error', function(err) {
    console.error(err);
});

stdin.on('data', function(data) {
    console.log('data: ', data);
    const stringArray = data.toString().split('\n');
    console.log('stringArray: ', stringArray);

    /**@type{Array<string>}*/
    const jsonArray = new Array();

    for (let i = 0; i < stringArray.length; i++) {
        if (stringArray[i].trim() === "") continue; // skip emtpy lines

        const arrayEntry = Object.create(null);
        arrayEntry["text"] = stringArray[i];
        arrayEntry["output_file"] = `/piper/output/${i}.wav`;
        jsonArray[i] = JSON.stringify(arrayEntry);
    };

    console.log(jsonArray.join("\n"));
    const currentTime = Date.now();

   exec(`cd .. && mkdir -p ~/Downloads${currentTime} '${jsonArray.join("\n")}' | docker run -i -v ~/Downloads/${currentTime}:/piper/output piper-env`, function(error, stdout, stderr) {
       if (error) {
           console.error("Error: ", error);
           return;
       };

       console.log('stdout:');
       console.log(`\t${stdout}`);
       console.log('stderr:');
       console.log(`\t${stderr}`);
   });
});

stdin.on('end', function() {
    console.log("stdin ended");
});
