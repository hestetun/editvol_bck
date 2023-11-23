# Edit Volumes Backup

Script for backup of all volumes named with _edit. Backups only the project, from our folderstructure here at Shortcut Oslo. TARs it to a location for safe keeping.
Requires two packages from brew, `rsync` and `mutt`.

```bash
brew install rsync mutt
```



**Make sure that /bin/sh has the proper permissions in MacOS before running this script. Removable volumes usually work, but during my testing they may fail to read fron network volumes. Giving /bin/sh proper access resolves that issue.**

The script can be modified to fit in other environments.
