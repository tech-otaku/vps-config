#!/bin/bash
# Steve Ward: 2019-03-18

# if there are more than 7 files whose name matches `tech_otaku_*` in the `/home/steve/mysql-backups` directory then delete all but the latest 7 files
[ $(find /home/steve/mysql-backups -maxdepth 1 -name "tech_otaku_*" | wc -l) -gt 7 ] && ls  /home/steve/mysql-backups/tech_otaku_* -t | tail -n +8 | xargs rm --

# if there are more than 7 files whose name matches `tech_otaku_*` in the `/home/steve/mysql-backups` directory then delete all but the latest 7 files
[ $(find /home/steve/mysql-backups -maxdepth 1 -name "steveward_*" | wc -l) -gt 7 ] && ls  /home/steve/mysql-backups/steveward_* -t | tail -n +8 | xargs rm --

# if there are more than 7 files whose name matches `tech-otaku*` in the `/home/steve/site-backups` directory then delete all but the latest 7 files
[ $(find /home/steve/site-backups -maxdepth 1 -name "tech-otaku*" | wc -l) -gt 7 ] && ls  /home/steve/site-backups/tech-otaku* -t | tail -n +8 | xargs rm --

# if there are more than 7 files whose name matches `steveward*` in the `/home/steve/site-backups` directory then delete all but the latest 7 files
[ $(find /home/steve/site-backups -maxdepth 1 -name "steveward*" | wc -l) -gt 7 ] && ls  /home/steve/site-backups/steveward* -t | tail -n +8 | xargs rm --

