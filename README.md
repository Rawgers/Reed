# Reed

## Setup:
1. Clone the repo.
2. `cd` to Reed and run `pod install`.
3. Download a gzipped, jsonified JMdict_e file (see below) and add it `Reed/Reed/Dictionary`.
4. Build the project (`CMD+B`) and test targets (`CMD+Shift+U`).
5. You can uncomment and run the unit test `ReedTests/Dictionary/DictionaryParserTests: testReadInDictionaryData` to see if you have your dictionary set up correctly.
6. Run the project (`CMD+R`) and wait at the splash screen to load the dictionary into Core Data (this may take 6+ minutes on Simulator).

## How to get a dictionary file
### Option 1:
1. Download it from the Reed Dropbox root directory.
* This dictionary was last updated 9/17/20, so it may be outdated.

### Option 2 (if you need the absolute latest version):
1. Download from the official link: 
  a) http://ftp.monash.edu/pub/nihongo/JMdict_e.gz
2. Unzip the file.
3. Clone the JMdict-parser repo by tkshnwesper: https://github.com/tkshnwesper/JMdict-Parser#readme
4. Install its dependencies: `npm i -g jmdict-parser`
5. Convert the unzipped dictionary to json: `jmdict-parser <your_jmdict_xml_file>`
6. Compress the json file: `gzip <your_jmdict_json_file>`
