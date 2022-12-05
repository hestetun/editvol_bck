# scn-projectbackup
This is a playground for developing a inhouse script for backing up edit_vols


SYNTAX EXPLINATION

zip -r -q -T -m -9
-r: Recursively traverse any subdirectories (including compressed archives) and add the contents of those directories to the ZIP archive.
-q: Quiet mode. Suppress any output messages.
-T: Test the integrity of the compressed files.
-m: Move files into the ZIP archive instead of copying them. This will delete the original files after they have been added to the archive.
-9: Compression level `0` - the lowest, `9` - the highest
